select relname, pg_relation_size(t.toid)/1024 as "sizeK", pg_relation_size(t.toid)/1024/1024 as "sizeM" ,
	pg_relation_size(t.toid)/1024/1024/1024 as "sizeG" ,  round(( t.reltuples / 10000)::numeric , 0) as "count_wan",
        t.reltuples,
        t.relkind ,  --r =普通表， i =索引，S =序列，v =视图，m =物化视图， c =复合类型，t = TOAST表，f =外部表
        'select count(*) from ' || it.table_schema || '.' || it.table_name || '; ' esql
  from ( select oid as toid, * from  pg_class ) as t left  join  information_schema.tables as it on  t.relname = it.table_name
  WHERE 1=1 and t.relkind = 'i'
order by pg_relation_size(t.toid) DESC
;


select t.relkind,  round( sum( pg_relation_size(t.toid))/1024/1024/1024, 2) as "sizeG" 
  from ( select oid as toid, * from  pg_class ) as t left  join  information_schema.tables as it on  t.relname = it.table_name
  group by t.relkind
;


