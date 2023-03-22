
#hbase基于zookeeper运行，需要先安装zookeeper，具体安装方法请参考storm上线文档。


#用root开防火墙端口
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="16000" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="16010" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="16020" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="16030" accept"

#以下为普通用户操作
#解压缩hbase 
tar -zxf hbase.tar.gz
#hbase需要读hadoop的配置文件，hadoop下的hdfs-site.xml和core-site.xml拷贝到hbase的conf目录下 
#为了改hadoop配置时不用改两遍，建立一个软连接
ln -s /home/hadoop/hadoop/etc/hadoop/core-site.xml /home/hadoop/hbase/conf/core-site.xml
ln -s /home/hadoop/hadoop/etc/hadoop/hdfs-site.xml /home/hadoop/hbase/conf/hdfs-site.xml
#改hbase的配置  hbase本身带zookeeper，因为storm之前已经用了zookeeper，所以直接使用那个zookeeper
echo 'export HBASE_LOG_DIR=$HBASE_HOME/logs' >> hbase/conf/hbase-env.sh
echo 'export HBASE_PID_DIR=$HBASE_HOME/bin' >> hbase/conf/hbase-env.sh
echo 'export HBASE_MANAGES_ZK=false' >> hbase/conf/hbase-env.sh


vim hbase/conf/hbase-site.xml
<configuration>
<property>
  <name>hbase.tmp.dir</name>
  <value>/data/bigdata/data/hbase</value>
</property>
<property>
  <name>hbase.rootdir</name>
  <value>hdfs://h1:8020/hbase</value>
</property>
<property>
  <name>hbase.cluster.distributed</name>
  <value>true</value>
</property>
<property>
  <name>hbase.zookeeper.quorum</name>
  <value>h1:2181,h2:2181,h3:2181</value>
</property>
<property>
  <name>hbase.zookeeper.property.clientPort</name>
  <value>2181</value>
</property>
<property>
  <name>hbase.zookeeper.property.dataDir</name>
  <value>/home/storm/zk</value>
  <description>property from zoo.cfg,the directory where the snapshot is stored</description>
</property>
</configuration>


#配置环境变量 
export HBASE_HOME=/home/hadoop/hbase
export PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HIVE_HOME/bin:$SQOOP_HOME/bin:$HBASE_HOME/bin:$PATH

#为了让hbase能读zookeeper的配置，将hadoop加入storm组，再给storm的默认目录加上755的权限。
usermod -a -G storm hadoop
chmod 755 /home/storm

#使用命令 hbase shell 来进入hbase的命令行,注意这个命令行中很多地方都要用单引号引起来，参数、表名、列名什么的都得引起来才行。
hbase shell

create table 
create 't1','cf1',1
create 't1', {NAME => 'cf1', VERSIONS => 1}
put 't1', 'r1', 'cf1', 'v1'
put 't1', 'r4', 'cf1:c1', 'v1'

#使用sqoop导数据
sqoop import --connect jdbc:mysql://192.~~.~~.146:3306/yfei --username 'root' --password '你的密码' --table 'mysql数据库的表名' --hbase-table 'test' --hbase-row-key '可以是mysql的主键' --column-family '刚刚建立的列簇的名：region'


使用sqoop从数据库同步数据
sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs_test --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --hbase-table 't1'  --hbase-row-key 'receive_time' --column-family 'cf1' \
--where " requesttime> '20190501'::date "  -- --schema bi_srcapp 



sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs_test --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --hbase-table 't1'  --hbase-row-key 'receive_time' --column-family 'cf1' \
--columns requesttime,appid,userid,url,prevurl,eventname,ip,userislogin,browser,os,browser_ver,os_ver,insert_time,receive_time,uuid,topic,data1,eeid,query \
--where " requesttime> '20190501'::date "  -- --schema bi_srcapp




