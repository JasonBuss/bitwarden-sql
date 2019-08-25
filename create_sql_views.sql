/********************************************/
/* Written By: Jason Buss                   */
/* Created on: 2019-08-25                   */
/********************************************/

IF object_id(N'dbo.vw_allItems', 'V') IS NOT NULL
	DROP VIEW dbo.vw_allItems
GO

CREATE VIEW dbo.vw_allItems AS
SELECT
	isnull(b.folder_name, '<<none>>') as [Folder Name]
,	c.typeValue as [Type]
,	A.NAME AS [Item Name]
,	a.notes as Notes
,	a.favorite as IsFavorite
,	a.created as CreatedOn
from item a
left join folder b on a.folderid = b.folderid
inner join item_type c on a.type = c.item_typeid

select * from dbo.vw_allItems