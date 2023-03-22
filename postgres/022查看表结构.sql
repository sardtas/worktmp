 SELECT c.relname,                  --表名
 		c.oid, 						--数据库中唯一id号
 		cb.description,				--表说明
 		n.nspname,					--schame名
 		a.attnum,					--字段序号
		a.attname AS field,			--字段名
		t.typname AS type,			--字段类型
		a.attlen AS length,			--数字类型字段长度
		(a.atttypmod -4) AS lengthvar,	--字符串类型字段长度
		a.attnotnull AS notnull,	--字段是否 不能为空(null) 
		b.description AS comment	--字段说明 
   FROM pg_catalog.pg_class c		--存放表
   		left outer join pg_catalog.pg_description cb			--存放说明 
   			 ON c.oid = cb.objoid AND cb.objsubid = 0 
   		LEFT JOIN pg_namespace n ON n.oid = c.relnamespace, 	--存放schame
		pg_catalog.pg_attribute a								--存放字段 
		LEFT OUTER JOIN pg_catalog.pg_description b				--存放说明
			 ON a.attrelid=b.objoid AND a.attnum = b.objsubid,
		pg_type t												--存放类型
  WHERE a.attnum > 0
	and c.relname = 's_oadt_pubdeptinfo'
	and a.attrelid = c.oid
	and a.atttypid = t.oid
ORDER BY a.attnum;









