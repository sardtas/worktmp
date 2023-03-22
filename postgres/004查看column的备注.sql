select c.relname 表名,cast(obj_description(relfilenode,'pg_class') as varchar) 名称,
a.attname 字段,d.description 字段备注,
concat_ws('',t.typname,SUBSTRING(format_type(a.atttypid,a.atttypmod) from '\(.*\)')) as 列类型 
from pg_class c,pg_attribute a,pg_type t,pg_description d
where a.attnum>0 and a.attrelid=c.oid and a.atttypid=t.oid and d.objoid=a.attrelid and d.objsubid=a.attnum
--and c.relname in (select tablename from pg_tables where -- schemaname='public' and 
--position('_2' in tablename)=0) 
and d.description like '%付%'
order by c.relname,a.attnum







     