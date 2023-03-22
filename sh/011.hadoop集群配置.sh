#hadoop说明
#主要模块 hdfs 数据存储模块，提供类似文件目录的功能，对于大于128M(默认，可改)的文件自动切分成128M大小存储，对于小于128M的文件直接存储。对于文件的读取自动多线程操作，每个线程操作一个数据块(128M大小的文件)
#   mr(map reduce) 切分和计算模块，分为map步骤和reduce步骤，map步骤可将数据拆分、分组、切成多个块待用，reduce则是对拆分后的块进行计算、处理、汇总等。
#   hive sql语句转换执行模块，可将sql语句转换成mr的执行过程，再调用mr执行过程处理数据，根据语句复杂程度可能会拆成多个mr，顺序执行。可并行执行多个sql，但不提供数据安全性和事务性，同时执行的sql可能会影响其他sql
#   yarn 机器性能监测及任务分配模块，hadoop本身有任务分配功能，不配置yarn的hadoop也可以正常使用；yarn提供了更细致的功能，可监测各计算节点的内存、cpu、硬盘空间等，根据空闲情况分配任务。
#   spark 有多个模块，在此套配置中主要用计算功能，hadoop的mr执行后会将数据存到硬盘，hive拆分后可能会有多次mr执行，spark重写了mr的处理过程使数据处理更快，而且中间步骤不再存入硬盘，直到最终处理完成才存入硬盘。
#   sqoop 导数工具，可将数据库中的数据导到hive中
#   ！！hive中有选项可以指定使用hadoop默认的mr或是使用spark的计算，官方推荐使用spark，并表示未来将只支持spark。实际使用过程中需要进行压力测试，机器的内存不多的情况下使用spark会导致任务崩溃。

##################################
目前版本的测试情况
hadoop2.7.7 spark2.3.3 hive2.3.4 可以正常使用，hive可基于yarn spark mr三种情况运行
基于mr的过程执行较慢，但不会出现内存不足或无法执行的情况，但过程是单线程，一个任务在跑的时候，其他任务会等待。
基于spark的过程执行较快，但过程执行完成后不会释放spark连接，只有在hive退出或hiveserver2断开连接时才会释放。且spark必须限制内存使用，最少每任务要2G以上否则不执行过程。
基于yarn的过程与基于spark的类似，可分组执行多任务，任务按组排队，同样存在过程执行完成后不会释放spark连接，只有在hive退出或hiveserver2断开连接时才会释放。且内存最少每任务要2G以上否则不执行过程。
hive2.3.4默认使用的spark是2.0.0版本，官方已经不提供此版本的使用及下载。

hadoop3.2.0 hive3.1.1 可以正常使用，此过程hive基于mr使用，但需要注意hive从2.0版本开始已经不推荐使用mr方式，主要推荐spark和tez方式。
hive3.1.1需要hadoop3.0以上版本，hive3.1.1支持的tez默认版本是0.9.1, tez0.9.1支持的hadoop版本是2.7.0，tez0.9.1在hadoop3.0以上版本基础上编译时无法通过
tez0.9.2版本默认支持hadoop2.7.0，但可以在hadoop3.2.0上编译通过，hive也可以基于tez0.9.2版本编译通过，但在使用过程中会报错。



##################################

#安装必要的包
yum install protobuf protobuf-devel
#设置时区
timedatectl set-timezone Asia/Shanghai
#如果用sqoop导postgresql数据，则要安装psql
yum install postgresql-devel

#查看ulimit 数量限制
ulimit -a
#修改最大进程数
vim /etc/security/limits.d/90-nproc.conf
#如果openfile 比1024大得多，就不用箮了，否则要修改
vim /etc/security/limits.conf
#在这个文件后加上：
* soft nofile 10240
* hard nofile 10240
vim /etc/profile
#写入以下内容
ulimit -HSn 10240
ulimit -n 4096
ulimit -u 10240

#开防火墙端口 上半部分是机器互相之间的通讯，有多少台机器就要开多少台机器的端口，下半部分是对外提供接口或网站端口，需要开一个网段。
#对于计划未来要加机器的话，建议全按网段开，这样加机器的时候就不用一台一台的改防火墙了。
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.76" port protocol="tcp" port="8030" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.76" port protocol="tcp" port="8031" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.76" port protocol="tcp" port="8032" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.76" port protocol="tcp" port="8033" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.76" port protocol="tcp" port="8040" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.76" port protocol="tcp" port="8042" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.76" port protocol="tcp" port="9866" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.76" port protocol="tcp" port="9867" accept"

firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="8020" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="8088" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="9870" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="10000" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="9864" accept"
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="10.1.1.1/24" port protocol="tcp" port="10002" accept"



#配置hosts 加入各机器的ip和机器名
vim /etc/hosts

###以下用普通用户执行
#建立各机器间的无密码访问--注意修改用户名和机器名
ssh-keygen

#在主机上将另外几台的id_rsa.pub考到主机上，做成免密登录文件
scp xkwbi@storm02:/home/xkwbi/.ssh/id_rsa.pub ./s2.pub
scp xkwbi@storm03:/home/xkwbi/.ssh/id_rsa.pub ./s3.pub
scp xkwbi@storm04:/home/xkwbi/.ssh/id_rsa.pub ./s4.pub
#生成免密文件
cat .ssh/id_rsa.pub >> .ssh/authorized_keys
cat s2.pub >> .ssh/authorized_keys
cat s3.pub >> .ssh/authorized_keys
cat s4.pub >> .ssh/authorized_keys

scp .ssh/authorized_keys xkwbi@storm02:/home/xkwbi/.ssh/
scp .ssh/authorized_keys xkwbi@storm03:/home/xkwbi/.ssh/
scp .ssh/authorized_keys xkwbi@storm04:/home/xkwbi/.ssh/


#此时登录所有机器，使用ssh连接一下其他机器，会问是否加入known_hosts，选择加入
ssh storm03

#完成后在每台机器上修改.ssh文件夹权限，设置为只读权限
chmod -R 500 .ssh


#解压jdk、hadoop、hive、sqoop的包
tar -zxf hadoop_all.tar.gz
mv hadoop-3.2.0 hadoop
mv apache-hive-3.1.1-bin hive 


#在数据库中建一个hive要用的资料库用户
create user hive password 'hive123456';
create database hive311 with owner hive;

#配置环境变量 export HADOOP_USER_NAME=hive是必须要加的，要不各个程序写的文件权限不一致;docker还要加export LANG=zh_CN.UTF-8 要不中文全是乱码
vim .bashrc
export SCALA_HOME=/home/yy/scala
export SQOOP_HOME=/home/yy/sqoop
export JAVA_HOME=/home/yy/jdk8
export HADOOP_HOME=/home/yy/hadoop
export HIVE_HOME=/home/yy/hive
export SPARK_HOME=/home/yy/spark
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH
export PATH=$SCALA_HOME/bin:$SQOOP_HOME/bin:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HIVE_HOME/bin:$SPARK_HOME/bin:$PATH
export HADOOP_USER_NAME=hive
export LANG=zh_CN.UTF-8

#配置hadoop
vim hadoop/etc/hadoop/core-site.xml
vim hadoop/etc/hadoop/hdfs-site.xml
vim hadoop/etc/hadoop/yarn-site.xml
vim hadoop/etc/hadoop/slaves

vim hive/conf/hive-site.xml

#使用hive3.1.1就不用spark了，这部分就用不到了
#vim spark/conf/spark-defaults.conf
#vim spark/conf/slaves
#vim spark/conf/spark-env.sh
#cp hive/conf/hive-site.xml spark/conf/
#scp -r scala m2:/home/hadoop/
#scp -r scala m3:/home/hadoop/
#scp -r spark m2:/home/hadoop/
#scp -r spark m3:/home/hadoop/

###########################################3

#初始化hive的资料库
hive/bin/schematool -dbType postgres -initSchema

#将程序考到各个机器m2 m3是机器名，注意替换，hadoop的用户名，sqoop和hive只放在主机上就行
scp -r hadoop m2:/home/hadoop/
scp -r hadoop m3:/home/hadoop/
scp -r jdk8 m2:/home/hadoop/
scp -r jdk8 m3:/home/hadoop/


#初始化此过程，只能在初始化时执行一次，以后千万不能再执行，再执行会导致所有已有数据损坏 ！！！！！！
hdfs namenode -format
#启动hadoop 历史记录
mapred --daemon start
#启动程序
hadoop/sbin/start-all.sh
#spark/sbin/start-all.sh
hive/bin/hiveserver2

#到此结束，可以从页面进行访问或是从客户端连接hive
http://hadoop1:9870
http://hadoop1:8088
http://hadoop1:10002

jdbc:hive2://hadoop1:10000/default
user:hive
password:hive
#可以使用beeline或hive连接上以后建一个库 create database bi_srcapp

===================
改hive引擎 在hive的命令行中执行以下语句，临时改。如果要改默认的就改hive-site.xml中的配置。
set hive.execution.engine=spark;
set hive.execution.engine=mr;

使用sqoop从数据库同步数据
sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --fields-terminated-by '\001' --append --direct \
--columns requesttime,appid,userid,url,prevurl,eventname,ip,userislogin,browser,os,browser_ver,os_ver,insert_time,receive_time,uuid,topic,data1,eeid,query \
--where " receive_time > '20190625'::date " \
--target-dir /user/hive/warehouse/bi_srcapp.db/s_aliyun_log -- --schema bi_srcapp 








