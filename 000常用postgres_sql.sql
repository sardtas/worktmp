修改初始密码
sudo su postgres
psql
\password postgres


--数据库改密码
ALTER USER test1 PASSWORD 'secret';
--用户过期也会提示密码不对
select * from pg_user;
alter user yangyong valid until '2025-07-31';

--修改列属性
ALTER TABLE bi_rt_rpt.rtr_seller_sales_operate_base_stat_1d ALTER COLUMN sellerid DROP NOT NULL;
ALTER TABLE bi_rt_rpt.rtr_seller_sales_operate_base_stat_1d ALTER COLUMN sellerid SET DEFAULT '';



建表空间
建立相应目录，父目录也要给postgres相应权限
CREATE TABLESPACE ts_l3_pgdata
  OWNER postgres
  LOCATION '/work/pgdata';

CREATE TABLESPACE ts_l1_pgdata  OWNER postgres  LOCATION '/l1t/pgdata';
CREATE TABLESPACE ts_l2_pgdata  OWNER postgres  LOCATION '/l2t/pgdata';
CREATE TABLESPACE ts_l15_pgdata  OWNER postgres  LOCATION '/l1.5t/pgdata';
CREATE TABLESPACE ts_w3_pgdata  OWNER postgres  LOCATION '/w3t/pgdata';
CREATE TABLESPACE ts_88_pgdata  OWNER postgres  LOCATION '/work/nfs/pc88pgdata';
 
 
create user u_log1 password 'uat123';
CREATE ROLE r_log1
   VALID UNTIL 'infinity';


CREATE DATABASE d_log1
  WITH ENCODING='UTF8'
       OWNER=u_log1
       LC_COLLATE='zh_CN.UTF-8'
       LC_CTYPE='zh_CN.UTF-8'
       CONNECTION LIMIT=-1
       TABLESPACE=ts_l3_pgdata;

建schemas
CREATE SCHEMA p_t_log1
       AUTHORIZATION u_log1;
COMMENT ON SCHEMA p_t_log1
  IS '用于存储分区数据，因按天分区，表太多，所以用专门的一个schema存储数据，其他分区表可用另外的schema保存数据';

建分区表
CREATE TABLE p_t_log1.t_log20170101 () inherits (public.t_log);  
ALTER TABLE p_t_log1.t_log20170101   
ADD CONSTRAINT p_t_log1.t_log20170101_date_key  
CHECK (date = '2017-01-01'::date);  

alter table bi_fdm.d_oadt_deptcost add constraint pk_d_oadt_deptcost  primary key ( year, month, deptcode);

设置search_path
-- Use this to show the current search_path
-- Should return: "$user",public
SHOW search_path;

-- Create another schema
GRANT ALL ON SCHEMA s1 TO s1;

-- To change search_path on a connection-level
SET search_path TO s1;

-- To change search_path on a database-level
ALTER database "testdb" SET search_path TO s1;

grant usage on schema  bi_rpt to chenmengye;

--设置权限 查用户权限
select 'grant select on ' || table_schema || '.' || table_name || ' to view_bi;'
from information_schema.table_privileges
where grantee='view_bi'
  and privilege_type = 'SELECT'
;
--按用户授权
grant view_bi to yangyong;

--要用户权限
select * from information_schema.usage_privileges where grantee='view_bi';
select* from information_schema.routine_privileges where grantee='dc';

--只给部分字段权限
GRANT { { SELECT | INSERT | UPDATE | REFERENCES } ( column_name [, ...] )
    [, ...] | ALL [ PRIVILEGES ] ( column_name [, ...] ) }
    ON [ TABLE ] table_name [, ...]
    TO role_specification [, ...] [ WITH GRANT OPTION ]

grant select (  userregdate,source_type)  on  bi_adm.a_usr_user_info  to view_bi ;
--查权限
select * from information_schema.column_privileges where grantee='view_bi'
and table_name = 'a_usr_user_info';


select 'grant ' || string_agg(t.privilege_type, ',') || ' on ' || table_schema || '.' || t.table_name || ' to view_bi; '
from INFORMATION_SCHEMA.table_privileges t where t.grantee = 'view_bi'
group by t.table_schema, t.table_name;

select 'grant select (' || string_agg(column_name, ',') ||
       ') on table bi_adm.a_usr_user_info  to view_bi;' from information_schema.column_privileges where grantee='view_bi'
and table_name = 'a_usr_user_info';



#建缓存表
create extension pg_prewarm ;
create extension pg_buffercache ;

#建无日志表
create unlogged table 


。10.0增加了对后台运行的支持，提供了三个SQL函数。pg_background_launch : 开启后台work进程与会话，执行用户提供的SQL，返回后台会话的PID;pg_background_result : 根据提供的PID，返回这个后台会话执行SQL的结果;pg_background_detach : 根据提供的PID，返回这个后台会话执行SQL的结果，同时关闭这个后台进程。 pg_background_result还会返回执行所用的时间。

GRANT EXECUTE ON FUNCTION public.fc_p_write_log TO bi_log;
grant execute on sequence c_cfg_glob_logg_log_id_seq to bi_log;

--alter sequence 
select * from   bi_rpt.r_fac_customeras_seller_yibi_id_seq ;
--重置
alter sequence   bi_rpt.r_fac_customeras_seller_yibi_id_seq  restart with 2190652;


取10分钟间隔
  select  date_trunc('minute',now()) - interval '1 minute' * (EXTRACT( minute from  now() )::integer % 15 )
   
  

SELECT
    procpid,
    START,
    now() - START AS lap,
    current_query
FROM
    (
        SELECT
            backendid,
            pg_stat_get_backend_pid (S.backendid) AS procpid,
            pg_stat_get_backend_activity_start (S.backendid) AS START,
            pg_stat_get_backend_activity (S.backendid) AS current_query
        FROM
            (
                SELECT
                    pg_stat_get_backend_idset () AS backendid
            ) AS S
    ) AS S
WHERE
    current_query <> '<IDLE>'
ORDER BY
    lap DESC;


select * from pg_stat_statements t where t.queryid is not null ;
select * from pg_stat_activity;



--查看表结构

SELECT a.attnum,
a.attname AS field,
t.typname AS type,
a.attlen AS length,
a.atttypmod AS lengthvar,
a.attnotnull AS notnull,
b.description AS comment
FROM pg_class c,
pg_attribute a
LEFT OUTER JOIN pg_description b ON a.attrelid=b.objoid AND a.attnum = b.objsubid,
pg_type t
WHERE c.relname = 'rtr_seller_sell_data'
and a.attnum > 0
and a.attrelid = c.oid
and a.atttypid = t.oid
ORDER BY a.attnum;


--行转列， 行合并， 行拼接
create table yy1( a int, b varchar(30));
insert into yy1 values(1, '1');
insert into yy1 values(1, '2');
insert into yy1 values(1, '3');
insert into yy1 values(1, '5');
insert into yy1 values(2, '1');
insert into yy1 values(2, '1');
insert into yy1 values(3, '1');
insert into yy1 values(3, '1');
select a, array_to_string(array(  
       select b from yy1 as tt where tt.a = t.a 
     ), ',') from yy1 as t  group by a ;



--循环执行语句
create or replace function yyxh(OUT r_log_remark character varying) RETURNS character varying
 LANGUAGE plpgsql AS $function$ declare 
 	v_s_date date  := '20190101'::date;
    v_e_date date  := '20190201'::date;
    v_days int;
 begin
	 select v_e_date - v_s_date into v_days;
	 for i in 0..v_days loop
	 	PERFORM bi_fdm.sp_d_usr_t_userroles_chg_tran((v_s_date + interval  '1 d' * i )::date );
		--PERFORM bi_adm.sp_a_usr_role_ext_tran((v_s_date + interval  '1 d' * i )::date );
		--PERFORM bi_adm.sp_a_usr_xkw_user_tran((v_s_date + interval  '1 d' * i )::date );
	 end loop;
END; $function$;

select yyxh();
drop function yyxh();


--生成执行批量过程
select array_to_string(  array (
    select 'select bi_rpt.sp_r_fac_user_acti_retention_tran(''' || to_char(userid, 'yyyy-MM-dd') || '''::date );
'    from (select generate_series('20200101'::date , '20200201'::date , interval '1 d') userid ) tu  order by userid  ), '' );


select array_to_string(  array (
    select 'update bi_adm.a_usr_user_ulog t set iparea  = i.area , prov_name= i.provincename , city_name = i.cityname from bi_fdm.d_out_ipaddresses_info i 
where t.etl_date = ''' || to_char(userid, 'yyyy-MM-dd') || '''::date and  userip SIMILAR TO ''[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}'' and  t.iparea is null and i.int_range @> public.ip2int(t.userip ) ;
'    from (select generate_series('20180101'::date , '20180731'::date , interval '1 d') userid ) tu  order by userid  ), '' );

--查多个值的对应
select
 array_to_string( array (select t_catalog.catalog_name
                            from bi_fdm.d_mdm_textbookcatalog t_catalog
                            where  t_catalog.begndt<=now() and t_catalog.overdt>now()
                                and t_catalog.catalogid in (select  regexp_split_to_table(t_soft.catalog_ids, ',' )::int)
                            )
            , ',') as textbookcatalog,  --教材目录
t_soft.catalog_ids
from bi_adm.a_res_soft_info t_soft where t_soft.catalog_ids ~ ',' limit 100 ;


create or replace function yysql(in v_tran varchar, in start_date date, in end_date date, OUT v_r character varying) RETURNS character varying
 LANGUAGE plpgsql AS $function$ declare  	
    v_days int;
 begin
	 select end_date - start_date into v_days;
	 v_r := '';
	 for i in 0..v_days loop
	 	v_r := v_r || 'select ' || v_tran || '(''' || to_char( (start_date+ interval  '1 d' * i )::date ,'yyyy-mm-dd') 
	 			   || '''::date );
';	 	
	 end loop;
END; $function$;

select yysql('bi_fdm.sp_d_usr_t_userroles_chg_tran', '20190215'::date, '20190228'::date);
---生成批量语句t1 日
select array_to_string(
  array (
    select 'select bi_rpt.sp_r_fac_user_acti_retention_tran('''
   			|| to_char('20191201'::date + ( interval '1 d' *  userid ) , 'yyyy-mm-dd') || '''::date);
'
    from (select generate_series(0,156,1) userid ) tu  order by userid  ), ''
);

---生成批量语句t1 月
select array_to_string(
  array (
    select 'select bi_rpt.sp_r_fac_user_acti_retention_tran('''
   			|| to_char('20190101'::date + ( interval '1 month' *  userid ) - interval '1 d' , 'yyyy-mm-dd') || '''::date);
'
    from (select generate_series(1,35,1) userid ) tu  order by userid  ), ''
);



---生成批量语句t0
select array_to_string(
  array (
    select 'select bi_rt_rpt.sp_rtr_rpt_scho_prod_cooperation_1d_tran('''
			|| to_char('20211201'::date + ( interval '1 day' *  userid), 'yyyymmdd')  || '''::timestamp, '''
			|| to_char('20211201'::date + ( interval '1 day' *  userid), 'yyyymmdd')  || '''::timestamp);
'
    from (select generate_series(0,22,1) userid ) tu  order by userid  ), ''
);


--行转列，列转行 sqlserver
pivot unpivot


--查存储过程中用到的东西 
select * from pg_proc t where t.prosrc like '%sql=%' ;
select * from pg_proc t where t.prosrc like '%登录%' ;


--查看执行计划
explain (analyze,verbose,costs,timing,buffers)
select * from bi_adm.a_usr_user_info2 a where a.userid=25117360;


--对bool类型的计算
bool_and bool_or
select bool_and(a) from ( values (true) , (false), (null) ) as t(a);


--查分区表
select * from pg_class t where t.relhassubclass ;
SELECT
    nmsp_parent.nspname AS parent_schema ,
    parent.relname AS parent ,
    nmsp_child.nspname AS child ,
    child.relname AS child_schema
FROM
    pg_inherits JOIN pg_class parent
        ON pg_inherits.inhparent = parent.oid JOIN pg_class child
        ON pg_inherits.inhrelid = child.oid JOIN pg_namespace nmsp_parent
        ON nmsp_parent.oid = parent.relnamespace JOIN pg_namespace nmsp_child
        ON nmsp_child.oid = child.relnamespace
WHERE
    parent.relname = 'd_log';



--清理日志， pg_wal 清理cdc 
--做检查点，这里会显示最后的检查点，之前的就可以删除了
/usr/pgsql-12/bin/pg_controldata -D /var/lib/pgsql/12/data/
--删除之前的检查点
/usr/pgsql-12/bin/pg_archivecleanup /var/lib/pgsql/12/data/pg_wal/ 0000000100000005000000B2

--连接字符串
concat_ws(':',aaa,bbb)
几行数据中的 同一 单字段值根据连接符拼接
string_agg(ccc,' \r\n ')
如果要将多个字段的值拼接成一个：
string_agg(concat_ws(':',aaa,bbb),' \r\n ' order by aaa asc) as xxx
#处理电话号码 mark_phone
regexp_replace(phone,'^.*?(\d{3})\d{4}','\1****')

“__$operation”为“1”代表删除，“2”代表插入，“3”执行更新操作前的值，“4”执行更新操作后的值。

select version();

--窗口函数 
create table bi_temp.yyrr( a int , g int );
insert into bi_temp.yyrr values(1, 1), (2,1),(3,1),(1,2),(5,2),(3,3) ;
select * from bi_temp.yyrr;
select g, sum(a) sa
from bi_temp.yyrr
group by g;
select sa*1.0/ sum(sa) over(), g, sa
from  (select g, sum(a) sa
from bi_temp.yyrr
group by g) as tt
;

-- partition by 按哪个分组，分组后计算前值
-- sum() order by 排序时，只计算到当前的数据，并不是计算所有数据。
-- 想要所有值，over()里不能加排序
-- 
 select
    to_char(stat_date,'YYYY-MM') date_text,
    sum(sum(soft_num)) over( partition by to_char(stat_date,'YYYY-MM') order by to_char(stat_date,'YYYY-MM') asc)  soft_num,
        sum(sum(soft_num)) over()  soft_num,
    sum(sum(soft_num)) over(order by to_char(stat_date,'YYYY-MM') asc)  soft_num,
    row_number() over(order by to_char(stat_date,'YYYY-MM') desc)  soft_num,
        row_number() over()  soft_num2
  from bi_rpt.r_fac_soft_data
 --where stat_date >= '2014-01-01'  and stat_date < '2014-02-01'
  group by date_text

-- 还有这种用法
SELECT sum(salary) OVER w, avg(salary) OVER w
  FROM empsalary
  WINDOW w AS (PARTITION BY depname ORDER BY salary DESC);



--正则 
substring(ug.service FROM '^(http[s]*://.[^/?&]+?)[/]*?')
to_number( trim( substring(t.remark ,'学校..:(.*?)(,|，|$)')), '9999999999') sid 


--取几个值中的最大值和最小值
select GREATEST(1,3,4)
select LEAST(3,23,2)


SELECT pg_cancel_backend(PID);
SELECT pg_terminate_backend(PID);

--查表空间及碎片
select t.schemaname || '.' || t.relname as table_name,
       pg_size_pretty (pg_total_relation_size( t.schemaname || '.' || t.relname) ) all_size_g,
       pg_size_pretty(pg_indexes_size(t.schemaname || '.' || t.relname)) index_size,
       pg_size_pretty(pg_table_size(t.schemaname || '.' || t.relname)) table_size,
       t.n_tup_del, t.n_dead_tup, t.n_live_tup, t.last_analyze, t.n_tup_ins
from pg_catalog.pg_stat_all_tables t
where t.schemaname = 'bi_rt_rpt'
order by t.n_dead_tup desc nulls last , t.n_tup_del desc nulls last  ;


--查表占用空间
select pg_total_relation_size('bi_rt_rpt.rtr_seller_sell_data') / 1024 / 1024;

--表使用空间查询
SELECT
  pg_size_pretty(sum(pg_indexes_size(a.table_schema || '.' || a.table_name))),
  pg_size_pretty(sum(pg_table_size(a.table_schema || '.' || a.table_name)))
FROM information_schema.tables a
WHERE
  a.table_name ~ 'd_zxxk_cl_consumelog';

--查看碎片 http://www.postgres.cn/docs/9.4/monitoring-stats.html#PG-STAT-ALL-TABLES-VIEW
select * from pg_catalog.pg_stat_all_tables t order by t.n_dead_tup desc  ;


--回收表空间，full 是整理放到另外一个空闲位置，释放磁盘空间。truncate是默认配置，会回收空闲空间，但不释放磁盘空间。SKIP_LOCKED会跳过当前有写入或锁定的表
VACUUM (VERBOSE, ANALYZE) table_name;

!!! 使用注意，会锁表，即使重建索引，也会锁表
reindex index index_name ;
reindex table table_name ;



--多级关联 递归查询
with RECURSIVE cte as
(
select a.id,cast(a.name as varchar(100)) from tb a where id='002'
union all 
select k.id,cast(c.name||'>'||k.name as varchar(100)) as name  from tb k inner join cte c on c.id = k.pid
)select id,name from cte ;


--导出表的结构
select c.relname, d.description,a.attname as column_name,
       format_type(a.atttypid,a.atttypmod) as data_type, col_description(a.attrelid,a.attnum) as comment
  from pg_class c
  left join pg_description d on c.oid = d.objoid and objsubid=0
  left join pg_attribute a on a.attrelid = c.oid and a.attstattarget = -1
where relkind ='r' and c.relispartition = false   and ( relname like 'd\_%' or relname like 'a\_%' or relname like 'r\_%')
order by c.relname, a.attname




--销售系统用了计算列
[SuspiciousTypesSize]  AS ((isnull(len([SuspiciousTypes]),(0))+case when [ShareRecordStatus]=(1) then (50) else (0) end)+case when charindex('7',[SuspiciousTypes])<>(0) then (100) else (0) end)


--生成分区表语句
create table bi_adm.a_res_stdn_soft_1m202101
    partition of bi_adm.a_res_stdn_soft_1m
        FOR VALUES FROM ('2021-01-01') TO ('2021-02-01');        
--list的
create table bi_adm.a_res_stdn_soft_1m202101 partition of bi_adm.a_res_stdn_soft_1m for values in ( 'D');

--删除分区
alter table bi_rpt.r_fac_user_pv_detail detach partition  bi_rpt.r_fac_user_pv_detail_xxx ;


with md as (       
	select t.month_date as tt from bi_adm.a_com_date_extd t where t.extend_date >= '20180101' group by tt order by tt 
)
select 'create table bi_adm.a_res_stdn_soft_1w' || to_char(md.tt, 'YYYYMM') || ' partition of bi_adm.a_res_stdn_soft_1w ' 
		|| ' FOR VALUES FROM (''' ||  to_char(md.tt, 'YYYY-MM') || '-01'') TO (''' 
		|| to_char((md.tt + interval '1 month')::date , 'YYYY-MM') || '-01'');'
from md 

--用like生成 
CREATE TABLE measurement_y2008m02
  (LIKE measurement INCLUDING DEFAULTS INCLUDING CONSTRAINTS)
  TABLESPACE fasttablespace;


--查存储过程中的语句
select distinct t.proname from pg_catalog.pg_proc t where t.prosrc like '%' || lower('consumepricetype') || '%';


--拆分array array to list array转行
unnest()


--upsert 插入或更新 EXCLUDED是将要插入的数据的临时表
insert into bi_temp.yy3
select a, b from bi_temp.yy4
on conflict (a) do update set  b = EXCLUDED.b ;
--do update 也可以使用DO NOTHING， 什么都不做

--去tab 去回行
 regexp_replace(t.schoolname,  E'[\\n\\r\\t]+', '', 'g' )

--过程
call public.fc_p_execute_func_batch('bi_temp', 'sp_yy1_tran', '20211201', '20211220'  ) ;

CREATE OR REPLACE FUNCTION bi_temp.sp_yy1_tran(in v_etl_date date , out v_log_remark varchar)
  RETURNS varchar
AS
$BODY$
BEGIN

END;
$BODY$
LANGUAGE plpgsql VOLATILE;


--表字段名说明
SELECT 'comment on column bi_dwd.dw' || aa.table_name || '.' || aa.col_name || ' is '''
        || BB.DESC || ''';', aa.COL_NAME, bb.DESC FROM
  ( SELECT
        A.ORDINAL_POSITION AS COL_NUM,
        A.COLUMN_NAME AS COL_NAME,
        a.table_name
    FROM INFORMATION_SCHEMA.COLUMNS A
    WHERE A.TABLE_SCHEMA = 'bi_fdm' AND A.TABLE_NAME = 'd_sal_b_sellreceivemoney_c'
  )  AS AA
LEFT JOIN  (SELECT OBJSUBID,DESCRIPTION AS DESC FROM PG_DESCRIPTION WHERE OBJOID =
(  SELECT RELID FROM PG_STAT_ALL_TABLES WHERE SCHEMANAME = 'bi_fdm'
AND RELNAME = 'd_sal_b_sellreceivemoney_c')  )
  AS BB ON AA.COL_NUM = BB.OBJSUBID
where bb.DESC is not null ORDER BY AA.COL_NUM;



--销售系统调用易币接口授权
grant all privileges on bi_adm.a_dep_api_keepup_log to bi_api_dev ;
grant usage on sequence  bi_adm.a_cfg_cust_rule a_dep_api_keepup_log_id_seq to bi_api_dev;





--postgres 初始化
/usr/lib/postgresql/11/bin/pg_ctl initdb -D /usr/share/postgresql/11/
--启动
/usr/lib/postgresql/11/bin/pg_ctl -D /usr/share/postgresql/11/db1 -l logfile start
/etc/init.d/postgresql start







--mysql 
create database predict;
create user etluser@'%' identified by 'password';
grant all privileges on predict.* to etluser;

flush privileges;











