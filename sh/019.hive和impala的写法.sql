hive是基于hdfs的数据仓库，使用mysql、pg等数据库作为资料库，资料库中存放表信息。
hive的数据储存在hdfs上，当需要使用时，通过资料库读取表信息，再到hdfs上按表信息查找数据，在hdfs上存储的数据是文本格式，如果列与资料库中的数据不一致，就会出错，数据转换失败也会出错，同时需要注意Null的处理，数据库中的Null在导入到hive的时候需要特别定义一下，否则会导入为''，从hive读取出来以后就不是null了，使用
hive支持的时间在存储时也是字符串型，在使用中再作转换，日期date的时间格式为yyyy-MM-dd，TIMESTAMP类型格式yyyy-MM-dd HH:mm:ss.fffffffff, 小数后为九位,可以不足，不能过长，过长后会变成null。
impala不支持时间类型，如果是用streamsets等工具同步的数据，会将数据库中的date设置成hive中的date，hive可以识别，但impala无法识别。


impala使用hive的资料库，与hive不同的是impala并不会在执行前去读资料库，启动或连接impala时会读取一次，这时如果hive表发生变化，impala不会知道，执行查询时也是先从缓存中读取数据，对于表结构的变更，需要在impala中执行INVALIDATE METADATA ; 之后再次执行语句，impala才会重新读资料库。对于数据发生变化，需要执行refresh tablename 后才能重新读取数据。

hive在语句执行时会将sql转换成mr，再把mr放到hadoop上执行。
impala执行sql的部分主要由c语言写成，所以会直接执行sql，省去了生成mr和hadoop执行mr的调度时间，同时在数据处理中不会多次将数据写入磁盘，所以速度比hive快。

Impala设计为内存计算模型，其执行效率高，但是稳定性不如Hive，对于长时间执行的SQL请求，Hive仍然是第一选择。
类似于Spark，Impala会把数据尽可能的放入内存之中进行计算，虽然内存不够时，Impala会借助磁盘进行计算，但是毫无疑问，内存的大小决定了Impala的执行效率和稳定性。Impala官方建议内存要至少128G以上，并且把80%内存分配给Impala。
Impala不会对表数据Cache，Impala仅仅会Cache一些表结构等元数据。虽然在实际情况下，同样的query第二次跑可能会更快，但这不是Impala的Cache，这是Linux系统或者底层存储的Cache。
Impala会尽可能的把数据缓存在内存中，这样数据不落地即可完成SQL查询，相比MapReduce每一轮迭代都落地的设计，效率得到极大提升。
Impala的常驻进程避免了MapReduce启动开销，MapReduce任务的启动太慢。
Impala会自己控制协调磁盘IO，会精细的控制每个磁盘的吞吐，使得总体吞吐最大化。


Kudu的内存存储采用的是行存储，磁盘存储是列存储，其格式和Parquet很相似，部分不相同的部分是为了支持随机读写请求。
Kudu的磁盘存储模型是真正的列式存储，Kudu的存储结构设计和Hbase区别很大。
综合而言，纯粹的OLTP请求比较适合Hbase，OLTP与OLAP结合的请求适合Kudu。
和Hbase一样，Kudu是CAP中的CP。只要一个客户端写入数据成功，其他客户端读到的数据都是一致的，如果发生宕机，数据的写入会有一定的延时。
Kudu不支持二级索引，Kudu只支持Primary Key一个索引，但是可以把Primary Key设置为包含多列。自动增加的索引、多索引支持、外键等传统数据库支持的特性Kudu正在设计和开发中。
Kudu不支持多行的事务操作，不支持回滚事务，不过Kudu可以保证单行操作的原子性。
kudu中不支持truncate table，支持delete。delete速度较慢，count(*) 一张200万的表0.5秒，delete 这张表用了 257秒，而且期间cpu占用100%



sqoop是通过jdbc(mysql)或客户端(pg)连接数据然后将数据写入hdfs的工具，对于hive和hbase，sqoop可以更改它们的资料库，比如可以直接将数据库中的表导入hive，并在hive的资料库中增加表信息，但是字段类型需要再确认一下之后再使用，因为hive中类型较少，而且date型的数据会被定义为string，需要修改后再用。

hive中修改字段类型 ALTER TABLE table_name [PARTITION partition_spec] CHANGE [COLUMN] col_old_name col_new_name column_type
  [COMMENT col_comment] [FIRST|AFTER column_name] [CASCADE|RESTRICT];
alter table `default`.r_rpt_school_download CHANGE column stat_date stat_date date ;

delete 时不能加别名。

!!bug!!在impala中drop sqoop建的表的时候，并没有真的从hdfs上删除数据，只是从hive的资料库里drop掉了这张表，再次导入数据时数据会翻倍，只有从hive中drop的时候才是删除了。
impala drop自己建的表是正常的，会从hdfs上删除。

impala分区表的分区字段在select * 时不会出现，要注意。

impala更新资料库
INVALIDATE METADATA 

impala重新读取表数据，不从缓存读
refresh tablename

impala收集表信息
compute stats tablename


summray

impala 连接字符串
concat('[', btrim('    hello '), ']') 
| [hello]  
去掉两头的字符x y z ，中间的会留下
| concat('[', btrim('xy    hello zyzzxx', 'xyz'), ']') |
+------------------------------------------------------+
| [    hello ]    
| concat('[', btrim('xyhelxyzlozyzzxx', 'xyz'), ']') |
+----------------------------------------------------+
| [helxyzlo]  

从左边取，从右边取，从中间取
strleft(string a, int num_chars)
strright(string a, int num_chars)
substr(string a, int start [, int len]), substring(string a, int start [, int len])

sqoop导入分区表数据时，只能一个分区一个分区的导入。而开启自动分区功能的hive可以自动生成分区。
分区表自动分区，需要在hive中先开启自动分配(配置见cdh5.14.2安装的最后部分)，先用sqoop将数据插入到一个表中，再建一个带分区的表，然后可以通过hive或impala插入数据。
hive插入数据较慢，cpu使用占到90%左右，磁盘使用占到50%左右。实际测试时两个小时没有插完，取消了。
impala插入较快，cpu占用60%以内，磁盘占用100%。一次全量插入会报内存溢出，失败。一次插入一个月的数据用时7分钟，一次插入一年的数据用时16分钟。


hive将一个表中的数据插入到一个分区表中
insert overwrite TABLE bi_fdm.d_zxxk_cl_consumelog   partition(cdate )
select `t`.`id`, `t`.`channelid`, `t`.`infoid`, `t`.`userid`, `t`.`username`, `t`.`schooluserid`,
`t`.`consumepoint`, `t`.`consumeadvpoint`, `t`.`consumemoney`, `t`.`consumetime`, `t`.`userdownip`, 
`t`.`editor`, `t`.`censor`, `t`.`isboutique`, `t`.`softtypeid`, `t`.`requestsource`, `t`.`platform`,
`t`.`consumetype`, `t`.`iparea`, `t`.`downinterface`, `t`.`consumermb`, `t`.`product`, `t`.`prov_name`,
`t`.`etl_status`, `t`.`etl_date`, `t`.`title`, `t`.`ssms_user_schoolid`, substr( consumetime ,1, 10 ) as cdate  from `default`.d_zxxk_cl_consumelog t ;


impala将一个表中的数据插入到一个分区表中
insert into bi_fdm.d_zxxk_cl_consumelog(id,channelid,infoid,userid,username,schooluserid,
consumepoint,consumeadvpoint,consumemoney,consumetime,userdownip, 
editor,censor,isboutique,softtypeid,requestsource,platform,
consumetype,iparea,downinterface,consumermb,product,prov_name,
etl_status,etl_date,title,ssms_user_schoolid, cdate )
select `t`.`id`, `t`.`channelid`, `t`.`infoid`, `t`.`userid`, `t`.`username`, `t`.`schooluserid`,
`t`.`consumepoint`, `t`.`consumeadvpoint`, `t`.`consumemoney`, `t`.`consumetime`, `t`.`userdownip`, 
`t`.`editor`, `t`.`censor`, `t`.`isboutique`, `t`.`softtypeid`, `t`.`requestsource`, `t`.`platform`,
`t`.`consumetype`, `t`.`iparea`, `t`.`downinterface`, `t`.`consumermb`, `t`.`product`, `t`.`prov_name`,
`t`.`etl_status`, `t`.`etl_date`, `t`.`title`, `t`.`ssms_user_schoolid`, strleft( consumetime , 10 ) as cdate  
from `default`.d_zxxk_cl_consumelog t WHERE t.consumetime LIKE '2018%' ;



impala 建一个基于kudu的表。以下执行数据过多，docker机器会报内存不足错误。
CREATE TABLE  bi_fdm.kd_d_pape_usercreatedpaper 
PRIMARY KEY (id)
PARTITION BY HASH(id) PARTITIONS 8
STORED AS KUDU
TBLPROPERTIES(  
  'kudu.table_name' = 'kd_d_pape_usercreatedpaper',
  'kudu.master_addresses' = 'cc3:7051'  
)
AS SELECT * FROM  bi_fdm.d_pape_usercreatedpaper 
;





















