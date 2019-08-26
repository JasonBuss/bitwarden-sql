/********************************************/
/* Written By: Jason Buss                   */
/* Created on: 2019-08-25                   */
/********************************************/
/* Main script to run all SPs               */
/********************************************/

Declare @JSON varchar(max);

SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK 'c:\Import\bitwarden_export.JSON', SINGLE_CLOB) as j;

EXECUTE dbo.sp_ProcessFolders @JSON
GO