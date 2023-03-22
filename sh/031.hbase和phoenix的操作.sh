#hbase 操作
#进入 hbase的命令行
hbase shell 


#查看有什么表
list

#建表，必须要带单引号， create 'table_name','column_family_name1','column_family_name2'.....
create 's_aliyun_log','cf1'
create 'SLOG','cf1'
!!为了在phoenix中用着方便，表名尽量都大写，这样可以在phoenix中写表名时不用加引号，否则phoenix中的小写表名要用双引号引起来。

#查看表里的数据
scan 's_aliyun_log', {LIMIT=>10}


#phoenix 操作 phoenix中表的名称默认是大写存储，没加引号会转成大写，如果使用双引号引起来，则可以是小写。大小写敏感。
#进入phoenix命令行 使用sqlline.py连接装有hbase master的机器，2181是zookeeper的端口。
sqlline.py hbase_master_host_name:2181
sqlline.py 172.17.0.3:2181
#基础操作要带'!'，查看有哪些表
!tables;
#查看所有表和字段
select * from SYSTEM.CATALOG;
#退出
!quit
#帮助，这个不带 !
help
#查看表结构
!describe "TMP1"
!describe tmp1
#建表
create table if not exists tmp1(id integer primary key,name varchar(20));
create schema ljc;
create table if not exists ljc.student(id integer primary key,name varchar(20));
#向表里插入数据
upsert into ljc.student(id,name) values(1,'zhangsan');
upsert into ljc.student(id,name) values(2,'lisi');
upsert into ljc.student(id,name) values(3,'wangwu');
upsert into ljc.student(id,name) values(4,'liuping');
upsert into ljc.student(id,name) values(5,'zhouhong');
#查询数据
select * from ljc.student;

#建立基于hbase的表，可以使用table 或view，使用table的话，会更新hbase的资料库，增加这里定义的列，使用view的话就不会
!!操作drop时要注意，drop table会删除hbase中的表，如果是建立的view，在phoenix中删除则hbase中不删除。这里建立的table直接用hbase的资料库。
!!建view的话，字段必须与hbase中的一致，否则会报table is read olny错误, hbase中没有区分类型，都是以字符型存储。
!!时间类型的数据在sqoop导入hbase时会转换成2019-01-01 10:07:22.432 这样的字符型，在hbase中显示正常，但在phoenix中不能定义为timestamp,
要定义为varchar才行。
!!数据类型尽量都使用varchar型，数据类型在转换时并不智能，像int型的长度必须是4，其他长度如数据是1,则报“Illegal data. Expected length of at least 4 bytes, but had 1 (state=22000,code=201)”

CREATE VIEW "s_aliyun_log" ( pk VARCHAR primary key,
"cf1"."requesttime" VARCHAR  ,
"cf1"."appid" VARCHAR , 
"cf1"."userid" VARCHAR ,
"cf1"."url" VARCHAR ,
"cf1"."prevurl" VARCHAR ,
"cf1"."eventname" VARCHAR ,
"cf1"."ip" VARCHAR , 
"cf1"."userislogin" VARCHAR ,
"cf1"."browser" VARCHAR , 
"cf1"."os" VARCHAR ,
"cf1"."browser_ver" VARCHAR ,
"cf1"."os_ver" VARCHAR ,
"cf1"."insert_time" VARCHAR  ,
"cf1"."receive_time" VARCHAR , 
"cf1"."uuid" VARCHAR ,
"cf1"."topic" VARCHAR ,
"cf1"."data1" VARCHAR ,
"cf1"."eeid" VARCHAR ,
"cf1"."query" VARCHAR 
);


CREATE table slog ( pk VARCHAR primary key,
"cf1"."requesttime" VARCHAR  ,
"cf1"."appid" VARCHAR , 
"cf1"."userid" VARCHAR ,
"cf1"."url" VARCHAR ,
"cf1"."prevurl" VARCHAR ,
"cf1"."eventname" VARCHAR ,
"cf1"."ip" VARCHAR , 
"cf1"."userislogin" VARCHAR ,
"cf1"."browser" VARCHAR , 
"cf1"."os" VARCHAR ,
"cf1"."browser_ver" VARCHAR ,
"cf1"."os_ver" VARCHAR ,
"cf1"."insert_time" VARCHAR  ,
"cf1"."receive_time" VARCHAR , 
"cf1"."uuid" VARCHAR ,
"cf1"."topic" VARCHAR ,
"cf1"."data1" VARCHAR ,
"cf1"."eeid" VARCHAR ,
"cf1"."query" VARCHAR 
);


CREATE table slogp ( pk VARCHAR primary key,
requesttime VARCHAR  ,
appid VARCHAR , 
userid VARCHAR ,
url VARCHAR ,
prevurl VARCHAR ,
eventname VARCHAR ,
ip VARCHAR , 
userislogin VARCHAR ,
browser VARCHAR , 
os VARCHAR ,
browser_ver VARCHAR ,
os_ver VARCHAR ,
insert_time VARCHAR  ,
receive_time VARCHAR , 
uuid VARCHAR ,
topic VARCHAR ,
data1 VARCHAR ,
eeid VARCHAR ,
query VARCHAR 
);

create index idx_slogp_all on slogp (requesttime, appid, userid, url ,
prevurl , eventname , ip ,  userislogin , browser , os , browser_ver ,
os_ver , insert_time  , receive_time , uuid , topic , data1 ,eeid ,
query );


create view vslog as select * from slog;

#查询操作
select "cf1"."userid" from slog limit 10;

#建二级索引 二级索引会在数据更新时自动更新索引(通过hbase接口更新数据，使用sqoop直接更新hadoop上的数据index不会更新)；如果查询语句中所需要的字段在索引中，则不会再读取原始数据，直接可以从索引中得到结果。
#对于使用requesttime查询数据时：
create index  idx_slog_qt on slog( "cf1"."requesttime" ) include( "cf1"."userid", "cf1"."url");
#对可能使用到多个字段时：
create index idx_slog_u1 on slog("cf1"."insert_time", "cf1"."requesttime" desc, "cf1"."url", "cf1"."uuid" , "cf1"."userid");
#查询语句中的字符串要用单引号
select  "cf1"."url" from slog where "cf1"."insert_time" like '2019-05-21%';
#使用sqoop更新数据后需要重建索引
alter index idx_slog_u1 on slog rebuild;

#建立表的所有索引 -- 先建view后才能建index
create index idx_s_aliyun_log_all on "s_aliyun_log" ("cf1"."requesttime", "cf1"."appid", "cf1"."userid", "cf1"."url" ,
"cf1"."prevurl" , "cf1"."eventname" , "cf1"."ip" ,  "cf1"."userislogin" , "cf1"."browser" , "cf1"."os" , "cf1"."browser_ver" ,
"cf1"."os_ver" , "cf1"."insert_time"  , "cf1"."receive_time" , "cf1"."uuid" , "cf1"."topic" , "cf1"."data1" ,"cf1"."eeid" ,
"cf1"."query" );

create index idx_slog_all on slog ("cf1"."requesttime", "cf1"."appid", "cf1"."userid", "cf1"."url" ,
"cf1"."prevurl" , "cf1"."eventname" , "cf1"."ip" ,  "cf1"."userislogin" , "cf1"."browser" , "cf1"."os" , "cf1"."browser_ver" ,
"cf1"."os_ver" , "cf1"."insert_time"  , "cf1"."receive_time" , "cf1"."uuid" , "cf1"."topic" , "cf1"."data1" ,"cf1"."eeid" ,
"cf1"."query" );

upsert into slog values( '1', 'ss', 'aaa','1', 'ss', 'aaa','1', 'ss', 'aaa','1', 'ss', 'aaa','1', 'ss', 'aaa','1', 'ss', 'aaa','1', 'ss'  );

upsert into slog(pk, "cf1"."requesttime", "cf1"."appid") values( '1234','fdafds','fdsafdsa');

#impala 与hive使用相同的资料库，但在hive中建的表，不能直接在impala中使用，需要同步一下之后才能使用
#同步命令
INVALIDATE METADATA

#查询语句与hive相同
select count(*) from bi_srcapp.slog t where t.requesttime >= to_date('2019-05-17')
and t.requesttime < to_date( '2019-06-01') ;
#使用java或sqoop导入一张表后，hive和impala都不会更新表的信息，需要refresh一下，再count才能正确显示.
refresh bi_srcapp.slog ;




#hive 建phoenix的外部表
#直接建phoenix表，删除时会把phoenix上的数据删除。
create table phoenix_yyh (
	  s1 string,
	  s2 string
	)
	STORED BY 'org.apache.phoenix.hive.PhoenixStorageHandler'
	TBLPROPERTIES (
	  "phoenix.table.name" = "yyh",
	  "phoenix.zookeeper.quorum" = "yyh4",
	  "phoenix.zookeeper.znode.parent" = "/hbase",
	  "phoenix.zookeeper.client.port" = "2181",
	  "phoenix.rowkeys" = "s1, i1",
	  "phoenix.column.mapping" = "s1:s1, i1:i1, f1:f1, d1:d1",
	  "phoenix.table.options" = "SALT_BUCKETS=10, DATA_BLOCK_ENCODING='DIFF'"
);



create external table slogp
(pk string,
requesttime string  ,
appid string , 
userid string ,
url string ,
prevurl string ,
eventname string ,
ip string , 
userislogin string ,
browser string , 
os string ,
browser_ver string ,
os_ver string ,
insert_time string  ,
receive_time string , 
uuid string ,
topic string ,
data1 string ,
eeid string ,
query string )
STORED BY 'org.apache.phoenix.hive.PhoenixStorageHandler' 
TBLPROPERTIES (
"phoenix.table.name" = "slogp", 
"phoenix.zookeeper.quorum" = "cc1,cc2,cc3",
"phoenix.zookeeper.znode.parent" = "/hbase",
"phoenix.column.mapping" = "pk:PK,requesttime:REQUESTTIME,appid:APPID,userid:USERID,url:URL,prevurl:PREVURL,eventname:EVENTNAME,ip:IP, userislogin:USERISLOGIN,browser:BROWSER, os:OS,browser_ver:BROWSER_VER,os_ver:OS_VER,insert_time:INSERT_TIME,receive_time:RECEIVE_TIME,uuid:UUID,topic:TOPIC,data1:DATA1,eeid:EEID,query:QUERY",
"phoenix.rowkeys" = "pk",
"phoenix.table.options" = "SALT_BUCKETS=10, DATA_BLOCK_ENCODING='DIFF'"
);


