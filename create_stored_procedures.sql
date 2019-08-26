/********************************************/
/* Written By: Jason Buss                   */
/* Created on: 2019-08-25                   */
/********************************************/
/* Handles CUD tasks for folder table       */
/********************************************/

-- Drop stored procedure if it already exists
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'sp_ProcessFolders' 
)
   DROP PROCEDURE dbo.sp_ProcessFolders
GO

CREATE PROCEDURE dbo.sp_ProcessFolders
	@p1 nvarchar(max)
	
AS
SET NOCOUNT ON;

	Declare @Folders table (
		recid int identity primary key,
		id uniqueidentifier,
		name varchar(32)
	);

	insert into @Folders (id, name)
	select id, [name] 
	from OPENJSON (@p1, '$.folders')
	WITH (id UNIQUEIDENTIFIER '$.id',
	[name] nvarchar(128) '$.name');

	Declare @RecCnt int;
	select @RecCnt = count (id) from @Folders;

	Declare @id uniqueidentifier
	Declare @FolderName nvarchar(128)
	Declare @x int = 1;
	Declare @itCnt int;
	Declare @currentVal nvarchar(128);

	while @x <> @RecCnt + 1 --loop through records
	begin

		select @ID = id, @FolderName = name from @Folders where recid = @x;
		--print @id;
		select @itCnt = count (*) from dbo.folder where folderid = @id;
		if (@itCnt = 0)
		begin
			/* Insert new folders */
			insert into dbo.folder (folderid, folder_name) values (@id, @FolderName)
			--print 'Insert';
		end
		else
		begin
			select @currentVal = folder_name from dbo.folder where folderid = @id
			
			if (@currentVal <> @FolderName) --check to see if values should be updated
			Begin
				/* Update existing values */
				update dbo.folder set folder_name = @FolderName, modified = getdate() where folderid = @id;
				--print 'Update';
			End
		end
		set @x = @x + 1;
	end

	/* Delete items not in new backup file */		
	delete from dbo.folder where folderid not in (select id from @Folders);
GO

