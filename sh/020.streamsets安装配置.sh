streamsets是一个实时同步数据的工具，据说不是很稳定，比较占内存。实际测试中发现如果没有报错的情况下还是比较稳定的，如果配置过程中出现错误，导致大量报错的情况下，界面会卡死，后台会显示内存溢出，只能重启服务。内存最少需要6G才能正常运行，内存较小又有大量数据更新时容易出现内存溢出。

下载streamsets ，有很多版本，尽量使用3.9.1版本，3.10版本有bug，读取sqlserver时后台会大量报错，但监控和导数据正常。有可以解压就可以运行的Full Tarball ， 需要安装的RPM ，或是集成到cdh的Cloudera Parcels
https://archives.streamsets.com/index.html

如果使用cdh集成版的话，下载Custom Service Descriptor (CSD) 放在装有cdh主机器的/opt/cloudera/csd/ 目录下，再在cdh的网页 host -- parcels 下增加下载网址，或下载兼容 RHEL 7 的parcels 和  manifest.json ，放到一个http服务器上，让cdh指向这个服务器。下载--分发--激活 再添加到一台机器上后就可以使用了。
!!但要注意，streamsets不支持jdk7，而cdh5.14.2默认是使用jdk7的，所以可以安装上，但不能启动。
cdh5.14.2是支持jdk8的，所以可以更换cdh6的jdk8，这样就可以使用了。
在配置过程中需要上传数据库连接的jar包，会报错，说是建立lib文件夹时出错，是因为上层和上上层的文件夹都没有。执行以下过程创建后再上传就好了。
cd /opt/cloudera/parcels/STREAMSETS_DATACOLLECTOR
mkdir -p streamsets-libs-extras/streamsets-datacollector-mysql-binlog-lib/lib
mkdir -p streamsets-libs-extras/streamsets-datacollector-jdbc-lib/lib
chmod -R 777 streamsets-libs-extras



##不使用cdh，直接安装方式
下载full tarball的话，直接解压就可以执行。但服务器的ulimit -n  的open files 必须要够大才能启动。尽量调到65535,调整方法请看hadoop的安装。
看一下jdk8配没配，没配的话用 export JAVA_HOME=/jdk8的位置 来配置一下。
echo $JAVA_HOME
有的话用 streamsets dc 来启动，启动比较慢，等出现Running on URI : 'http://10.1.1.87:18630' 这个提示才算启动完成。
tar -zxf streamsets-datacollector-all-3.9.1.tgz
#修改启动程序
vim streamsets-datacollector-3.9.1/bin/streamsets
#增加以下内容，要不数据量一大就内存溢出了。
export SDC_JAVA_OPTS="${SDC_JAVA_OPTS} -Xmx6144m -Xms6144m -server"

streamsets-datacollector-3.9.1/bin/streamsets dc 
或后台启动
streamsets-datacollector-3.9.1/bin/streamsets dc > /dev/null 2>/dev/null &


之后访问http://10.1.1.87:18630，即可在页面上进行操作。



----------------------pg需要的配置-----------------------
----docker 直接使用postgresql
#如果是docker装的pg，调整的时候需要把文件考出来修改，因为docker的pg上连vi命令都没有，没法改东西。
docker cp dplogs:/var/lib/postgresql/data/postgresql.conf ./
vim postgresql.conf 

#以下三项默认是注掉的，把前边的#去掉，第一个参数修改成 logical就可以了。
wal_level = logical
fsync = on
wal_buffers = -1

#然后把文件考回去，进到docker中再修改一下文件的用户。因为考回去后会是root的。
docker cp postgresql.conf dplogs:/var/lib/postgresql/data/
docker exec -it dplogs /bin/bash
chown postgres:postgres /var/lib/postgresql/data/postgresql.conf

#退出docker后重启一下
docker restart dplogs



------docker 自己使用centos7 安装的pg10
docker run --name pgwal --privileged -itd centos:7.6.1810 /usr/sbin/init
docker exec -it pgwal /bin/bash
yum -y install vim openssh-server net-tools ibaio.i686 binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf devel gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel make numactl-devel sysstat compat-libstdc++-33 elfutils-libelf-devel gcc-c++ libaio-devel libstdc++-devel numactl-devel unixODBC libaio ntp nmap openssh-clients  flex bison readline-devel zlib-devel openjade docbook-style-dsssl wget flex flex-devel bison bison-devel tcl git
注意pg要单独装，默认装的是9.2
rpm -Uvh https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
#网上说装postgresql10-server 和 postgresql10就可以，只安装这两个的话，会缺少很多东西，安装wal2json的时候会报错
yum install -y postgresql10*
/usr/pgsql-10/bin/postgresql-10-setup initdb
cd /var/lib/pgsql/10/data

vim postgresql.conf
#增加以下三项
max_replication_slots = 100
max_wal_senders = 100
listen_addresses = '*' 
wal_level = logical
#shared_preload_libraries = "wal2json"

vim pg_hba.conf
#增加一项使用其他机器可以访问pg库，
host    all             all             127.0.0.1/0             md5
#如果是通过ipv6访问的，还要修改::1/128 后边的ident 为 md5
host    all             all             ::1/128                 md5

yum install wal2json12
-------------------pg12 可以不用这么装了，直接就可以装 yum install wal2json12
#报错 /usr/pgsql-12/lib/pgxs/src/makefiles/pgxs.mk: No such file or directory
sudo apt-get install postgresql-server-dev-all
sudo apt-get install postgresql-common
yum install -y epel-release
yum makecache
yum install -y llvm llvm-devel llvm-libs postgresql12-llvmji
yum install centos-release-scl
yum install postgresql12-common postgresql12-devel

#安装json编码 
cd
git clone https://github.com/eulerto/wal2json.git
cd wal2json
export PATH=/usr/pgsql-10/bin:$PATH
USE_PGXS=1 make
USE_PGXS=1 make install
----------------------------

#要想看日志还得安以下几个
yum install centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms
yum install llvm-toolset-7.0
scl enable llvm-toolset-7.0 bash
yum install postgresql12-devel

#使用这个记录日志的用户必须有 REPLICATION 权限 
su postgres
cd
psql
#建一个用于监听的用户，用replication权限
CREATE user dcsuser REPLICATION password 'd123456';
#或者给一个已有用户授权
alter user dcsuser with replication;

#以下两名用于测试，第一句是建立一个监听，监听 test库的情况，第二句会输出对于test库的修改。第二句报命令不存在的话，就把所有postgresql12*都装上，不知道在哪个包中。
pg_recvlogical -d dc --slot sdc11 --create-slot -P wal2json
pg_recvlogical -d dc --slot sdc13 --start -o pretty-print=1 -f -


#查看和删除slot 在pg里运行
SELECT * FROM pg_replication_slots ;
select pg_drop_replication_slot('sdc5');



/***** 编译streamsets的过程，由于使用了gradle，它需要从google的网站上下载东西，即使设置了代理也不行，编译不过去，就不用考虑这块了。
Failed to create session: VT number out of range
编译 ：
git clone http://github.com/streamsets/datacollector-api
mvn clean install -DskipTests
git clone http://github.com/streamsets/datacollector-plugin-api
mvn clean install -DskipTests
git clone https://github.com/streamsets/datacollector-edge.git
./gradlew clean dist publishToMavenLocal
git clone http://github.com/streamsets/datacollector
mvn package -Pdist,ui -DskipTests

To start the Data Collector, execute:
dist/target/streamsets-datacollector-3.11.0-SNAPSHOT/streamsets-datacollector-3.11.0-SNAPSHOT/bin/streamsets dc
For Data Collector CLI, execute:
dist/target/streamsets-datacollector-3.11.0-SNAPSHOT/streamsets-datacollector-3.11.0-SNAPSHOT/bin/streamsets cli
*/


/*******************sql server的设置************/
!!sql server 的代理必须要启动，
sql server 开启cdc , 系统库是不能启用cdc的，所以要单建一个库，不能使用master 
create database dc;
USE dc;
#启用cdc的库和表
EXEC sys.sp_cdc_enable_db;
EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name   = N'duser',
    @role_name     = NULL,
    @supports_net_changes = 1

#查看启用情况
 EXECUTE sys.sp_cdc_help_change_data_capture;
 EXEC sys.sp_cdc_get_captured_columns @capture_instance='dbo_duser';
 EXEC sys.sp_cdc_help_change_data_capture 'dbo', 'duser';
 
#查看Log日志数据, 用 dbo_表名_CT 来查。
select * from [dc].[cdc].[dbo_duser_CT];

!!sqlserver的cdc表是无法truncate的。

/**********************mysql 的设置 ******************/
#docker mysql:5.6版本修改，增加log_bin = mysql_bin
vim /etc/mysql/mysql.conf.d/mysqld.cnf
#增加或修改以下几项 server_id 这个数值自己定一个就可以，但是所有被监控的mysql服务器的server_id值是不能有重复的。
!!生产环境的编码不要改，改了会影响已经存在的表
[client]
default-character-set=utf8mb4
[mysqld]
binlog-format=ROW
server_id = 100
log-bin=mysql-bin
character-set-server=utf8mb4


!!使用过的mysql cdc的pipline修改库后再次使用时可能会报arrary错误或无法启动，是因为pipline记住了cdc文件的位置，换库后文件可能会从头写，没有pipline需要的文件，复制的pipline有时候也不行，重新建一个新的pipline就好了。
!!使用jdbc读表的时候，停掉再启动可能也会不重新读数据，使用reset origin & start就可以了。

!!在页面上进行设置的时候要注意，sqlserver的数据读取后可以直接插入其他数据库；mysql的数据需要对数据进行一下拆分后再插入，delete只记录id，insert和update会记录所有数据；postgresql需要对数据进行拆分，而字段与数据也需要重新组合后才能使用。
!!streamsets各版本间兼容性不是很好，设置好的流程导出后导入另一个版本可能会出现有报错不能使用，或是没有报错能运行，但数据过不来的情况，尽量不要直接升级版本。
!!postgresql和mysql对表进行truncate时，监控是抓不到数据的，所以需要确保源系统不做truncate操作。sqlserver在设置了日志监控后，是没法做truncate的，这种处理方式比较好。


!!mysql作为源端表发生变化，streamsets的pipline会自动重启，重启后以新的表结构同步数据。表结构变更后插入的数据也会同步。postgresql源端发生变化不会自动重启,自动按新的结构同步，源端和目标端的表结构不一样也可以正常同步。
!!删除Mysql没有主键表的数据会导致java.lang.NullPointerException: record cannot be null 报错，数据同步无法继续。
!!目标端表发生变化不会重启pipline，如果目标端比源端字段多，可以正常插入数据。如果目标端字段少，会报错，但数据仍能插入，少的字段就忽略了。

!!postgresql源端增加表的话，pipline不重启不会同步新建表，重启后会从这个新表的开始同步，不会丢失这期间的数据。


!!streamsets连接sqlserver时总是会报错，报错中说__$sdc.txn_window 字段过长，查看源代码发现实际上在操作中没有用到这个字段，这个字段在数据库中也不存在，但是在初始化的时候有程序对所有字段都放到sql中执行了一遍，所以总是会有报错且不影响整体进程。把这个字段加上单引号让数据库不报错可能就可以解决这个问题了。
修改com.streamsets.pipeline.lib.jdbc.multithread.util.MSQueryUtil类，将public static final String CDC_TXN_WINDOW = "__$sdc.txn_window";改成public static final String CDC_TXN_WINDOW = "'__$sdc.txn_window'";重新编译就行了。
#具体操作
从gitee下载streamsets的源代码。编译jdbc 基于的其他包，安装后，再编译这个包，最后把打完的包放到streamsets下
git clone https://gitee.com/tangtangplus/streamset-datacollector.git -b 3.15
cd streamset-datacollector/stagesupport
mvn clean install -DskipTests
cd ../lookup-protolib
mvn clean install -DskipTests
cd ../guavasupport
mvn clean install -DskipTests
cd ../jdbc-protolib
mvn clean package -DskipTests
cp target/streamsets-datacollector-jdbc-protolib-3.15.0.jar /opt/streamsets-datacollector-3.15.0/streamsets-libs/streamsets-datacollector-jdbc-lib/lib/



com.streamsets.pipeline.stage.origin.jdbc.cdc.postgres.PostgresCDCSource
cdcQueue = new LinkedBlockingQueue<>(10);

com.streamsets.pipeline.stage.origin.jdbc.cdc.postgres.PostgresWalRunner
while( ! postgresCDCSource.getQueue().offer(filteredRecord)){
        			ThreadUtil.sleep(1000);
        		}   


!!解决sqlserver column名有大小写问题，都改成小写的
 com.streamsets.pipeline.lib.jdbc.JdbcUtil 的 905行
  fields.put(md.getColumnLabel(i).toLowerCase(), field);

com.streamsets.pipeline.lib.jdbc.JdbcRecordReader  的 150行
 if (record.has(fieldPath.toLowerCase())) {






