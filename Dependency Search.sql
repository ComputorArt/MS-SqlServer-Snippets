  select sch.name AS 'Schema Name',obj.name AS 'Object',refSch.name AS 'Ref Schema Name',    
  refobject.name AS 'Ref Object',' Ref Type Desc' = refobject.type_desc--,depends.referencing_id,refobject.object_id,obj.object_id,refobject.schema_id    
  from sys.objects obj    
  JOIN sys.sql_expression_dependencies depends on obj.object_id = depends.referencing_id    
  LEFT JOIN sys.objects refobject on depends.referenced_id = refobject.object_id    
  LEFT JOIN sys.schemas sch on obj.schema_id = sch.schema_id    
  LEFT JOIN sys.schemas refSch on refobject.schema_id = refSch.schema_id    
  --where  obj.name like '%<ObjectName>%'     
 