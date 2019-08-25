Declare @FolderData table (
	id UNIQUEIDENTIFIER PRIMARY KEY,
	[name] nvarchar (128)
);
Declare @ItemData table (
	id uniqueidentifier primary key,
	organizationid uniqueidentifier,
	folderid uniqueidentifier,
	type int,
	name nvarchar(128),
	notes nvarchar(max),
	favorite nvarchar(5),
	collectionIds uniqueidentifier
);
Declare @Fields table (
	id uniqueidentifier,
	field_name nvarchar(32),
	field_value nvarchar(32),
	field_type int
);
Declare @Logins Table (
	id uniqueidentifier,
	username nvarchar(64),
	password nvarchar(256),
	totp nvarchar(256)
);
Declare @Login_Uris table(
	id uniqueidentifier,
	match varchar(5),
	uri nvarchar(max)
);
Declare @Identities table (
	id uniqueidentifier,
	title nvarchar(32),
	firstName nvarchar(32),
	middleName nvarchar(32),
	lastName nvarchar(32),
	address1 nvarchar(32),
	address2 nvarchar(32),
	address3 nvarchar(32),
	city nvarchar(32),
	state nvarchar(32),
	postalcode nvarchar(32),
	country nvarchar(32),
	company nvarchar(32),
	email nvarchar(128),
	phone nvarchar(32),
	ssn nvarchar(32),
	username nvarchar(32),
	passportNumber nvarchar(32),
	licenseNumber nvarchar(32)
);

Declare @Cards table (
	id uniqueidentifier,
	cardHolderName nvarchar(64),
	brand nvarchar(32),
	number nvarchar(32),
	expMonth int,
	expYear int,
	code int
);

Declare @JSON varchar(max);

SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK 'c:\Import\bitwarden_export.JSON', SINGLE_CLOB) as j;

--select (@json);

insert into @FolderData (id, [name])
select id, [name] 
from OPENJSON (@json, '$.folders')
WITH (
	id UNIQUEIDENTIFIER '$.id',
	[name] nvarchar(128) '$.name'
);

Insert into @ItemData (id, organizationid, folderid, type, name, notes, favorite, collectionIds)
select id,
	organizationid,
	folderid,
	type,
	name,
	notes,
	favorite,
	collectionIds
from OPENJSON (@json, '$.items')
WITH ( 
	id uniqueidentifier '$.id',
	organizationId uniqueidentifier '$.organizationId',
	folderId uniqueidentifier '$.folderId',
	type int '$.type',
	name nvarchar(128) '$.name',
	notes nvarchar(max) '$.notes',
	favorite nvarchar(5) '$.favorite',
	collectionIds uniqueidentifier '$.collectionIds'
);

Insert into @Fields (id, field_name, field_value, field_type)
select id,
	name,
	value,
	type
from OPENJSON (@json, '$.items')
WITH ( 
	id uniqueidentifier '$.id',
	fields nvarchar(max) '$.fields' as json)
	outer apply openjson (fields)
	with (
		name nvarchar(32) '$.name',
		value nvarchar(32) '$.value',
		type int '$.type') as a
		where a.name is not null and a.value is not null and a.type is not null;

insert into @Logins (id, username, password, totp)
select id,
	username,
	password,
	totp
from OPENJSON (@json, '$.items')
WITH ( 
	id uniqueidentifier '$.id',
	login nvarchar(max) '$.login' as json)
	outer apply openjson (login)
	with (
		username nvarchar(64) '$.username',
		password nvarchar(256) '$.password',
		totp nvarchar(256) '$.totp') as a
		where a.username is not null and a.password is not null;



insert into @Login_Uris (id, match, uri)
select id,
	match,
	uri
from OPENJSON (@json, '$.items')
WITH ( 
	id uniqueidentifier '$.id',
	uris nvarchar(max) '$.login.uris' as json)
	outer apply openjson (uris)
	with (
		match nvarchar(5) '$.match',
		uri nvarchar(max) '$.uri') as a
		where a.uri is not null;

Insert into @Identities (id,title,firstName,middleName,lastName,address1,address2,address3,city,state,postalcode,country,company,email,phone,ssn,username,passportNumber,licenseNumber)
select id,
	title,
	firstName,
	middleName,
	lastName,
	address1,
	address2,
	address3,
	city,
	state,
	postalcode,
	country,
	company,
	email,
	phone,
	ssn,
	username,
	passportNumber,
	licenseNumber
from OPENJSON (@json, '$.items')
WITH ( 
	id uniqueidentifier '$.id',
	[identity] nvarchar(max) '$.identity' as json)
	outer apply openjson ([identity])
	with (
		title nvarchar(32) '$.title',
		firstName nvarchar(32) '$.firstName',
		middleName nvarchar(32) '$.middleName',
		lastName nvarchar(32) '$.lastName',
		address1 nvarchar(32) '$.address1',
		address2 nvarchar(32) '$.address2',
		address3 nvarchar(32) '$.address3',
		city nvarchar(32) '$.city',
		state nvarchar(32) '$.state',
		postalcode nvarchar(32) '$.postalcode',
		country nvarchar(32) '$.country',
		company nvarchar(32) '$.company',
		email nvarchar(128) '$.email',
		phone nvarchar(32) '$.phone',
		ssn nvarchar(32) '$.ssn',
		username nvarchar(32) '$.username',
		passportNumber nvarchar(32) '$.passportNumber',
		licenseNumber nvarchar(32) '$.licenseNumber') as a
		where a.firstName is not null and a.lastName is not null;

Insert into @Cards (id,cardHolderName,brand,number,expMonth, expYear,code)
select
	id,
	cardHolderName,
	brand,
	number,
	expMonth,
	expYear,
	code
from OPENJSON (@json, '$.items')
WITH ( 
	id uniqueidentifier '$.id',
	card nvarchar(max) '$.card' as json)
	outer apply openjson (card)
	with (
		cardholderName nvarchar(64) '$.cardholderName',
		brand nvarchar(32) '$.brand',
		number nvarchar(32) '$.number',
		expMonth int '$.expMonth',
		expYear int '$.expYear',
		code int '$.code') as a
		where a.number is not null;

/******************************************************/

/* Show Data */
select * from @FolderData;
select * from @ItemData;
select * from @Fields;
select * from @Logins;
select * from @Login_Uris;
select * from @Identities;
select * from @Cards;