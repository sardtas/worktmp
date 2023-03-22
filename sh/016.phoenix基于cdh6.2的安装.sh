#phoenix目前还不支持cdh6的直接安装，需要重新编译后使用。
下载phoenix的src包，修改pom.xml，将其中hadoop、hive、hbase等的版本修改成和cdh6一样的版本。

phoenix下载地址：
https://phoenix.apache.org/download.html
cdh6.2各组件版本
https://www.cloudera.com/documentation/enterprise/6/release-notes/topics/rg_cdh_62_packaging.html#cdh_packaging_60x

tar -zxf apache-phoenix-5.0.0-HBase-2.0-src.tar.gz
cd apache-phoenix-5.0.0-HBase-2.0-src
vim pom.xml
mvn clean package -DskipTests

#将编译好的文件放到服务器上
scp -r ../apache-phoenix-5.0.0-HBase-2.0-src root@cdh1:/root/

#登录cdh1服务器，将jar放到三台服务器的hbase/lib下。
ssh root@cdh1
cd
mkdir phoenix_jars
#进入phoenix目录，找出jar包，这些包不在同一目录下,全找出来，放在hbase/lib下，网上好多说只用放core和server的，只放这两个会报htrace错误。
cd apache-phoenix-5.0.0-HBase-2.0-src
cp -f `find | grep jar | grep HBase` /root/phoenix_jars/
cd /root/phoenix_jars/
cp * /opt/cloudera/parcels/CDH/lib/hbase/lib/
scp * cdh2:/opt/cloudera/parcels/CDH/lib/hbase/lib/
scp * cdh3:/opt/cloudera/parcels/CDH/lib/hbase/lib/

#进入cdh的网页管理页面操作hbase设置和重启
http://cdh1:7180/
集群-->hbase-->配置-->在“搜索”中输入“hbase-site.xml”，然后出来的第一项（hbase-site.xml 的 HBase 服务高级配置代码段）和第二项（hbase-site.xml 的 HBase 客户端高级配置代码） 中添加以下三项。点“以 XML 格式查看”，然后直接复制进去即可。
<property><name>hbase.regionserver.wal.codec</name><value>org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec</value></property>
<property><name>phoenix.schema.isNamespaceMappingEnabled</name><value>true</value></property>
<property><name>phoenix.schema.mapSystemTablesToNamespace</name><value>true</value></property>

加上以后点保存更改，再点“操作”-->“重启”。重启后选择“部署客户端配置”，然后点“下载客户端配置”，将下载下来的文件(hbase-clientconfig.zip)解压后放在cdh1的phoenix目录下。
scp hbase-clientconfig.zip root@cdh1:/root/
ssh root@cdh1
yum -y install unzip
unzip hbase-clientconfig.zip
cp  hbase-conf/* apache-phoenix-5.0.0-HBase-2.0-src/bin/
#会问是否覆盖已有文件，选是(按y)

#安装python和phoenix需要的包，centos默认带python python-argparse,如果有报错再装。
#yum -y install python
#yum -y install python-argparse

#然后进入phoenix的bin下执行./sqlline.py cdh1:2181
cd apache-phoenix-5.0.0-HBase-2.0-src/bin/
./sqlline.py cdh1:2181


#看有什么表
!tables
#建表，查看，没有insert，只有upsert，
create table test (mykey integer not null primary key, mycolumn varchar);
upsert into test values (1,'Hello');
upsert into test values (2,'World!');
select * from test;




!!如果要使用客户端连接，则要在装有cdh的服务器/etc/hosts中把客户端的ip 和机器名写上，否则连不上。


jdbc:phoenix:cc1:2181
org.apache.phoenix.jdbc.PhoenixDriver



<dependency>
	<groupId>org.apache.phoenix</groupId>
	<artifactId>phoenix-queryserver-client</artifactId>
	<version>4.14.0-cdh5.14.2</version>
</dependency>
<!-- Thanks for using https://jar-download.com -->

在用使用全局索引之前需要在每个RegionServer上的hbase-site.xml添加如下属性：
<property><name>hbase.regionserver.wal.codec</name><value>org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec</value></property>


<property><name>hbase.master.loadbalancer.class</name><value>org.apache.phoenix.hbase.index.balancer.IndexLoadBalancer</value></property>
<property><name>hbase.coprocessor.master.classes</name><value>org.apache.phoenix.hbase.index.master.IndexMasterObserver</value></property>
复制代码
Phoeinx4.3以上为支持在数据region合并时本地索引region也能进行合并需要在每个region servers中添加以下属性
<property>
   <name>hbase.coprocessor.regionserver.classes</name>
   <value>org.apache.hadoop.hbase.regionserver.LocalIndexMerger</value>
</property>





