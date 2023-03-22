#将hbase需要用到的phoenix包考到hbase的lib下
scp phoenix-5.0.0-HBase-2.0-server.jar root@cdh1:/opt/cloudera/parcels/CDH/lib/hbase/lib/
scp phoenix-core-5.0.0-HBase-2.0.jar root@cdh1:/opt/cloudera/parcels/CDH/lib/hbase/lib/

#在cloudera的管理页面hbase下，找到 配置 ，在搜索中写hbase-site.xml
然后在“hbase-site.xml 的 HBase 客户端高级配置代码”中增加以下三项：
<property><name>hbase.regionserver.wal.codec</name><value>org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec</value></property>
<property><name>phoenix.schema.isNamespaceMappingEnabled</name><value>true</value></property>
<property><name>phoenix.schema.mapSystemTablesToNamespace</name><value>true</value></property>

然后在“操作”中选择“部署客户端配置”， 然后点“下载客户端配置”，解压后看一下有没有配置上。
如果在下载的hbase-site.xml中已经有了上面三项，则在“操作”中重启hbase

#解压phoenix
cd 
tar -zxf apache-phoenix-5.0.0-HBase-2.0-bin.tar.gz
ln -s apache-phoenix-* phoenix

#在phoenix的机器上配置一下环境变量
echo 'export HADOOP_CLASSPATH=/opt/cloudera/parcels/CDH/lib/hadoop/lib' >> .bashrc
echo 'export HBASE_CLASSPATH=/opt/cloudera/parcels/CDH/lib/hbase/lib' >> .bashrc
echo 'export HBASE_CONF_DIR=/etc/hbase/conf.cloudera.hbase' >> .bashrc
echo 'export PHOENIX_HOME=/root/phoenix' >> .bashrc
echo 'export PATH=$PHOENIX_HOME/bin:$PATH' >> .bashrc
. .bashrc

#启动phoenix的命令行模式
./sqlline.py cdh1:2181









