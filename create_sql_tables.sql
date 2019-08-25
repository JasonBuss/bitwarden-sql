/********************************************/
/* Written By: Jason Buss                   */
/* Created on: 2019-08-25                   */
/********************************************/
USE bwArchive

/* Drop tables */
IF OBJECT_ID('dbo.folder', 'U') IS NOT NULL
  DROP TABLE dbo.folder;
IF OBJECT_ID('dbo.item', 'U') IS NOT NULL
  DROP TABLE dbo.item;
IF OBJECT_ID('dbo.field', 'U') IS NOT NULL
  DROP TABLE dbo.field;
IF OBJECT_ID('dbo.[login]', 'U') IS NOT NULL
  DROP TABLE dbo.[login];
IF OBJECT_ID('dbo.login_uri', 'U') IS NOT NULL
  DROP TABLE dbo.login_uri;
IF OBJECT_ID('dbo.[identity]', 'U') IS NOT NULL
  DROP TABLE dbo.[identity];
IF OBJECT_ID('dbo.[card]', 'U') IS NOT NULL
  DROP TABLE dbo.[card];

/* Create Tables */
CREATE TABLE dbo.folder
(	folderid UNIQUEIDENTIFIER PRIMARY KEY,
	folder_name nvarchar(128)
);
CREATE TABLE dbo.item
(	itemid UNIQUEIDENTIFIER PRIMARY KEY,
	organizationid uniqueidentifier,
	folderid uniqueidentifier,
	type int,
	name nvarchar(128),
	notes nvarchar(max),
	favorite nvarchar(5),
	collectionIds uniqueidentifier
);
CREATE TABLE dbo.field
(	itemid UNIQUEIDENTIFIER,
	field_name nvarchar(32),
	field_value nvarchar(32),
	field_type int
);
CREATE TABLE dbo.[login]
(	itemid UNIQUEIDENTIFIER,
	username nvarchar(64),
	password nvarchar(256),
	totp nvarchar(256)
);
CREATE TABLE dbo.login_uri
(	itemid UNIQUEIDENTIFIER,
	match varchar(5),
	uri nvarchar(max)
);
CREATE TABLE dbo.[identity]
(	itemid UNIQUEIDENTIFIER,
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
CREATE TABLE dbo.[card]
(	itemid UNIQUEIDENTIFIER,
	cardHolderName nvarchar(64),
	brand nvarchar(32),
	number nvarchar(32),
	expMonth int,
	expYear int,
	code int
);