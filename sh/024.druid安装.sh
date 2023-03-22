#需要安装nodejs
curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
yum -y install nodejs

#因为原版druid安装麻烦，所以使用imply安装，安装imply 从网页下载最新包 https://imply.io/get-started 
tar -xzf imply-3.0.11.tar.gz
#修改资料库连接方式和使用hadoop存储数据 以及其中的zk配置
vim imply-3.0.11/conf/druid/_common/common.runtime.properties
#cp一个配置文件
cp imply-3.0.11/conf/supervise/master-with-zk.conf imply-3.0.11/conf/supervise/master.conf
#在环境变量中增加java的设置 
cd
vim .bashrc
export JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera
export PATH=$JAVA_HOME/bin:$PATH
#
java -classpath "dist/druid/lib/*"  -Ddruid.extensions.directory="dist/druid/extensions" io.druid.cli.Main tools pull-deps  -c io.druid.extensions:mysql-metadata-storage:0.10.1 -c io.druid.extensions.contrib:druid-rabbitmq:0.10.1 -h org.apache.hadoop:hadoop-client:2.7.0

java -classpath "/root/imply-3.0.11/dist/druid/lib/*" -Ddruid.extensions.directory="/root/imply-3.0.11/dist/druid/extensions" io.druid.cli.Main  tools pull-deps -r "https://mvnrepository.com" --defaultVersion 0.15.0  --clean  -c io.druid.extensions:druid-kafka-extraction-namespace -c io.druid.extensions:druid-kafka-eight -c io.druid.extensions:druid-histogram -c io.druid.extensions:postgresql-metadata-storage -c io.druid.extensions:druid-hdfs-storage -c io.druid.extensions:druid-datasketches  -h org.apache.hadoop:hadoop-client:2.6.0 


su postgres
psql
CREATE user druid LOGIN PASSWORD 'druid';
CREATE DATABASE druid OWNER druid ENCODING 'UTF8';

CREATE user pivot LOGIN PASSWORD 'pivot';
CREATE DATABASE pivot OWNER pivot ENCODING 'UTF8';


