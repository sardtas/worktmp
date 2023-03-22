cd /etc/yum.repos.d/
rm -f *


docker cp /var/www/html/yumrepo/pc88.repo cc1:/etc/yum.repos.d/
docker cp /var/www/html/yumrepo/pc88.repo cc2:/etc/yum.repos.d/
docker cp /var/www/html/yumrepo/pc88.repo cc3:/etc/yum.repos.d/


docker cp /work/tmp/pc88.repo cc1:/etc/yum.repos.d/
docker cp /work/tmp/pc88.repo cc2:/etc/yum.repos.d/
docker cp /work/tmp/pc88.repo cc3:/etc/yum.repos.d/



yum makecache
yum -y install vim openssh-server net-tools ibaio.i686 binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf devel gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel make numactl-devel sysstat compat-libstdc++-33 elfutils-libelf-devel gcc-c++ libaio-devel libstdc++-devel numactl-devel unixODBC libaio ntp nmap openssh-clients  flex bison readline-devel zlib-devel openjade docbook-style-dsssl wget flex flex-devel bison bison-devel tcl 

systemctl start sshd
cd 
cp /etc/hosts ./
echo "172.17.1.2 s1" >> hosts
echo "172.17.1.3 s2" >> hosts
echo "172.17.1.4 s3" >> hosts

echo "cat /root/hosts > /etc/hosts" > /start.sh
echo "systemctl start sshd" >> /start.sh

useradd storm


chmod 500 -R .ssh
chmod 700 .ssh/known_hosts


export SCALA_HOME=/home/yy/scala
export SQOOP_HOME=/home/yy/sqoop
export JAVA_HOME=/home/yy/jdk8
export HADOOP_HOME=/home/yy/hadoop
export HIVE_HOME=/home/yy/hive
export SPARK_HOME=/home/yy/spark
export KAFKA_HOME=/home/yy/kf
export STORM_HOME=/home/yy/storm
export ZOOKEEPER_HOME=/home/yy/zk
export REDIS_HOME=/home/yy/redis
export RUBY_HOME=/home/yy/ruby
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH
export PATH=$RUBY_HOME/bin:$REDIS_HOME/src:$SCALA_HOME/bin:$SQOOP_HOME/bin:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HIVE_HOME/bin:$SPARK_HO
ME/bin:$KAFKA_HOME/bin:$STORM_HOME/bin:$ZOOKEEPER_HOME/bin:$ZOOKEEPER_HOME/conf:$PATH



export JAVA_HOME=/home/storm/jdk8
export STORM_HOME=/home/storm/storm
export ZOOKEEPER_HOME=/home/storm/zk
export REDIS_HOME=/home/storm/redis
export RUBY_HOME=/home/storm/ruby
export PATH=$RUBY_HOME/bin:$REDIS_HOME/src:$JAVA_HOME/bin:$STORM_HOME/bin:$ZOOKEEPER_HOME/bin:$ZOOKEEPER_HOME/conf:$PATH


/home/storm/redis53371/src/redis-server /home/storm/redis53371/redis.conf >/dev/null 2>&1 &
/home/storm/redis53372/src/redis-server /home/storm/redis53372/redis.conf >/dev/null 2>&1 &

#/home/storm/redis/src/redis-server /home/yy/redis/redis.conf > /dev/null 2>&1 &
/home/storm/zk/bin/zkServer.sh start
/home/storm/storm/bin/storm supervisor >/dev/null 2>&1 &
/home/storm/storm/bin/storm nimbus >/dev/null 2>&1 & 
#/home/storm/storm/bin/storm ui >/dev/null 2>&1 & 

redis-cli --cluster create 172.17.1.2:53371 172.17.1.3:53371 172.17.1.4:53371 172.17.1.3:53372 172.17.1.4:53372 172.17.1.2:53372 --cluster-replicas 1



echo 'export HADOOP_USER_NAME=hive' >> /home/storm/.bashrc
echo 'export LANG=zh_CN.UTF-8' >> /home/storm/.bashrc





