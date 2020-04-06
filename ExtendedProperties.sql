/*
SQL Server can store a large volume of data in relational formats which is great for the business, 
but business users and developers also have needs to store documentation and information related to the SQL Server objects. 
One way to do this is to use Extended Properties which allows you to save information about the objects 
such as what it's for, specific formats like phone format, date format, description of objects, URLs, website links and so on.
*/

Create Table ExtendedProperty
(
	 id int identity(1,1)
	,name varchar(10)
	,remark varchar(20)
)

--Let say we want to create above table
--Extended Property can be used when no. of columns is more, same column name is present in another table
--it is like adding some info on the column why it is created


--Let's Get Started
exec sp_addextendedproperty  
     @name = N'name' 
    ,@value = N'Username varchar(10)' 
    ,@level0type = N'Schema', @level0name = 'dbo' 
    ,@level1type = N'Table',  @level1name = 'ExtendedProperty' 
    ,@level2type = N'Column', @level2name = 'name'
go		


/*sp_addextendedproperty.
@name is ‘SNO’ in our case. This cannot be null. This is the name of the Extended Property.
@value is the value or description of the property and it cannot exceed 7500 bytes.
@level0type in our case ‘Schema’ and @level0name is the value is set as 'dbo' as the value
@level1type in our case ‘Table’ and @level1name is ‘mytest’
@level2type in our case ‘Column’ and @level2name is ‘sno’*/

--Retrive the property specified
SELECT
   SCHEMA_NAME(tbl.schema_id) AS SchemaName,	
   tbl.name AS TableName, 
   clmns.name AS ColumnName,
   p.name AS ExtendedPropertyName,
   CAST(p.value AS sql_variant) AS ExtendedPropertyValue
FROM
   sys.tables AS tbl
   INNER JOIN sys.all_columns AS clmns ON clmns.object_id=tbl.object_id
   INNER JOIN sys.extended_properties AS p ON p.major_id=tbl.object_id AND p.minor_id=clmns.column_id AND p.class=1
WHERE
   SCHEMA_NAME(tbl.schema_id)='dbo'
   and tbl.name='ExtendedProperty' 


--Alter the Extended Property
exec sp_updateextendedproperty  
     @name = N'name' 
    ,@value = N'Username varchar(10) altered' 
    ,@level0type = N'Schema', @level0name = 'dbo' 
    ,@level1type = N'Table',  @level1name = 'ExtendedProperty' 
    ,@level2type = N'Column', @level2name = 'name'
go		


--Drop Extended Property
exec sp_dropextendedproperty 
     @name = N'name' 
    ,@level0type = N'Schema', @level0name = 'dbo' 
    ,@level1type = N'Table',  @level1name = 'ExtendedProperty' 
    ,@level2type = N'Column', @level2name = 'name'
go	



--Use the inbuilt function to retrive the information
SELECT *
FROM ::fn_listextendedproperty ('name', NULL,NULL,NULL,NULL,NULL,NULL)	


SELECT *
FROM fn_listextendedproperty (NULL, 'Schema', 'dbo', 'Table', 'ExtendedProperty', 'Column', 'name')	





--||--

--Store Procedure extended Property


Create Proc tsp_extendedproperty
AS
begin
	select 1
end

EXEC sys.sp_addextendedproperty
         @name = N'tsp_extendedproperty SP',
         @value = N'This is a testing extended properties on SP',
         @level0type = N'SCHEMA',  @level0name = 'dbo',
         @level1type = N'PROCEDURE', @level1name = 'tsp_extendedproperty';

exec sp_updateextendedproperty
		 @name = N'tsp_extendedproperty SP',
         @value = N'This is a testing extended properties on SP altered',
         @level0type = N'SCHEMA',  @level0name = 'dbo',
         @level1type = N'PROCEDURE', @level1name = 'tsp_extendedproperty';


/*
A. Adding an extended property to a database
The following example adds the property name 'Caption' with a value of 'AdventureWorks2012 Sample OLTP Database' to the AdventureWorks2012 sample database.


Copy
USE AdventureWorks2012;  
GO  
--Add a caption to the AdventureWorks2012 Database object itself.  
EXEC sp_addextendedproperty   
@name = N'Caption',   
@value = 'AdventureWorks2012 Sample OLTP Database';  
B. Adding an extended property to a column in a table
The following example adds a caption property to column PostalCode in table Address.


Copy
USE AdventureWorks2012;  
GO  
EXEC sp_addextendedproperty   
@name = N'Caption',   
@value = 'Postal code is a required column.',  
@level0type = N'Schema', @level0name = 'Person',  
@level1type = N'Table',  @level1name = 'Address',  
@level2type = N'Column', @level2name = 'PostalCode';  
GO  
C. Adding an input mask property to a column
The following example adds an input mask property '99999 or 99999-9999 or #### ###' to the column PostalCode in the table Address.


Copy
USE AdventureWorks2012;  
GO  
EXEC sp_addextendedproperty   
@name = N'Input Mask ', @value = '99999 or 99999-9999 or #### ###',  
@level0type = N'Schema', @level0name = 'Person',  
@level1type = N'Table', @level1name = 'Address',   
@level2type = N'Column',@level2name = 'PostalCode';  
GO  
D. Adding an extended property to a filegroup
The following example adds an extended property to the PRIMARY filegroup.


Copy
USE AdventureWorks2012;  
GO  
EXEC sys.sp_addextendedproperty   
@name = N'MS_DescriptionExample',   
@value = N'Primary filegroup for the AdventureWorks2012 sample database.',   
@level0type = N'FILEGROUP', @level0name = 'PRIMARY';  
GO  
E. Adding an extended property to a schema
The following example adds an extended property to the HumanResources schema.


Copy
USE AdventureWorks2012;  
GO  
EXECUTE sys.sp_addextendedproperty   
@name = N'MS_DescriptionExample',  
@value = N'Contains objects related to employees and departments.',  
@level0type = N'SCHEMA',   
@level0name = 'HumanResources';  
F. Adding an extended property to a table
The following example adds an extended property to the Address table in the Person schema.


Copy
USE AdventureWorks2012;  
GO  
EXEC sys.sp_addextendedproperty   
@name = N'MS_DescriptionExample',   
@value = N'Street address information for customers, employees, and vendors.',   
@level0type = N'SCHEMA', @level0name = 'Person',  
@level1type = N'TABLE',  @level1name = 'Address';  
GO  
G. Adding an extended property to a role
The following example creates an application role and adds an extended property to the role.


Copy
USE AdventureWorks2012;   
GO  
CREATE APPLICATION ROLE Buyers  
WITH Password = '987G^bv876sPY)Y5m23';   
GO  
EXEC sys.sp_addextendedproperty   
@name = N'MS_Description',   
@value = N'Application Role for the Purchasing Department.',  
@level0type = N'USER',  
@level0name = 'Buyers';  
H. Adding an extended property to a type
The following example adds an extended property to a type.


Copy
USE AdventureWorks2012;   
GO  
EXEC sys.sp_addextendedproperty   
@name = N'MS_Description',   
@value = N'Data type (alias) to use for any column that represents an order number. For example a sales order number or purchase order number.',   
@level0type = N'SCHEMA',   
@level0name = N'dbo',   
@level1type = N'TYPE',   
@level1name = N'OrderNumber';  
I. Adding an extended property to a user
The following example creates a user and adds an extended property to the user.


Copy
USE AdventureWorks2012;   
GO  
CREATE USER CustomApp WITHOUT LOGIN ;   
GO  
EXEC sys.sp_addextendedproperty   
@name = N'MS_Description',   
@value = N'User for an application.',   
@level0type = N'USER',   
@level0name = N'CustomApp';  
*/