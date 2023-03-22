更新时注意检查脚本里的内容
离职时间问题，11的不看离职时间
使用非表中字典数据，要加检查check
http://test.api.oa1.xkw.cn/OAService.asmx/
dwd层手动加mapp
拉链表初始化后要改一下初始时间sp_r_fac_user_acti_tran
新dwm要删除旧的过程
!= any有问题


vultr sardtas@126.com
45.32.73.21
Congratulations, ShadowsocksR server install completed!
Your Server IP        :  45.32.73.21 
Your Server Port      :  11080 
Your Password         :  yy123yy 
Your Protocol         :  origin 
Your obfs             :  plain 
Your Encryption Method:  aes-256-cfb 
zxxk.combi123456
python /usr/local/shadowsocks/server.py -c /etc/shadowsocks.json -d restart


sardtass@sina.com 
wget --no-check-certificate -O shadowsocks.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh
Congratulations, Shadowsocks-python server install completed!
Your Server IP        :  207.246.111.239 
Your Server Port      :  11080 
Your Password         :  yy123 
Your Encryption Method:  aes-256-gcm 

Welcome to visit:https://teddysun.com/342.html


#一些好玩有趣的命令
bb  
cmatrix -C red
lolcat
cal 9 1752
pi 100

#无法播放视频 mpeg-4 MPEG-4 AAC解码器和H.264解码器
apt install ubuntu-restricted-extras

#安装qemu 虚拟机
apt install qemu qemu-kvm libvirt-bin

#vmware安装后无法初始化 vmnet  --重新下一个新版本的就好使了， 下边的不一定好使
try this solution: https://askubuntu.com/questions/1041912/installing-vmware-on-18-04-failed-to-build-vmmon
or use this one:
#!/bin/bash
VMWARE_VERSION=workstation-15.0.4
TMP_FOLDER=/tmp/patch-vmware
rm -fdr $TMP_FOLDER
mkdir -p $TMP_FOLDER
cd $TMP_FOLDER
git clone https://github.com/mkubecek/vmware-host-modules.git
cd $TMP_FOLDER/vmware-host-modules
git checkout $VMWARE_VERSION
git fetch
make
sudo make install
sudo rm /usr/lib/vmware/lib/libz.so.1/libz.so.1
sudo ln -s /lib/x86_64-linux-gnu/libz.so.1
/usr/lib/vmware/lib/libz.so.1/libz.so.1
sudo /etc/init.d/vmware restart

#在虚拟机里安装macos后，屏幕大小无法调整，使用darwin安装插件就好了
引入 /usr/lib/vmware/isoimages/darwin.iso到光盘中，再安装，然后在macos中的配置里要确认来自vmware的调整。

#win10下vmware 无法启动，早期版本需要关闭windows虚拟化功能，15.5以后的版本需要开启虚拟化功能hyper-V 
#这个开不开不知道 组策略中的 计算机管理-管理模板-系统-device guard

#开机进入命令行模式 centos7以前的
0：关机
1：单用户
2：多用户状态没有网络服务
3：多用户状态有网络服务
4：系统未使用保留给用户
5：图形界面
6：重新启动
常用的是3和5，修改/etc/inittab 

systemctl set-default multi-user.target

#centos7以后的
rm -f /etc/systemd/system/default.target
设置命令行级别方法: 三选一
ln -sf /lib/systemd/system/runlevel3.target /etc/systemd/system/default.target 
ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target 
systemctl set-default multi-user.target
回窗口级别方法: 三选一
ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target 
ln -sf /lib/systemd/system/graphical.target /etc/systemd/system/default.target 
systemctl set-default graphical.target 

#看缓存大小
getconf -a | grep CACHE

#生成交换分区
sudo mkswap /dev/sdc1 
sysctl -q vm.swappiness
sysctl vm.swappiness=1
vim  /etc/sysctl.conf
vm.swappiness=1

#idea要求文件数
fs.inotify.max_user_watches = 524288
sudo sysctl -p --system

find
find /media/yangyong/MMCH_S2_D7/VIDEO_TS/ -size +100000000c -print $1 >> /work/tmp/t1.txt
find /media/yangyong/MMCH_S2_DISK8/VIDEO_TS/ -size +100000000c -print $1 >> /work/tmp/t1.txt

#按时间查第一层的文件夹
find . -maxdepth 1 -type d  -newermt 2021-05-01 ! -newermt 2021-05-31

#查所有文件中的
find ./ | xargs grep  direction
find ./ | grep sql | xargs grep  direction

#查10天前的
find ./ -mtime +10
#查10天内的
find ./ -mtime -10

#给用户加sudo 权限 把用户加到sudo组就可以了
usermod -G sudo username

#mount远程共享
apt install cifs-utils
sudo mount -t cifs -o username=yangyong,password=88,rw,uid=1000,gid=1000 //10.18.8.9/yangyong /work/b9
ntop
sudo usr/sbin/ntop -i eth4 -d  -u yangyong -P /work/data/ntop

fio的使用
fio -filename=/l1t/test_randread -direct=1 -iodepth 1 -thread -rw=randrw -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=100 -group_reporting -name=mytest
fio -filename=/l2t/test_randread -direct=1 -iodepth 1 -thread -rw=randrw -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=100 -group_reporting -name=mytest2
fio -filename=/work/test_randread -direct=1 -iodepth 1 -thread -rw=randrw -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=100 -group_reporting -name=mytest3

fio -filename=/test_randread -direct=1 -iodepth 1 -thread -rw=randrw -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=100 -group_reporting -name=mytest3

echo "1";
echo "2";
echo "4";
echo "5"; 
使用 sed替换内容
sed -i '1d' <file>
sed -i '$d' <file>
sed -i '/echo "2";/aecho "3";'  <file>
sed -i '/* /a*' <file>
sed -i '3d' <file>
sed -i '/^QWQ/d' <file>
sed -i '/QWQ/d' <file>
sed -i "s/ServerCube False /ServerCube True /g" `find /ulic/cognos/cube_swap/02 -name LR???.mdl`
sed -i "s/ServerCube True /ServerCube False /g" `find /ulic/cognos/tmp/02 -name LR???.mdl`
sed -i "s/ServerCube False /ServerCube True /g" `find ./ -name LR???.mdl`

sudo sed -i "s@http://packages.deepin.com/deepin@https://repo.huaweicloud.com/deepin@g" /etc/apt/sources.list

循环使用，变量有时候要用单引号引起来
for i in `ls *.pdf` ; do echo $i ${i%.pdf} ; done

linux时区调整
vim /etc/sysconfig/clock
ZONE=Asia/Shanghai
rm /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#字体问题，把字体放到/usr/share/fonts下的一个文件夹下
mkfontdir
mkfontscale
fc-cache


adduser postgres
yum -y install mysql-server mysql-devel vim openssh-server net-tools ibaio.i686 binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf devel gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel make numactl-devel sysstat compat-libstdc++-33 elfutils-libelf-devel gcc-c++ libaio-devel libstdc++-devel numactl-devel unixODBC libaio ntp nmap openssh-clients  flex bison readline-devel zlib-devel openjade docbook-style-dsssl wget flex flex-devel bison bison-devel 

#简化一点的
yum -y install mlocate vim openssh-server net-tools ibaio.i686 binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf devel gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel make numactl-devel sysstat compat-libstdc++-33 elfutils-libelf-devel gcc-c++ libaio-devel libstdc++-devel numactl-devel unixODBC libaio ntp nmap openssh-clients  flex bison readline-devel zlib-devel openjade docbook-style-dsssl wget flex flex-devel bison bison-devel 


centos 6
yum -y install https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-6-x86_64/pgdg-centos95-9.5-3.noarch.rpm
yum -y install postgresql95 postgresql95-server
service postgresql-9.5 initdb
chkconfig postgresql-9.5 on
service postgresql-9.5 start

centos 7
yum -y install https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm
yum -y install postgresql95 postgresql95-server
/usr/pgsql-9.5/bin/postgresql95-setup initdb
systemctl enable postgresql-9.5
systemctl start postgresql-9.5

centos7 从网上装
rpm -Uvh https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
#网上说装postgresql10-server 和 postgresql10就可以，只安装这两个的话，会缺少很多东西，安装wal2json的时候会报错
yum install -y postgresql10*

#pg12
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql12 postgresql12-server
/usr/pgsql-12/bin/postgresql-12-setup initdb
systemctl enable postgresql-12
systemctl start postgresql-12

#pg12的cdc centos的增强插件centos-release-scl 不装这个会报找不到llvm-toolset-7-clang
yum install -y llvm llvm-devel llvm-libs postgresql12-llvmji
yum install centos-release-scl
yum install postgresql12-common postgresql12-devel
#pg12要从命令行查看cdc的情况得全装，因为不知道那个命令到底在哪个包里。
yum install postgresql12*

#centos7 找不到service 命令 安装initscripts就可以了
yum -y install initscripts psmisc

192.168.216.135 gtm
192.168.216.136 datanode1
192.168.216.137 datanode2

#centos7 安装时无法启动，找不到boot 因为centos7的安装默认写了启动盘位置，如果u盘名称不同，就无法启动
启动时按e进入启动选项，把hd:后边写成u盘的实际硬件，一般是/dev/sdb4

#修改postgresql.conf
listen_addresses = '*'     #监听任何网段地址
#修改访问 pg_hba.conf
host all all 0.0.0.0/0 md5  #此行为添加的

# psql: FATAL:  Peer authentication failed for user "postgres"
su postgres 
psql

# 修改Postgres密码
 ALTER USER postgres WITH PASSWORD 'postgres';

!!!!如果其他用户不能登录还报错，很可能是因为使用了ipv6登录。把ipv6改成md5的。
vim pg_hba.conf
host all all ::1/128 md5

#！！！危险！慎用！ 临时调整postgresql的redo日志目录为tmpfs，用于导入.pg_restore
su
cd /var/lib/postgresql/10/main/
service postgresql stop
mv pg_wal /vm
mount -t tmpfs -o size=20g tmpfs /var/lib/postgresql/10/main/pg_wal
cp /vm/pg_wal/* /var/lib/postgresql/10/main/pg_wal/
chown -R postgres:postgres pg_wal
#一定要修改redo日志的大小限制，否则会太大导致失败，最好给内存分配16G以上，即使设置了以下参数，但仍会有内存不够的情况
vim /etc/postgresql/10/main/postgresql.conf
max_wal_size = 2GB
min_wal_size = 80MB
#checkpoint_completion_target = 0.5     # checkpoint target duration, 0.0 - 1.0
#checkpoint_flush_after = 256kB         # measured in pages, 0 disables
checkpoint_warning = 1s 
service postgresql start

#导入之后一定要修改回来！！要不pg就无法启动了
service postgresql stop
cp -r pg_wal /
umount /var/lib/postgresql/10/main/pg_wal
mv /pg_wal ./

#安装postgresql 12 https://www.postgresql.org/download/linux/ubuntu/
sudo echo 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update


#pg12 的cdc wal2json要安装epel-release后安装llvm， 要看日志得装centos-release-scl后装llvm-toolset-7.0 再装postgresql12-devel
# 1. Install a package with repository for your system:
# On CentOS, install package centos-release-scl available in CentOS repository:
$ sudo yum install centos-release-scl

# On RHEL, enable RHSCL repository for you system:
$ sudo yum-config-manager --enable rhel-server-rhscl-7-rpms

# 2. Install the collection:
$ sudo yum install llvm-toolset-7.0

# 3. Start using software collections:
$ scl enable llvm-toolset-7.0 bash

#从grub启动
set=root(hd0,gpt3)
chainloader /efi/.../*.efi
boot

#更新grub
update-grub

#查看树结构
tree 

#删除重复文件 -r 查找 -d 删除 -rdN 查找删除只保留第一个
fdupes 

分类查询：systemctl list-units --type service --all
查询所有：systemctl list-unit-files

#安装yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn

#设置使用淘宝的源
npm config set registry https://registry.npm.taobao.org
#在工程目录下新建文件 .npmrc
vim .npmrc  
registry "https://registry.npm.taobao.org"
sass_binary_site "https://npm.taobao.org/mirrors/node-sass/"


#用yarn安装node.js缺失的包，目录下有yarn.lock文件的时候
yarn install -g

#yarn 单独安装一个包
yarn global add eslint


#bi前端2019项目无法从其他机器访问,改dev中的地址，
vim cfg/dev.js 
#想用机器访问，就在 devtool: 'eval-source-map', 后边加 devServer: { disableHostCheck: true }, !!加了之后用ip就不行了。还是别用了

#This account is currently not available.
usermod -s /bin/bash username

#git 的相关
8、 执行“ git add .”（注意最后的.）把修改提交到本地缓存
9、 执行“git commit -m '提交的注释信息'” 提交到本地库
10、 执行“git remote add origin git 路径”把本地库设置同步到远程服务器
11、 执行“git push --set-upstream git 路径 master” 设定默认上传地址，并且进行第一次同
步到服务器

#编译
git clone http://github.com/streamsets/datacollector
git clone git@github.com/streamsets/datacollector

#docker streamsets
docker pull streamsets/datacollector:3.16.0-latest
docker run --restart on-failure -p 18630:18630 -d --name streamsets-dc streamsets/datacollector dc
#登录这后用户是sdc，想用root的话，得执行 sudo chmod 4755 /bin/busybox

#streamsets使用代理下载包
export SDC_JAVA_OPTS="-Xmx1024m -Xms1024m -Dhttps.proxyUser=MyName -Dhttps.proxyPassword=MyPsswrd -Dhttps.proxyHost=138.0.0.1 -Dhttps.proxyPort=3138 -server ${SDC_JAVA_OPTS}" 

export SDC_JAVA_OPTS="-Dhttps.proxyHost=socks://127.0.0.1 -Dhttps.proxyPort=4080 ${SDC_JAVA_OPTS}" 

#docker 版streamsets sdc
docker pull streamsets/datacollector
docker run --restart on-failure -p 28630:18630 -d --name streamsets-dc streamsets/datacollector

#docker 版clickhouse
docker run -d -p 18123:8123 -p19000:9000 --name ch --ulimit nofile=262144:262144 clickhouse/clickhouse-server


可以使用 git fetch 解决:
     mkdir common
     cd common
     git init
     git fetch http://android.git.kernel.org/common.git
     传完后,
     git branch -a
     git checkout remotes/....
如果中间断掉了, 可以直接进入common目录, 继续git fetch就可以续传了.

#暂存操作
git stash save '本次暂存的标识名字'
#查看记录
git stash list
#恢复指定的暂存工作, 暂存记录保存在list内,需要通过list索引index取出恢复
git stash pop stash@{index}
#删除某个暂存, 暂存记录保存在list内,需要通过list索引index取出恢复
git stash drop stash@{index}
#删除全部暂存
git stash clear
#新建分支
$ git checkout -b iss53
Switched to a new branch "iss53"
它是下面两条命令的简写：
$ git branch iss53
$ git checkout iss53

#恢复 删除的文件
git reset HEAD 文件名
git checkout 文件名

#恢复修改的文件
git reset HEAD
git checkout 文件名
git pull 



#查看ulimit 数量限制
ulimit -a
#修改最大进程数
vim /etc/security/limits.d/90-nproc.conf
#如果openfile 比1024大得多，就不用箮了，否则要修改
vim /etc/security/limits.conf
#在这个文件后加上：
* soft nofile 10240
* hard nofile 10240
------这个不好用，用下边的
vim /etc/profile
#写入以下内容
ulimit -HSn 10240
ulimit -n 4096
ulimit -u 10240
---------
非root用户需再另行配置：
sudo vim /etc/systemd/system.conf
修改：
DefaultLimitNOFILE=65535


安装sdk
curl -s "https://get.sdkman.io" | bash


#看端口状态
 netstat -anp |grep 10000
#看被哪个进程占用
lsof -i :3306
#按用户查
- lsof -a -u test -i


批处理命令连接执行，使用 |
串联: 使用分号 ;
前面成功，则执行后面一条，否则，不执行:&&
前面失败，则后一条执行: ||
ls /proc && echo  suss! || echo failed.

------------------------------------------kafka:

kafka-topics.sh --create --zookeeper datanode1:2181 --replication-factor 1 --partitions 3 --topic  tp1_d_log
kafka-topics.sh --list --zookeeper datanode1:2181
kafka-topics.sh  --delete --zookeeper datanode1:2181  --topic tp1_d_log

kafka-console-producer.sh --broker-list datanode1:9092 --topic tp1_d_log
kafka-console-consumer.sh --zookeeper datanode1:2181 --topic tp1_d_log --from-beginning


1.启动主节点nimbus ：
storm nimbus >/dev/null 2>&1 & 
2.启动两个从节点supervisor：
storm supervisor >/dev/null 2>&1 &
3.主节点上启动UI管理
storm ui >/dev/null 2>&1 & 

storm 跑自己的程序时需要把jar包放到storm/extlib/ 下
自己的程序输出在logs/works....文件夹下边。

--------------------- 


注意环境变量是否配置成功
kafka-server-start.sh config/server.properties &
#后台启动
kafka-server-start.sh /home/yy/kf/config/server.properties 1>/dev/null 2>&1 &
#如没有配置环境变量也可以直接使用绝对路径（或相对路径）启动
/usr/local/kafka_2.11-0.10.2.1/bin/kafka-server-start.sh /usr/local/kafka_2.11-0.10.2.1/config/server.properties &



---------------------------------------zookeeper
sh ./bin/zkServer.sh start
1
使用客户端链接zookeeper

bin/zkCli.sh -server 192.168.1.101:2181,192.168.1.102:2181,192.168.1.103:2181





----------------------------------------hadoop
yarn 启动不了 报local-dirs are bad: 
空间不够90%，就会报这个错

----------------------------------------spark
编译spark
用下边这个比较好
./dev/make-distribution.sh --name hadoop2.7.7 --tgz  -Pyarn -Phadoop-2.7 -Dhadoop.version=2.7.7


提交本地任务 
spark-submit --master local[2] --deploy-mode client --class com.xkw.bi.log.spark.AliyunSpark hdfs://datanode1:8020/user/yy/jar/bs.jar

提交集群任务 
spark-submit --master spark://datanode1:7077  --name alispark \
--num-executors 1 --driver-memory 1G --executor-memory 2G --executor-cores 1 \
--deploy-mode cluster \
--class com.xkw.bi.log.spark.AliyunSpark \
hdfs://datanode1:8020/user/yy/jar/bs.jar


spark-submit --master spark://datanode1:7077   --name alispark \
--num-executors 1  --executor-memory 8g --executor-cores 2 \
--deploy-mode cluster \
--class com.xkw.bi.log.spark.AliyunSpark \
hdfs://datanode1:8020/user/yy/jar/bs4.jar

spark-submit --master spark://datanode1:7077   --name alispark \
--num-executors 1  --executor-memory 512M --executor-cores 2 \
--deploy-mode cluster \
--class com.xkw.bi.log.spark.SparkTest3 \
hdfs://datanode1:8020/user/yy/jar/bs1.jar

#yarn配置
<property><name>mapreduce.map.memory.mb</name><value>1024</value></property>
<property><name>mapreduce.reduce.memory.mb</name><value>1024</value></property>
<property><name>mapreduce.map.java.opts</name><value>812</value></property>
<property><name>mapreduce.reduce.java.opts</name><value>816</value></property>

<property><name>yarn.nodemanager.container-manager.thread-count</name><value>6</value></property>

#yarn 多任务执行
<property><name>yarn.resourcemanager.scheduler.class</name>
<value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler</value></property>
<property><name>yarn.scheduler.fair.allocation.file</name><value>/home/yy/hadoop/etc/hadoop/fair-scheduler.xml</value></property>

hdfs namenode -format
---------------------------------------hive
编译hive
使用 hive-2.3.4版本，其他可能都不好用
只有这名好用：
mvn clean package -Pdist -DskipTests
编译tez
yum install nodejs nodejs-devel npm git 
npm -g install bower 
#以上用root执行，但编译一定要用非root用户，因为编译过程中会调用bower install命令，这个命令如果用root执行，会报一个错，说要加上--allow-root，然后后边就没法执行了
mvn clean package -DskipTests=true -Dmaven.javadoc.skip=true

#hbase编译
mvn -DskipTests clean package assembly:single -Dhadoop.profile=3.2.0 -Dhadoop-three.version=3.2.0

#hadoop编译
mvn package -Pdist -DskipTests -Dtar -Dmaven.javadoc.skip=true

#hadoop清理空间 删除回收站里的内容
hdfs dfs -expunge



#druid编译要带上这个，要不会说没找到key : gpg.skip=true
mvn clean install -Papache-release,dist,rat -DskipTests -Dgpg.skip=true -T 12

spark-env.sh
SPARK_MASTER_HOST=datanode1
SPARK_MASTER_PORT=7077
SPARK_WORKER_CORES=2
SPARK_WORKER_MEMORY=8g

spark-defaults.conf

spark.deploy.defaultCores          1
spark.cores.max                    6
spark.eventLog.enabled             true
spark.eventLog.dir                 hdfs://datanode1:8020/user/yy/spark-log
spark.history.provider             org.apache.spark.deploy.history.FsHistoryProvider
spark.history.fs.logDirectory      hdfs://datanode1:8020/user/yy/spark-log
spark.history.fs.update.interval   10s
spark.history.ui.port                    18080



hive on spark
修改bin/hive，增加spark的包，以下语句
for f in ${SPARK_HOME}/jars/*.jar; do
     CLASSPATH=${CLASSPATH}:$f;
done

hive 
初始化数据库
schematool -dbType postgres -initSchema

将$SPARK_HOME/lib目录下面的spark-assembly开头的那个jar包拷贝到$HIVE_HOME/lib目录下面,否则报找不到类的错误
hive/bin/hiveserver2
schematool -dbType postgres -initSchema
要在hadoop core-site.xml中增加以下内容使hive能访问hadoop数据，其中yy要换成安装用户名
<property>
    <name>hadoop.proxyuser.yy.hosts</name>
    <value>*</value>
</property>
<property>
    <name>hadoop.proxyuser.yy.groups</name>
    <value>*</value>
</property>

==========

<property>
<name>hive.enable.spark.execution.engine</name>
<value>true</value>
</property>
<property>
<name>spark.home</name>
<value>/data/hadoop/spark</value>
</property>
<property>
<name>spark.enentLog.enabled</name>
<value>true</value>
</property>
<property>
<name>spark.enentLog.dir</name>
<value>hdfs://nn1:9000/spark-logs</value>
</property>
<property>
<name>spark.serializer</name>
<value>org.apache.spark.serializer.KryoSerializer</value>
</property>
<property>
<name>spark.executor.extraJavaOptions</name>
<value>-XX:+PrintGCDetails -Dkey=value -Dnumbers="one two three"</value>
</property>



=========
改hive引擎 
set hive.execution.engine=spark;
set hive.execution.engine=mr;

=========
yarn报return 1 没有权限的问题 以下可能不是主要问题，应该是yarn问题。
groupadd supergroup
usermod -a -G supergroup root
usermod -a -G supergroup hive
usermod -a -G supergroup yy

usermod -a -G supergroup mapred
usermod -a -G supergroup hdfs
usermod -a -G supergroup hive
usermod -a -G supergroup hue
usermod -a -G supergroup spark
sudo -u hdfs hadoop fs -chmod 770 /user

数据太多导不进去

----------------------------------------sqoop

sqoop import   \
--connect jdbc:postgresql://10.1.1.97:5432/dc_logs --username bi_log --password bi_log123456 -m 1 \
--table d_zxxk_cl_soft  --fields-terminated-by '\001' --append --direct --where ' softid < 10000000' \
--target-dir /user/hive/warehouse/t25 -- --schema bi_fdm 

sqoop import   \
--connect jdbc:postgresql://10.1.1.97:25432/dc_logs --username bi_log --password uat123 -m 1 \
--table c_cfg_glob_para --direct --fields-terminated-by '\001' \
--target-dir /user/hive/warehouse/bi_log.db/slog -- --schema bi_fdm 

hadoop的mr任务一直在等待，状态是accept，但是一直不运行，因为yarn认为没有资源可以运行。在yarn-site.xml中增加以下内容
一直等待是因为datanode2和3返回信息的时候使用了自己的机器名，datanode1找不到机器名

<property><name>yarn.scheduler.minimum-allocation-mb</name> 
	<value>1024</value> <discription>单个任务可申请最少内存，默认1024MB</discription> </property> 

<property> <name>yarn.nodemanager.resource.memory-mb</name>
 <value>4096</value> <discription>nodemanager默认内存大小，默认为8192MB（value单位为MB）</discription> </property> 

<property> <name>yarn.nodemanager.resource.cpu-vcores</name> 
<value>4</value> <discription>nodemanager cpu内核数</discription> </property>

<property> <name>yarn.scheduler.minimum-allocation-mb</name>
<value>1024</value> </property>

增加机器名试试
172.17.0.6 9c904bfe588d
172.17.0.7 578fdabd628c
172.17.0.5 01473e201d47
172.17.0.5      datanode1
172.17.0.6      datanode2
172.17.0.7      datanode3
-------------------------------------------------

--------------------------------------------redis
#安装redis
tar -zxf redis-stable.tar.gz
cd redis-stable
make
make test
vim redis.conf
#修改配置文件，开启远程访问，注释掉 bind 127.0.0.1 ，并将protected-mode yes  改为 protected-mode no

#后台运行 改配置文件 redis.conf
daemonize yes

#建立软连接
cd
ln -s redis-stable redis
#启动redis
redis-server /home/yy/redis/redis.conf >/dev/null 2>&1 &


/home/storm/redis53371/src/redis-server /home/storm/redis53371/redis.conf >/dev/null 2>&1 &
/home/storm/redis53372/src/redis-server /home/storm/redis53372/redis.conf >/dev/null 2>&1 &

[yy@e035f4402285 ~]$ more szstart.sh 
#/home/stormyy/redis/src/redis-server /home/storm/redis/redis.conf > /dev/null 2>&1 &
/home/storm/zk/bin/zkServer.sh start
/home/storm/storm/bin/storm supervisor >/dev/null 2>&1 &
/home/storm/storm/bin/storm nimbus >/dev/null 2>&1 & 
#/home/storm/storm/bin/storm ui >/dev/null 2>&1 & 

redis-cli --cluster create 172.17.0.5:53371 172.17.0.6:53371 172.17.0.7:53371 172.17.0.6:53372 172.17.0.7:53372 172.17.0.5:53372 --cluster-replicas 1

#端口转发 可转发机器(可以使用这个转发的机器)：转发机a的端口：目的机a：目的机端口 转发机 
#然后由可转发机器连接 转发机a的8087时，会转发到目的机的80端口 带&不行，下次整个无密码登录再试
ssh -L 10.0.0.0/24:8087:localhost:80 root@172.17.0.2 
#本地转发， 本地端口：目的机：目的机端口 转发机
ssh -L 10.1.1.1:17250:172.17.0.5:10000 -N 10.1.1.97

ssh -L 17250:172.17.0.3:10000 -N 10.1.1.87
ssh -L 17250:172.17.0.3:10000 -N pc33c &
ssh -L 22:172.17.0.5:10022 -N pc33c &
ssh -L 7182:172.17.0.3:7182 -N 10.1.1.97 &


hive编译
mvn clean package -Pdist
mvn clean package -Pdist -DskipTests
spark编译 
build/mvn clean package -Pdist -DskipTests

ftp使用
apt install vsftpd
vim /etc/vsftpd.conf
listen=YES
local_enable=YES
local_root=/work
write_enable=YES

#win10打不开ftp
1.首先打开浏览器，点击右上角工具。
2.其次点击Internet选项。
3.然后点击高级。
4.最后下拉把使用被动FTP勾掉，点击确定。


---------------------------------------
linux相关
ubuntu 禁用服务
update-rc.d apache2 remove
redhat centos 禁用服务
chkconfig apache2 off

#apache 安装
apt install apache2
yum install httpd

#apache网页无法访问时，看一下目录权限，需要从根目录下第一个文件夹就有查看权限。
#apache默认的打开页面
vim /etc/apache2/sites-enabled/000-default.conf 
#把其中的/var/www/html改了就行

#当前运行进程数
while true; do ps -u yangyong -L | wc -l ; sleep 1; done
while true; do ps -ef -L | wc -l ; sleep 1; done




#nfs 配置
安装nfs和rpc服务
apt install nfs-server
vim /etc/exports
/work/nfs/pgdata 10.1.1.97/32(rw,anonuid=1000,anongid=1000,all_squash,sync,no_subtree_check)
/work/nfs/nobody 10.1.1.1/24(rw,anonuid=1000,anongid=1000,all_squash,sync,no_subtree_check)
/work/nfs/readonly pc33(rw,anonuid=1000,anongid=1000,all_squash,sync,no_subtree_check) pc44(rw,anonuid=1000,anongid=1000,all_squash,sync,no_subtree_check)
#insecure

service rpcbind start
/etc/init.d/nfs-kernel-server restart
rpcinfo -p localhost
showmount -e localhost
#客户端 一定要加上v3，要不报 mount.nfs: access denied by server while mounting 
#注意没有权限也有可能是共享的目录没有权限，需要从根目录开始都有权限才行。
mount -t nfs 10.1.1.87:/work/nfs/pgdata /work/nfs/pc88pgdata -o proto=tcp -o nolock -v3
mount -t nfs 10.1.1.87:/work/nfs/nobody /tmp/p88 -o proto=tcp -o nolock

apt install nfs-commons

# 报错，挂不了磁盘 Mount /proc/fs/nfsd first
nfsd /proc/fs/nfsd nfsd auto,defaults 0 0

#报错，无法连接上，错误如下
mount.nfs: requested NFS version or transport protocol is not supported
#看服务状态
sudo systemctl status nfs-kernel-server
#exports里得加上 no_subtree_check 要不启动不了

#smb 共享 查看共享了哪些内容
smbclient -L //10.1.1.106 -U guest
sudo apt install cifs-utils
sudo mount -cifs -o username=xxx,password=xxx,rw,gid=1000,uid=1000 //xx.xx.x.x /mountdir

#无法访问windows共享
待打开“组策略”编辑界面后，依次展开“计算机管理”-“Windows设置”-“安全设置”-“本地策略”-“安全选项”项，在右侧找到“账户：来宾账户状态”项并右击，从其右键菜单中选择“属性”项。
在“组策略”编辑界面中，依次展开“计算机管理”-“Windows设置”-“安全设置”-“本地策略”-“用户权限分配”项，在界面右侧找到“拒绝本地登陆”项并右击选择“属性”项。
从打开的“计算机管理”界面中，依次展开“计算机管理”-“本地用户和组”-“用户”项，此时就可以在右侧找到“Guest”账户，右击“Guest”账户选择“属性”项

#centos挂上不ntfs 下载epel
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum -y install ntfs-3g
#yum 安装ganglia 注意 epel-release必须先装，要不找不到ganglia
yum install -y epel-release
#主节点安装
yum install -y ganglia-gmetad ganglia-devel ganglia-gmond rrdtool httpd ganglia-web php telnet telnet
#被监控节点安装
yum install -y ganglia-gmond
#主节点配置
ln -s /usr/share/ganglia /var/www/html
chown -R apache:apache /var/www/html/ganglia
chmod -R 755 /var/www/html/ganglia
#用不着这一步 有这一步就打不开页面了chown -R nobody:nobody /var/lib/ganglia/rrds
chmod 777 /var/lib/ganglia/dwoo/compiled
chmod 777 /var/lib/ganglia/dwoo/cache
vim /etc/httpd/conf.d/ganglia.conf
#将Require local 改为  Require all granted
vim /etc/ganglia/gmetad.conf
#参数 组 间隔时间 各台机器
data_source "myc7aa" 10 172.17.0.2:8649 172.17.0.3:8649  
vim /etc/ganglia/gmond.conf
#注释掉多播模式的,以下出现这个都要注释掉
#mcast_join = 239.2.11.71
#添加单播模式的
host = 192.168.26.139  
#启动主节点
systemctl start httpd.service
systemctl start gmetad.service
systemctl start gmond.service
systemctl enable httpd.service
systemctl enable gmetad.service
systemctl enable gmond.service

#启动其他被监控节点
systemctl start gmond.service
systemctl enable gmond.service
#访问 ip/ganglia 即可

#gdm和lightdm
sudo dpkg-reconfigure gdm3

#安装nagios
yum -y install nagios nagios-plugins nagios-plugins-all nagios-plugins-nrpe nrpe
#被监控端安装 
yum -y install nagios-plugins-all nrpe
vim /etc/nagios/nrpe.cfg 
allowed_hosts=127.0.0.1,172.17.0.2

echo 'nrpe:172.17.0.6' >> /etc/hosts.allow
#启动nrpe进程
/usr/sbin/nrpe -c /etc/nagios/nrpe.cfg -d
#从主机看被监控机能不能通
/usr/lib64/nagios/plugins/check_nrpe -H 172.17.0.3
/usr/lib64/nagios/plugins/check_nrpe -H 172.17.0.3 -c check_users
#在主机操作
#增加nrpe的相关内容
vim /etc/nagios/objects/commands.cfg
# vi commands.cfg
# 'check_nrpe' command definition
define command{
    command_name check_nrpe
    command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}
vim /etc/nagios/objects/03.cfg
配置一下
echo "cfg_file=/etc/nagios/objects/03.cfg" >> /etc/nagios/nagios.cfg
#看一下ping的权限是否是-rwsr-xr-x 1 root root 66176 Aug  4  2017 /bin/ping 如果不是，用下面的语句授权。
chmod 4755 /bin/ping
#没有ping命令
apt install iputils-ping 
#启动主程序
systemctl start nagios
默认密码：nagiosadmin/nagiosadmin
配置的命令要自己写，plugin要自己下
主机通过02.cfg调用commands中的命令，commands.cfg是调用plugin命令的
其他机器是由主机调用03.cfg，03.cfg远程调用其他机器上的nrpe.cfg，由nrpe.cfg中的commands命令执行plugins中的内容再发结果返回。
nagios.cfg中的interval_length=10 代表多长时间发一次邮件

./check_http -H oa.xkw.cn -u http://oa.xkw.cn/Function/Index.html -a yangyong:Caramon888 -w 1 -c 2


#将用户加入组 加组 sudo组 sudo权限
usermod -a -G sudo yangyong

#安装发送邮件程序
yum -y install mailx sendmail sendmail-dlevel
vim /etc/mail.rc
set from=sardtas@sina.com
set smtp=smtp.sina.com
set smtp-auth-user=sardtas@sina.com
set smtp-auth-password=passwd
set smtp-auth=login

echo "hello world" | mail 837493225@qq.com


#安装python yum install -y crontabs    systemctl start crond
yum install -y python36 python36-pip python36-devel postgresql-devel 
pip3 install psycopg2
#ubuntu pg12以后没有 postgresql-devel 了 装下边这两个
apt install libpq-dev python-dev

#使用清华的源
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

#有时候源有问题 就用另外一个源
pip3 install sklearn -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com

#百度的源
pip install xxx -i https://mirror.baidu.com/pypi/simple

#临时使用清华的源
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/peterjc123/

#生成requirements.txt文件
pip freeze > requirements.txt
#安装requirements.txt依赖
pip install -r requirements.txt

#安装多线程 multiprocessing 报错，不要带ing
pip3 install multiprocess

cv2  opencv-python
PIL Pillow

#centos查找少的库
yum whatprovides libSM.so.6
#ubuntu 试试
sudo apt-cache search libsm
#查看显卡使用情况
watch -n 10 nvidia-smi

#用于管理显卡的
optimus-manager-qt

#安装显卡的cuda  https://developer.nvidia.com/cuda-downloads
wget http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run
sudo sh cuda_10.1.243_418.87.00_linux.run

#以deb方式安装 10.1
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-ubuntu1804-10-1-local-10.1.243-418.87.00_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-10-1-local-10.1.243-418.87.00_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-1-local-10.1.243-418.87.00/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
#在.bashrc中增加
export CUDA_HOME=/usr/local/cuda-10.1
export PATH=$CUDA_HOME/bin:${PATH}
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:${LD_LIBRARY_PATH}

#有时候升级后驱动就不好使了，nvidia-smi说没有驱动，要重装一下 dkms没有就装一下,看一下状态，按状态安装
dkms status 
dkms install -m nvidia -v 418.87.00

#nvidia-smi不好使，有可能是显卡找不到了
lspci | grep -i nvidia
nvidia-detector

#10.2的安装
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
#到这

#11.7的安装
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu1804-11-7-local_11.7.0-515.43.04-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-11-7-local_11.7.0-515.43.04-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu1804-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda

#找不到libcublas 安装cuda的网络版，不用装cuda，安装好deb就可以搜出这个了

# 由于没有公钥，无法验证下列签名： NO_PUBKEY A4B469963BF863CC
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv A4B469963BF863CC



#安装cudnn   https://developer.nvidia.com/rdp/cudnn-download
#tar文件 解压，把东西考到/usr/local/cuda相应的目录下就可以了

#deb包
sudo dpkg -i cudnn-local-repo-${OS}-8.x.x.x_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-*/cudnn-local-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
#runtime
sudo apt-get install libcudnn8=8.x.x.x-1+cudaX.Y
#developer
sudo apt-get install libcudnn8-dev=8.x.x.x-1+cudaX.Y
#安装sample，这个可以不装
sudo apt-get install libcudnn8-samples=8.x.x.x-1+cudaX.Y


#卸载显卡驱动
#apt autoremove nvidia*

anaconda
conda update conda
conda update --all
#安装pytorch  https://pytorch.org/get-started/locally/
conda install pytorch torchvision cudatoolkit=10.0 -c pytorch

pip3 install torch torchvision

#建卷组 lvm 
pvcreate /dev/sda2 /dev/sdd2 ....
vgcreate yy4vg /dev/sda2 /dev/sdd2 ....
lvcreate --type striped -i 4 -l 100%FREE -n lv4 y4
#全部空间用-l 100%FREE 指定大小用 -L 2T 
mkfs -t ext4 /dev/yy4vg/lv6
#格式化后会有uuid

#postgresql9.4使用， 先解压并安装9.4， 然后安装scws，然后装zhparser-master
tar -jxf scws-1.2.3.tar.bz2
cd scws*
./configure --prefix=/lv/scws
make 
make install
cd ../zhparser-master
export PG_CONFIG=/lv/postgresql94/bin/pg_config 
make && make install
#/lv/postgresql94/bin/postgres -D /lv/bi_backup -c config_file=/lv/bi_backup/postgresql.conf
#新装的还得装插件，估计要初始化后再安装，直接用服务器上的，把so文件考到postgresql/lib下边
cp scws/lib/libscws.* postgresql/lib/
#用postgre运行，数据文件夹只能是700权限，不能加同组和其他权限
sudo ln -s /lv /data
sudo chown -R postgres:postgres bi_backup
sudo chown -R postgres:postgres postgres
sudo chmod -R +044 postgresql
su postgres
/lv/postgresql/bin/postgres -D /lv/bi_backup -c config_file=/lv/bi_backup/postgresql.conf > /lv/postgresql/postgresql.log 2>&1 &

#也可以用下面的命令启动
/lv/postgresql/bin/pg_ctl start -D /lv/bi_backup

#postgresql nologging table 无日志表
CREATE UNLOGGED TABLE


#----------------------pg 12 安装
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql


#修改dns
sudo vim /etc/systemd/resolved.conf
DNS=119.29.29.29
systemctl restart systemd-resolved.service


#用户加入组
usermod -G groupname username (这种会把用户从其他组中去掉，只属于该组)
usermod -G hadoop hive (git只属于git组)

usermod -a -G groupname username (把用户添加到这个组，之前所属组不影响)
usermod -a -G hadoop storm (git属于之前git组，也属于www组)

#解决agetty占用过高的问题 不好使
systemctl stop getty@tty1.service
systemctl mask getty@tty1.service

#设置 ntp 
vim /etc/ntp.conf
server 10.1.1.97
restrict 10.1.1.97 nomodify notrap noquery
server 127.0.0.1 # local clock
fudge 127.0.0.1 stratum 10
#再把其他的server 注释掉
systemctl start ntpd
#ubuntu 启动ntp
sudo /etc/init.d/ntp restart
修改硬件时间：hwclock -w

ntpdate ntpserver

#windows linux 时间不一致 
HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/TimeZoneInformation/
添加一项类型为REG_DWORD的键值，命名为RealTimeIsUniversal，值为 1 然后重启后时间即回复正常


#安装动态壁纸
sudo add-apt-repository ppa:fyrmir/livewallpaper-daily
sudo apt-get update
sudo apt-get install livewallpaper
sudo apt-get install livewallpaper-config livewallpaper-indicator

#s-tui 显示cpu信息的 pip install s-tui

#改cpu频率
/sys/devices/system/cpu/intel_pstate/max_perf_pct
#看cpu频率
/sys/devices/system/cpu/cpu0/cpufreq

#看内存   硬件信息
dmidecode -t memory
dmidecode -t Processor
dmidecode -t
  bios
  system
  baseboard
  chassis
  processor
  memory
  cache
  connector
  slot

apt install hardinfo

#dns 
vim /etc/network/interfaces
dns-nameservers 8.8.8.8


#docker安装，centos和ubuntu默认安装的docker 都比较老，是docker.io 新版本需要自己安装
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io


#centos不支持中文 
#docker的话要装
rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #修改时区
yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common #安装中文支持
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
LANG=zh_CN.UTF-8


Failed to get D-Bus connection: Operation not permitted
docker 启动centos 7 要用-d /usr/sbin/init
docker run --name c7 --privileged -itd centos:7.6.1810 /usr/sbin/init

#System has not been booted with systemd as init system (PID 1). Can t operate.
docker run -d --name systemd-ubuntu --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro jrei/systemd-ubuntu

#docker 启动带图形的容器
-v /etc/localtime:/etc/localtime:ro -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -e GDK_SCALE -e GDK_DPI_SCALE

#centos 看系统服务 debian
systemct list-unit-files
service --list-all

#docker 启动postgresql
docker run --name dpcdh5 -e POSTGRES_PASSWORD=uat123 -p 25432:5432 -d postgres:9.4

#docker 的国内镜像地址
# vi /etc/docker/daemon.json
{
    "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
systemctl restart docker.service
国内加速地址有：
Docker中国区官方镜像
https://registry.docker-cn.com
网易
http://hub-mirror.c.163.com
ustc 
https://docker.mirrors.ustc.edu.cn
中国科技大学
https://docker.mirrors.ustc.edu.cn

#docker 启动不了，文件权限错误，全是问号，错误的消息 fsck对磁盘进行检查
fsck -y /dev/sda4
#docker 创建独立ip
service docker stop
vim /etc/docker/daemon.json
{
  "debug" : false,
  "default-address-pools" : [
    {
      "base" : "172.17.1.0/24",
      "size" : 24
    }
  ]
}
service docker start

#docker 创建自定义网络
docker network create --subnet=172.17.33.0/24 yynet
docker run --name testip --net yynet --ip 172.17.33.101 -itd centos:7.6.1810 /bin/bash

route add -net 10.1.0.0/16 gw 10.1.1.65

route add -net 172.17.0.0/24 gw 10.1.1.97 
docker run --name t1 -itd --privileged centos:7.6.1810 /usr/sbin/init
docker cp /var/www/html/yumrepo/pc88.repo t1:/etc/yum.repos.d/

docker run --name pg10 -p 15432:5432 -e POSTGRES_PASSWORD=uat123 -d postgres:10.10 
docker run --name pg12 -p 15432:5432 -e POSTGRES_PASSWORD=uat753951mis -d postgres:12.2 

#vpn 导致的http://gw.xkw.com/help/doc.html#/home 不能访问。
route -n
route del default gw 192.168.5.26

#vpn连不上 看一下这个不能注释，把注释去掉
redirect-gateway def1

route add -net 172.17.1.0/24 gw 10.1.1.87 
docker run --name t1 -itd --privileged centos:7.6.1810 /usr/sbin/init

# route: netmask doesn't match route address   错误 ip的最后一位或几位得是0,和掩码对应 10.1.1.0/24是对的  10.1.1.1/24就是错的


#mysql相关
docker pull mysql:5
docker run --name mysql57 -e MYSQL_ROOT_PASSWORD=uat123 -itd mysql:5.7
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

docker run --name mysql8 -p 13306:3306 -e MYSQL_ROOT_PASSWORD=uat123 -d mysql:8.0.25
docker run --name mysql8 -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci


#百度语音识别离线版 
docker run --name spc --runtime=nvidia -v $PWD:/mnt -p 8888:8888 -itd paddlecloud/paddlespeech:develop-gpu-cuda10.2-cudnn7-657c42 /bin/bash

#paddlespeech
目前测试基本上40秒以内的可以识别，超出40秒就不一定了。
sox 264b2a6e0f9d4018a54a6d2fe4e7dbaa.mp3 -r 16000 bb.wav trim 80 40
time paddlespeech asr --lang zh --input ./bb.wav 


#mysql5.6
docker run --name mysql56 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=uat123 -d mysql:5.6

#修改my.ini 改字符集和增加binlog
[client]
default-character-set=utf8mb4
[mysqld]
binlog-format=ROW
server_id = 100
log-bin=mysql-bin
character-set-server=utf8mb4

mysqlbinlog --no-defaults mysql-bin.000003 | less

#以下语句可以直接增加用户
GRANT USAGE ON * . * TO 'trinity'@'%' IDENTIFIED BY 'trinity' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 ;
#直接改mysql.user下的host不好使，仍然登录不了，建用户时一定要注意。
mysql -u root -h locahost -p

#mysql jdbc
wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar


#docker 局域网ip 
docker network create -d macvlan  --subnet=10.1.1.0/24 --gateway=10.1.1.65 -o parent=enp3s0 local-office
docker run --net=local-office --ip=10.1.1.150  -dit --name test centos:7.6.1810 /bin/bash


#docker 常用命令
docker system df 

#查看哪个进程正在使用硬盘
pidstat -d 1

#查看硬盘使用
ncdu



#在b上执行
route add -net 172.17.0.0/24 gw a(a的ip)
#在a上执行
route add -net 172.17.1.0/24 gw b(b的ip)

#如果是windows的话，得用下面这个命令
route add 172.17.0.0 mask 255.255.255.0 a(a的ip)

#看route信息的话，linux上用 route， windows上用 route print

#跑分
time echo "scale=5000; 4*a(1)" | bc -l -q


#抓包
tcpdump host 10.1.1.87
tcpdump port 3000
tcpdump tcp port 22 and src host 123.207.116.169
tcpdump ip host 210.27.48.1 and ! 210.27.48.2
(1)tcp: ip icmp arp rarp 和 tcp、udp、icmp这些选项等都要放到第一个参数的位置，用来过滤数据报的类型
(2)-i eth1 : 只抓经过接口eth1的包
(3)-t : 不显示时间戳
(4)-s 0 : 抓取数据包时默认抓取长度为68字节。加上-S 0 后可以抓到完整的数据包
(5)-c 100 : 只抓取100个数据包
(6)dst port ! 22 : 不抓取目标端口是22的数据包
(7)src net 192.168.1.0/24 : 数据包的源网络地址为192.168.1.0/24
(8)-w ./target.cap : 保存成cap文件，方便用ethereal(即wireshark)分析


#连接centos7 的 ssh 慢
vim /etc/ssh/sshd_config
加一句
UseDNS no

# vi /etc/ssh/sshd_config
GSSAPIAuthentication no
# vi /etc/nsswitch.conf
hosts： files dns
改为
hosts：files


#linux的启动项参数 phoenix 无法启动 命令行
nomodeset
不載入所有關於顯示卡的驅動
nouveau.modeset=0
關閉nvidia顯卡的驅動，反之 =1為開啟
i915.modeset=0
關閉Intel顯卡的驅動，挺好奇對於Intel內顯會有什麼影響
xforcevesa 或 radeon.modeset=0 xforcevesa
跟AMD顯卡(ATI)有關的設定，我猜也是關閉吧，反正我不會買A牌顯卡...
acpi=off
回歸舊時代，電源相關設定，OS無法控管，交給bios處理
acpi功能失效，有不少硬體上奇怪的問題，可以用這參數解決

#查看硬盘分区
lsblk
lsblk--->fdisk---->partprobe---->mkfs.xfs---->blkid---->mount---->df   -hT---->vim /etc/fstab---->mount   -a
#centos 挂不上ext4分区 error loading journal 问题，是因为磁盘由高版本系统格式化的，低版本认不出来。
使用yum update 更新系统即可

#运行命令 getenforce 获取当前selinux状态
Enforcing为开启
#临时
sudo setenforce 0
#永久
sudo vim /etc/sysconfig/selinux
SELINUX=disabled
#分区修改后通知系统已经修改
partprobe
centos下fdisk默认分区是ext2，无法直接挂载
mkfs -t ext4 /dev/sdb1


# yum 时出现错误，是因为没有配置dns Could not retrieve mirrorlist http://mirrorlist.centos.org/
vim /etc/resolv.conf 
如果已经配置了，那就有可能是之前修改了/etc/nsswitch.conf ，导致无法使用dns
service NetworkManager restart 

redis为默认端口号6379，无连接密码，删除命令如下
redis-cli keys "key*" | xargs redis-cli del
redis不为默认端口号6379，连接密码为"password"，删除命令如下
redis-cli -p 6380 -a "password" keys "key*" | xargs redis-cli -p 6380 -a "password" del
redis-cli -c -p 53371 keys "prdrt30*" | xargs redis-cli -c -p 53371 del 

maven下载所有需要的包
mvn dependency:copy-dependencies
maven 安装包
mvn install:install-file -Dfile=phoenix-client-4.14.0-cdh5.14.2.jar -DgroupId=org.apache.phoenix -DartifactId=apache-phoenix -Dversion=4.14.0-cdh5.14.2 -Dpackaging=jar

#用清华的网站安装pip
pip3 install xxx -i https://pypi.tuna.tsinghua.edu.cn/simple

ulimit -n ubuntu 的open files 无法超过4096,ubuntu的图形用户的open files无法超过4096,那另外一个没开图形的用户就可以用了。
ubuntu空间占用太多，vmware的拖拽会产生临时文件，都放在/home/user/.vmware下的drag_and_drop下了，删除这个下边的文件就行了。

#修改centos机器名 bogon 
hostnamectl set-hostname pc33c
#命令行下机器名变成 bogon
sudo scutil --set HostName mac60
#注意看一下机器名是否是bogon,bogon会影响后续的安装，用host 本机ip 看一下返回的名称是什么，如果是bogon，那就要改一下dns，/etc/resolv.conf文件中配置，如果dns返回是unknow，则会使用/etc/hosts中的配置，就没有问题了。

#folding@home covid-19 云计算 网格计算 grid 需要使用python2才行
wget https://download.foldingathome.org/releases/public/release/fahviewer/debian-stable-64bit/v7.6/fahviewer_7.6.13_amd64.deb
wget https://download.foldingathome.org/releases/public/release/fahcontrol/debian-stable-64bit/v7.6/fahcontrol_7.6.13-1_all.deb
wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.13_amd64.deb
sudo dpkg -i --force-depends fahclient_7.6.13_amd64.deb
sudo dpkg -i --force-depends fahcontrol_7.6.13-1_all.deb
sudo dpkg -i --force-depends fahviewer_7.6.13_amd64.deb
sudo apt-get install -y python-stdeb python-gtk2 python-all debhelper dh-python
FAHClient
sudo vim /usb/bin/FAHControl
#第一行改成python2
FAHControl
---3213 sardtas 46d6b9013d4b40f946d6b9013d4b40f9

#nodejs安装 8.x 这里以后可以换成10.x之类的
curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
yum -y install nodejs

#nodejs也可以从官网下载后，解压配置path后使用
http://nodejs.cn/download/
#安装cnpm，这个是淘宝的，速度更快一些
npm install cnpm -g --registry=https://registry.npm.taobao.org
npm config set registry https://registry.npm.taobao.org
npm install -g yarn
#报ca认证错误的
npm config set strict-ssl false
或  npm config set ca=""

#nodejs npm 不能用机器名访问 Invalid Host header
在dev.js的 devServer: { 下加  host: 'pc33',

#System limit for number of file watchers reached  主要是第三行
vim /etc/sysctl.conf
vm.swappiness = 1
vm.max_map_count = 655360
fs.inotify.max_user_watches = 524288

sudo sysctl -p 

#anbox安装 https://docs.anbox.io/userguide/install.html
add-apt-repository ppa:morphis/anbox-support
apt install -y anbox-modules-dkms
modprobe ashmem_linux
modprobe binder_linux
#snap 速度很慢 使用代理 
# systemctl edit snapd
加上：
[Service]
Environment="http_proxy=http://10.1.1.108:1080"
Environment="https_proxy=http://10.1.1.108:1080"
保存退出。
systemctl daemon-reload
systemctl restart snapd

snap install --devmode --beta anbox
#再看一下有没有装好
ps -aux | grep anbox
#安装新软件要先装 adb
sudo apt install curl adb wget lzip unzip squashfs-tools
wget https://raw.githubusercontent.com/geeks-r-us/anbox-playstore-installer/master/install-playstore.sh
chmod +x install-playstore.sh
sudo ./install-playstore.sh
#sudo ./install-playstore.sh --clean

#ls: 无法访问'/dev/binder': 没有那个文件或目录
git clone https://github.com/anbox/anbox-modules.git
cd anbox-modules
./INSTALL.sh
sudo modprobe ashmem_linux
sudo modprobe binder_linux

#INSTALL_FAILED_NO_MATCHING_ABIS
https://f-droid.org/packages/com.termux/


下载文件到www下后，要改权限。

然后，下载新的安装应用VMware-Horizon-Client-AndroidOS-x86-4.9.0-9565404
在终端上输入adb install，再把apk文件拖入到该命令后，要在命令之间注意空格然后执行命令。
adb install official_website6.2.2.663.apk

adb devices -l
#进入手机
adb shell 

# mtp android 挂载 默认在run/user目录
mtp://[usb:003,xxx]/
/run/user/$UID/gvfs/mtp:host=xxxxxxx

#linuxDeploy重启 手机linux重启
#重启linux deploy
unchroot linuxdeploy stop
#重启手机
unchroot am start -a android.intent.action.REBOOT
#关机
unchroot am start -a android.intent.action.ACTION_REQUEST_SHUTDOWN


# 手机系统刷新
fastboot devices
fastboot flash system /android4.0.4/x210.img
fastboot flash bootloader android4.0.4/uboot.bin
fastboot flash kernel android4.0.4/ZImage-android
fastboot reboot
#小米刷机 fastboot状态下直接执行就可以
flash_all.sh

#安装linux。busybox好像不装也可以，新的android有这些命令
#先安装linuxdeploy  https://github.com/meefik/linuxdeploy/releases
#拿到root权限后配置linux，镜像文件方式可能不行，mount的时候mount失败，选用目录就可以装上了。
#特权用户用root。装ubuntu可以用http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/

#dash 和 bash   ubuntu 默认的sh 为 dash，有的时候不好用，改为bash启动会慢一点，但好用
sudo ln -fs /bin/bash /bin/sh


#给其他机器作代理
sudo aptitude install squid squid-common
sudo vi /etc/squid/squid.conf
设置允许的网站
acl pc88_network src 192.168.1.0/24
http_access allow pc88_network
sudo chown -R proxy:proxy /var/log/squid/
sudo chown proxy:proxy /etc/squid/squid.conf
需要重启生效
sudo /etc/init.d/squid restart
现在打开网页浏览器，设置代理服务器为新的squid服务器，端口为3128

#给其他机器作代理
apt install tinyproxy
vim /etc/tinyproxy/tinyproxy.conf
#改port 38888 和allow 10.1.1.0/24

#apt 使用代理 
sudo vim /etc/apt/apt.conf.d/10proxy   #这个文件正常不存在，会新建一个
#编辑内容为：
Acquire::http::Proxy "http://pt:38888";
#临时使用
apt update -o Acquire::https::Proxy="http://127.0.0.1:58591"
#trojan-qt5的代理
export HTTP_PROXY=http://127.0.0.1:58591; 
export HTTPS_PROXY=http://127.0.0.1:58591; 
export ALL_PROXY=socks5://127.0.0.1:51837

#git 设置代理 
git config --global http.proxy 'http://10.1.1.126:1080'
git config --global https.proxy 'http://10.1.1.126:1080'

git config --global http.proxy 'socks5://127.0.0.1:51837'
git config --global https.proxy 'socks5://127.0.0.1:51837'

git config --global http.https://github.com.proxy 'socks5://127.0.0.1:51837'
git config --global https.https://github.com.proxy 'socks5://127.0.0.1:51837'


# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy

#git 断点 先建一个远程点，用depth下载
git remote add wow https://github.com/TrinityCore/TrinityCore.git
git fetch --depth=1 wow 3.3.5

#hdfs-mount安装， 先装golang 和 fuse
git clone https://github.com/microsoft/hdfs-mount.git  --recursive
#go 设置代理 1.10 使用系统代理 
export http_proxy="socks5://127.0.0.1:4080"
export https_proxy="socks5://127.0.0.1:4080"
#go 1.13使用自己的代理，具体方法 不知道 ，可能是下面这两种
go env -w GOPROXY=socks5://127.0.0.1:4080
export GOPROXY=socks5://127.0.0.1:4080
#编译
make
#挂的时候hadoop这边不能带目录，直通直接挂到端口
sudo ./hdfs-mount pc33:8020 /p33
#hdfs没有权限，在pc33上授权
sudo -u hdfs hadoop fs -chmod 777 /

#win7 windows7 免登录
control userpasswords2
powercfg-h off


#aria2 使用
apt install uget aria2
vim /opt/aria.conf #上网查一下配置
#启动服务 -D
sudo aria2c --conf-path=/opt/aria.conf
aria2c -c -s 3 -d /savedir -i /listdownloadfiles
#下载sdc
aria2c -c -s 5 -d /media/yangyong/d4y/soft/streamsets/tar_3.15.0/ --all-proxy=socks5://localhost:4080 https://archives.streamsets.com/datacollector/3.15.0/tarball/activation/streamsets-datacollector-all-3.15.0.tgz


https://github.com/opengapps/x86_64/releases/download/20190816/open_gapps-x86_64-7.1-mini-20190816.zip
http://dl.android-x86.org/houdini/7_y/houdini.sfs
http://dl.android-x86.org/houdini/7_z/houdini.sfs

#debain 9 的代码是stretch

#win10 安装 linux
设置中开启 开发人员选项
在软件与程序--windows功能中，勾选linux子系统
运行以下安装程序
lxrun /install /y

#sql server 2017 sqlserver 1433端口无法连接 无法远程连接 
配置管理器 -- sql server 网络配置 -- 启用tcp/ip协议

#sqlserver的timestamp时间不能插入数据，是自动生成数据的，要插入数据使用datetime

#pg postgresql 给用户加权限
ALTER ROLE test_user_3 WITH LOGIN;
alter user dc with replication;
#改密码
alter user postgres with password 'new password';
#查看和删除slot 在pg里运行
SELECT * FROM pg_replication_slots ;
select pg_drop_replication_slot('sdc5');

-----------------------kettle----------------
kettle连接资料库的时候报错
一个未预期的错误发生在Spoon: probable cause:在停止Spoon前，请先关闭其它spoon窗口! 
No more handles [MOZILLA_FIVE_HOME=''] (java.lang.UnsatisfiedLinkError: Could not load SWT library. Reasons: 
	no swt-mozilla-gtk-4335 in java.library.path
	no swt-mozilla-gtk in java.library.path

#把SWT_GTK3=0改为1  Fix GTK 3 issues with SWT
export SWT_GTK3=1

--以下的不好使
需要安装firefox和插件 xulrunner，下载xulrunner，安装
http://ftp.mozilla.org/pub/xulrunner/releases/latest/runtimes/
http://ftp.mozilla.org/pub/xulrunner/releases/latest/sdk/
tar -jxf xulrunner-41.0.2.en-US.linux-x86_64.sdk.tar.bz2
sudo ./xulrunner  -app /usr/lib/firefox/application.ini 
----但是仍然安不上，因为firefox版本太新了，还是用win10吧。
可以用kettle8.3，这个可以在linux上运行。
要安装gtk的显示模块sudo apt install  libwebkitgtk-dev

#kettle请求post时发送内容，配置一个常量 用第一个 Content-Type ， 值用application/x-www-form-urlencoded
application/x-www-form-urlencoded：窗体数据被编码为名称/值对。这是标准的编码格式。这是默认的方式
multipart/form-data：窗体数据被编码为一条消息，页上的每个控件对应消息中的一个部分。二进制数据传输方式，主要用于上传文件
text/plain：窗体数据以纯文本形式进行编码，其中不含任何控件或格式字符。

----------------conda----python---anaconda---------
--新建一个环境
conda create --name multinerf python=3.9
conda activate multinerf
conda install pip
pip install --upgrade pip
pip install -r requirements.txt


---------------------arm 的----------------------
#看硬件信息 dmidecode可能不好用
apt install lshw 

#目前发现部分服务通过service不能启动，直接从init.d下可以启动
#包括 samba redis apache2 
/etc/init.d/smbd start
/etc/init.d/redis-server start
/etc/init.d/apache2 start



---------------------mac 的----------------------
#安装Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#安装其他的
brew install nodejs 
npm -g install bower 
npm -g install grunt-cli 
brew install md5sha1sum

#mac os 的ln问题，据说系统更新后不能往/usr/bin下加连接了，要加在/usr/local/bin下才行
ln: /usr/bin/go: Operation not permitted

#打开非用户的文件夹 用open
open /bin/


-----------flatpak-------------------
sudo apt install flatpak
sudo add-apt-repository ppa:flatpak/stable
sudo apt update
sudo apt install flatpak

#设置源
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#查看
flatpak remote-ls flathub | grep nvidia
#看附加驱动中的版本
apt-cache policy nvidia-driver-396
#找到installed中的小版本号
flatpak -y install flathub org.freedesktop.Platform.GL32.nvidia-396-54
flatpak -y install flathub org.freedesktop.Platform.GL.nvidia-396-54

#设置国内源
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
如果出现错误可尝试：
wget https://mirror.sjtu.edu.cn/flathub/flathub.gpg
sudo flatpak remote-modify --gpg-import=flathub.gpg flathub

#如果上边的不行，就 rm -rf /var/lib/flatpak/repo  然后再用下边的
flatpak remote-add flathub https://mirror.sjtu.edu.cn/flathub/?mirror_intel_list --no-gpg-verify


#会进入沙箱环境的shell。然后在这个shell里设置系统代理：
flatpak run --command=sh 包名
# 系统代理模式设置为手动
gsettings set org.gnome.system.proxy mode manual
# 设置 HTTP 代理
gsettings set org.gnome.system.proxy.http host localhost
gsettings set org.gnome.system.proxy.http port 端口号
# 设置 HTTPS 代理
gsettings set org.gnome.system.proxy.https host localhost
gsettings set org.gnome.system.proxy.https port 端口号
# 设置 Socks 代理
gsettings set org.gnome.system.proxy.socks host localhost
gsettings set org.gnome.system.proxy.socks port 端口号


----------postgresql pg pg_xlog 减少 --------------
su postgres
pg_ctl stop -m fast
pg_controldata
---看
Latest checkpoint's NextXID:          0:111001
Latest checkpoint's NextOID:          25250

pg_resetxlog -o 25250 -x 111001 -f /var/lib/pgsql/9.6/data
pg_ctl start

#使用sudo apt-get install gparted 来调整分区大小。
#新建gpt分区使用parted
parted /dev/sdb  mklabel gpt
parted /dev/sdb  mkpart primary 0% 100%
mkfs.ext4  /dev/sdb1

#eclipse 反编译文件，在market中查 Decompileer
Eclipse Class Decompileer

#ubuntu 18.04 默认不允许root远程登录，要修改权限
#sudo vi /etc/ssh/sshd_config
PermitRootLogin yes （默认为#PermitRootLogin prohibit-password）

#　每50秒给SSH服务器发送请求，防止中断
ServerAliveInterval 50
#　错误次数最大3次
ServerAliveCountMax 3
#重启ssh
sudo systemctl restart sshd


#安装r语言
conda install r-essentials --yes
conda install -c r rstudio --yes


#parallel 多线程操作转换图片
----------- 从 PNG 转换到 JPG -----------
$ parallel convert '{}' '{.}.jpg' ::: *.png
----------- 从 JPG 转换到 PNG -----------
$ parallel convert '{}' '{.}.png' ::: *.jpg


#安装宝塔监控
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh

#删除不用的内核 
dpkg --get-selections|grep linux
apt-get remove linux-image-
apt-get removelinux-headers-

#删除没安装的内核
sudo dpkg --get-selections | grep deinstall | sed 's/deinstall/\lpurge/' | sudo dpkg --set-selections; sudo dpkg -Pa
dpkg --get-selections | grep deinstall | sed 's/deinstall/\lpurge/' | dpkg --set-selections; dpkg -Pa

#查看开机用时
sudo systemd-analyze
#查看具体程序
sudo systemd-analyze blame
#禁用启动项
sudo systemctl mask plymouth-quit-wait.service
#取消禁用项
sudo systemctl unmask plymouth-quit-wait.service



#安装xx-net， 先安一个虚拟ipv6的 teredo
sudo apt-get install miredo
#启动 miredo
sudo miredo
#看这个https://github.com/XX-net/XX-Net/wiki/how-to-create-my-appids，去google上建个账号 
https://console.cloud.google.com/start 

#google earth 
wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb

#安装rabbitmq 
docker pull rabbitmq:3.8.2
docker run -d --hostname my-rabbit --name some-rabbit rabbitmq:3.8.2


#资源管理器不好用
snap remove gnome-system-monitor
apt install gnome-system-monitor

#gnome-control-center 东西少
install unity-control-center


#安装图形相关软件时的报错
错误：X11/Xlib.h：没有那个文件或目录
　　错误：X11/Xutil.h：没有那个文件或目录
　　错误：X11/Xos.h：没有那个文件或目录
　　错误：X11/Xatom.h：没有那个文件或目录
　　错误：X11/keysym.h：没有那个文件或目录
　　修正的方法：
　　$ sudo apt-get install libx11-dev 

　　错误： X11/xpm.h：没有该文件或目录
　　修正的方法：
　　$ sudo apt-get install libxpm-dev

sudo apt install libgl1-mesa-dev



#看dns ip 等信息
nmcli dev show

#centos 找不到host命令
yum install bind-utils
#ubuntu 找不到host dig命令
apt install dnsutils


#安装 uos
1、sudo nano /etc/apt/sources.list    deb [by-hash=force] http://uos-packages.deepin.com/uos eagle main contrib non-free    (注意将其他源用“#”注释)
2、sudo apt update
3、sudo apt full-upgrade
4、升级过程有版本更换提示，需要手动选择更换与否，不懂玩的一路y
5、reboot

#sudo慢 
在::1 和 127.0.0.1 最后都加上你的主机名就OK了

#看系统的错误日志
journalctl -xe

#看硬盘信息
cat /sys/block/sda/device/model
sudo hdparm -I /dev/sda

#sudo: /usr/bin/sudo 必须属于用户 ID 0(的用户)并且设置 setuid 位 第一位是对应三个权限421的可执行权限
chmod 4755 /usr/bin/sudo

#tomcat显示更多的内容
JAVA_OPTS="$JAVA_OPTS -XX:+TraceClassLoading"

#redhat 设置固定ip， em1是网卡名
vim /etc/sysconfig/network-scripts/ifcfg-em1
#改成静态
BOOTPROTO=static
#增加ip配置
IPADDR=10.1.1.76
NETMASK=255.255.255.192
GATEWAY=10.1.1.65
DNS1=219.141.140.10


#ubuntu 设置固定ip 注意 eno1是网卡名，要对应
vim /etc/netplan/50-cloud-init.yaml
network:
    ethernets:
        eno1(网卡名):
            addresses:
                - 10.1.1.114/26 # IP及掩码
            gateway4: 10.1.1.65 # 网关
            nameservers:
                addresses:  [114.114.114.114,219.141.140.10]                   
    version: 2


sudo netplan apply
ip addr list
#看dns
systemd-resolve --status

#nslookup
nslookup www.baidu.com

#ubuntu 重启网络 这个好用
sudo netplan apply

#重启网络
sudo service network-manager restart

#看网关
route -n
netstat -r

#看网络使用 网络流量
iftop
nethogs

#ubuntu防火墙
ufw status 
ufw allow from 172.16.14.0/24 to 172.16.14.190 port 9100

#有时候iptables还需要配置
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
#保存配置
iptables-save


#相关操作
iptables -L -n --line-number  
iptables -R INPUT 3 -j DROP    //将规则3改成DROP  
iptables -F  ufw-before-input  //ufw-before-input 是chain的名称
iptables -D INPUT 3  //删除input的第3条规则  
iptables -t nat -D POSTROUTING 1  //删除nat表中postrouting的第一条规则  
iptables -F INPUT   //清空 filter表INPUT所有规则  
iptables -F    //清空所有规则  
iptables -t nat -F POSTROUTING   //清空nat表POSTROUTING所有规则  



#redhat关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service




#安装gimage
sudo add-apt-repository ppa:sandromani/gimagereader
sudo apt-get update
sudo apt-get install gimagereader tesseract-ocr tesseract-ocr-eng
卸载 gimagereader 命令：
sudo apt-get remove gimagereader

#maven更新依赖包
mvn -f pom.xml dependency:copy-dependencies  

#jdk中没有jre，eclipse显示jdk不对
cd jdk13
bin\jlink --module-path jmods --add-modules java.desktop --output jre

#dotnet下载地址 
https://dotnet.microsoft.com/zh-cn/download/visual-studio-sdks?cid=msbuild-developerpacks

#安装.net
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get update
#sdk
sudo apt-get install dotnet-sdk-3.1
#asp runtime
sudo apt-get install aspnetcore-runtime-3.1
#.net runtime
sudo apt-get install dotnet-runtime-3.1

#unetbootin安装
sudo add-apt-repository ppa:gezakovacs/ppa
sudo apt-get update
sudo apt-get install unetbootin

#无法连接到web服务器 iis express  因为调整过网络，导致了无法启动	
关闭项目以及vs，然后把解决方案根目录下面的隐藏文件 .vs 文件夹给干掉
重新以管理员身份运行vs2017并运行项目。
删除Docement/IIS Express文件夹里面的全部内容。
卸载IIS Express重新安装
卸载vs2017进行安装（这个我没试，当我傻嘛，这个太耗时间，耗不起）


#关闭apport 
sudo sh -c 'echo "enabled=0" > /etc/default/apport'

#ubuntu 安装增强插件 vmware tools 解压那个tar包，安装里面的文件 ,也可以直接在软件商店里装
apt install open-vm-tools

#openvpn 安装
apt-get install -y openvpn network-manager-openvpn network-manager-openvpn-gnome

#驱动 
ubuntu-drivers devices
sudo ubuntu-drivers autoinstall

#未知的display 双屏 驱动
rm -rf ~/.config/monitors.xml


export HTTP_PROXY=http://127.0.0.1:58591; export HTTPS_PROXY=http://127.0.0.1:58591; export ALL_PROXY=socks5://127.0.0.1:51837

#自动修复缺少的包用 -f 
# bash: add-apt-repository: command not found
apt-get install software-properties-common

#修复坏道
badblocks -s -v -n -f /dev/sdb

#新打开的maven工程报错，找不到类 找不到jar包 右击 Maven project --> Macven --> update project

#u20的sshd 用systemctl 启动不了
/etc/init.d/ssh start
#u20的桌面安装 
apt install ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

#ssh -X cannot open display
#本地改
/etc/ssh/sshd_config中，添加 X11Forwarding yes
#服务器端改
ForwardX11Trusted yes


#使用华为的源仓库
sed -i "s@http://.*archive.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list
sed -i "s@http://.*security.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list


#centos7
sed -i "s/#baseurl/baseurl/g" /etc/yum.repos.d/CentOS-Base.repo
sed -i "s/mirrorlist=http/#mirrorlist=http/g" /etc/yum.repos.d/CentOS-Base.repo
sed -i "s@http://mirror.centos.org@https://mirrors.huaweicloud.com@g" /etc/yum.repos.d/CentOS-Base.repo

#md5
echo -n '2020McDgTZZ3tu401ICmRqFjXZY81rXwXX7EJrT5YD19'|md5sum|cut -d ' ' -f 1
销售系统
SignUtils.md5(appId + appConfig.getKey() + requestTime).equals(sign)
yyyyMMddHHmmssSSS

echo -n 'bic1zT7NSDgV9UDjExmuUHX7IzW48nz2ES20210511165000123'|md5sum|cut -d ' ' -f 1

wget -d --header="x-app-id:bi" --header="x-time:20210511172000123" --header="x-sign:6882eef602b5c5f3b005e8915e268080" http://10.1.1.75:8086/api/marketing/media/download?key=mid372162-0.41324207649167743

date +bic1zT7NSDgV9UDjExmuUHX7IzW48nz2ES%Y%m%d%H%M00000 |md5sum|cut -d ' ' -f 1


#美团任务时间 
0 */5 8,9,10,11,14,15,16,17 * * ?
0 30,35,40,45,50,55 13 * * ?

#bi03
support bi-suppport-api 58000


#base64 编码
cat yy.log | base64 | base64 -d

#win10 不能上网 关闭ipv6 
netsh interface teredo set state disable
netsh interface 6to4 set state disabled
netsh interface isatap set state disabled
3、如果想要还原ipv6隧道则用以下命令:
netsh interface teredo set state default
netsh interface 6to4 set state default
netsh interface isatap set state default

#看执行计划
explain (analyze,timing,costs,buffers)

# swagger生成 api doc 
http://pc33:18080/api/swagger.json


#本地无密码使用psql shell使用sql 连接数据库
vim ~/.pgpass
ip:port:db:username:pw
chmod 600 ~/.pgpass
psql -h localhost -p 15432 -U dc -d dc -c 'select now()' -t -w

psql -h 10.1.1.82 -d dc -p 58000 -U yangyong -t -w -f dl.sql -v maxslid=$MAXSLID | sh
psql -h 10.1.1.82 -d dc -p 58000 -U yangyong -t -w -f dl.sql `cat aa.t` | sh


#git 设置 
git config --global user.name "杨勇"
git config --global user.email "837493225@qq.com"
#git 推送新项目 
cd existing_repo
git remote rename origin old-origin
git remote add origin http://47.98.101.215:81/sales/marketing.git
git push -u origin --all
git push -u origin --tags

#git clone不下来
step1：打开控制面板，找到“凭据管理器”（记得把查看方式改成大/小图标）；
step2：点击进入凭据管理器后，切到“Windows凭据下”，你看到这些信息就是保存在计算机中的账号密码；
step3：在信息中找到你需要修改的仓库地址（比如我需要修改的是git:http://git.dmbcdn.com的账号密码），点击编辑，把账号密码改成正确的就OK了；

#git 免密码 记住密码
git config --global credential.helper store
#取消 
git config --global --unset credential.helper
#git ssh 免密码 加入ssh key以后
git clone ssh://git@10.111.114.92:38522/bi/bi-support-api.git

#git的gui 界面 工具
sudo apt install git-cola
sudo apt install gitg
smartgit  https://www.syntevo.com/smartgit/download/#installation-instructions


#ansible 批量管理工具 
pip install ansible

#16位处理工具 二进制
https://github.com/WerWolv/ImHex/releases/tag/v1.27.0
imhex-1.27.0-x86_64.AppImage


#设置了https的git源之后报错 git报错
#SSL certificate problem: certificate has expired 
git config --global http.sslVerify false

#查看哪个进程写磁盘 dmesg
echo 1 > /proc/sys/vm/block_dump 
echo 1 > /sys/kernel/debug/tracing/events/jbd2/jbd2_commit_flushing/enable
echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable

cat /sys/kernel/debug/tracing/trace_pipe


#看局域网的机器名 得用root运行 好像只能找windows的
apt install samba-common-bin arp-scan
python3 bin/scanip.py

#linux共享文件
apt install samba
vim /etc/samba/smb.conf
#在最后加上共享配置
[share]
    path = /samba
    browseable = yes
    writable = yes
    read = yes
    public = yes
    available = yes

#建目录
mkdir /samba
chmod 777 /samba
#建共享用户 这个要是这个电脑上的用户，会单独设置用于共享的密码
smbpasswd -a yangyong
#重启服务 
service nmbd restart

#gnome 中键复制关闭
#使用tweaks 来关 gnome-tweaks 
#有时候tweaks 不好用，就用下边的
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
#打开
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true

#linux的屏幕方向
sudo xrandr -o left
-o inverted
-o normal

#datagrip 时间问题，now() 得不到当前时间， 有连接的advanced 的 vm.options 中加入时区
-Duser.timezone=Asia/Shanghai 

# svn git 安装 
apt install subversion rabbitvcs-cli rabbitvcs-core rabbitvcs-gedit rabbitvcs-nautilus

#svn 命令 ignore哪个文件夹下的内容 
export SVN_EDITOR=vim
svn propedit svn:ignore .
svn propedit svn:ignore /product
svn ci
svn update

gsettings set org.gnome.settings-daemon.plugins.orientation active false


#dotnet 
dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection --version 6.0.0

#dotnet中的注解 注释 .net column 表
NotMapped
ResultColumn

#安装deepin 商店， qq 微信
git clone https://gitee.com/wszqkzqk/deepin-wine-for-ubuntu.git
install.sh
sudo gedit /etc/sysctl.conf
#IPv6 disabled
net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1
sudo sysctl -p
ipconfig

#qq安装包
https://packages.deepin.com/deepin/pool/non-free/d/deepin.com.qq.im/deepin.com.qq.im_9.1.8deepin0_i386.deb
[TIM]：https://packages.deepin.com/deepin/pool/non-free/d/deepin.com.qq.office/deepin.com.qq.office_2.0.0deepin4_i386.deb
[企业微信]：https://packages.deepin.com/deepin/pool/non-free/d/deepin.com.weixin.work/deepin.com.weixin.work_2.8.10.2010deepin0_i386.deb


#ubuntu 18.04
sudo vi /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"
GRUB_CMDLINE_LINUX="ipv6.disable=1"
sudo update-grub
sudo reboot


#x11docker 安装deepin
从网站下载x11docker安装文件，把x11docker 和 x11docker-gui考到/usr/bin下
https://gitee.com/mirrors/x11docker?_from=gitee_search#https://github.com/mviereck/kaptain

#安装
dpkg -i /work/tmp/kaptain_0.73-1_amd64_ubuntu.deb
apt install -f 
#建一个deepin容器
x11docker --build x11docker/deepin
#运行
x11docker --desktop --init=systemd -- --cap-add=IPC_LOCK -- x11docker/deepin
#单独运行某一个程序
x11docker x11docker/deepin deepin-terminal

#1）只保留近一周的日志
journalctl --vacuum-time=1w
#2）只保留500MB的日志
journalctl  --vacuum-size=500M

##文件名替换空格，将空格替换成_
rename 's/ /_/g' * 
#直接去掉空格
for ff in * ; do mv "$ff" `echo $ff | tr " " "_" ` ; done  



#git 提交报错 CRLF LF 
git config --global core.autocrlf false


#恢复数据 testdisk 

#连接和控制手机
sudo snap install scrcpy
sudo apt install SDL2 android-tools-adb

#手机连电脑 显示屏幕 平板
VirtScreen
Deskreen

#多台电脑共用鼠标
synergy

# snap安装太慢，使用代理
# 前置操作, 修改  systemctl edit 使用的编辑器为 VIM, 如果不介意 Nano 可以跳过这一步
$ sudo tee -a /etc/profile <<-'EOF' 
export SYSTEMD_EDITOR="/bin/vim"
EOF
$ source /etc/profile

# 开始设置代理
$ sudo systemctl edit snapd
加上：
[Service]
Environment="http_proxy=http://127.0.0.1:58591"
Environment="https_proxy=http://127.0.0.1:58591"

#保存退出。
$ sudo systemctl daemon-reload
$ sudo systemctl restart snapd



#安装undistract-me 来进行提示较长时间的shell脚本运行完成


#win7 关闭休眠 hibernate 管理员运行cmd
powercfg -h off 


#多功能安装盘
Ventoy 



#wine winehq  以下的安装方法都不好使，还没有成功过
// 安装Official Wine仓库
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
// 安装存储库
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
// 更新程序包缓存
sudo apt update
// 安装Wine 6
sudo apt install --install-recommends winehq-stable
// 验证Wine安装
wine --version
// 最后重启系统

  env LANG=zh_CN.UTF-8 wine example.exe


#直接使用wine安装 
SECUR32_initNTLMSP ntlm_auth was not found or is outdated.
apt install winbind
用winetricks 安装字体 
#字体没有，以上方法不好使 把windows Fonts下的字体考到~/.wine/driver_c/windows/Fonts下 
~/.wine/system.reg：将[Software//Microsoft//Windows NT//CurrentVersion//FontSubstitutes] 中的： “MS Shell Dlg”=”Tahoma”“MS Shell Dlg 2″=”Tahoma”改为： “MS Shell Dlg”=”SimSun”“MS Shell Dlg 2″=”SimSun”



#114.55.5.30
/data/etldata/script/ods_t0cdc_logs


 <!-- 使用去掉下划线的映射规则-->
         <setting name="mapUnderscoreToCamelCase" value="true"/>


#安装deb时直接带依赖安装
apt install gdebi

#man 显示中文 
sudo apt update
sudo apt install manpages-zh




#分隔符
\u2510
比如‘\u0001’的十六进制是01，就用$[01]来表示：




--表使用空间查询
SELECT
  pg_size_pretty(sum(pg_indexes_size(a.table_schema || '.' || a.table_name))),
  pg_size_pretty(sum(pg_table_size(a.table_schema || '.' || a.table_name)))
FROM information_schema.tables a
WHERE
  a.table_name ~ 'd_zxxk_cl_consumelog';

#photoshop cc6 破解
cs6pjbd1.0.zip 解压放在ps主目录
http://xiazai.zol.com.cn/detail/45/440347.shtml

#zip 解压出乱码，用 unar 解压就可以了
#zip 加密  文件夹的话要带 -r
zip -P mima 目标 文件

#下载包，解压编译,会占用比较大的空间， 4.19用了16G
sudo apt install bison flex libncurses-dev

cd /usr/src/linux-4.X
make O=/home/name/build/kernel menuconfig
make O=/home/name/build/kernel
sudo make O=/home/name/build/kernel modules_install install

#springboot 的注入要注意scope
@Aspect
@Scope("prototype")  session request 


#图片转pdf 不写输出就输出到命令行上了 不能用-C L 会有问题
img2pdf -o aa.pdf -S A4 图片.jpg
img2pdf -o aa.pdf  -s a4 --pagesize A4 --fit shrink 1701013999.jpg 1201360605.jpg 1790303907.jpg

#pdf 
pdfarranger


#postgres 改
ALTER SEQUENCE public.c_cfg_rt_glob_logg_log_id_seq
	RESTART 17310850;

#改root密码
Linux 引导项，然后按 e 键,输入 single ，然后按 b 键启动，即可直接进入Linux单用户模式
#Ubuntu进入单用户模式，开机后长按“shift”，可以看到Ubuntu的“Recovery”选项，选中该选项（请勿“Enter”），此时按键盘的“e”键即可进入Esmsc编辑界面（下面会有提示操作的），将倒数第3或第4行（linux开头的）“ro”及后面的内容修改为“rw single init=/bin/bash”，接着按“ctrl+x”或“F10”即可进入单用户模式。另外，退出只能通过“Ctrl+Alt+Delete”键实现（VMware也一样），无法通过命令（如“quit”、“exit”、“reboot”等）完成。

#Failed to load module "canberra-gtk-module"
locate libcanberra-gtk-module.so
ln -s /usr/lib/x86_64-linux-gnu/gtk-3.0/modules/libcanberra-gtk-module.so /usr/lib/libcanberra-gtk-module.so


#加密 tar加密
tar -zcf - filenames | openssl des3 -salt -k pass | dd of=.his
dd if=.his | openssl des3 -d -k pass| tar zxf -


#mail.sina.com 新浪邮箱 9fa469051441d616

#看ubuntu linux 版本
cat /etc/lsb-release 

#安装playonlinux
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget http://deb.playonlinux.com/playonlinux_bionic.list -O /etc/apt/sources.list.d/playonlinux.list
sudo apt-get update
sudo apt-get install playonlinux



#datagrip 连接 sqlserver ca 认证 ，把驱动版本降下来就可以了

#ModuleNotFoundError: No module named 'lsb_release'
看一下/usr/bin/lsb_release 使用的python3是哪个
要用系统的才行。
vim /usr/bin/lsb_release 
#!/usr/bin/python3 -Es   -- 改成 #!/usr/bin/python3.6 -Es

#amr转mp3  使用sox:
sudo apt-get install lame  sox  libsox-fmt-mp3
#使用如下命令转换：
sox test.amr test.mp3
#查看信息
sox test.mp3 -n stat  
#转频率 
sox test.mp3 -r 16000 test.wav
#截取 从10秒处截20秒长的音频 -10从尾部截
sox test.mp3 -r 16000 target.wav trim 10 20


#pg重启
pg_ctl -d $path -l logpath stop -m fast
pg_ctl -d $path -l logpath start

#82数据库有问题就卸载/data04 再挂一遍

#批量杀进程  grep -v grep 不要执行grep自己这句
ps -ef | grep python | grep -v grep | awk '{print $2}'  | xargs kill

#杀当前进程
kill -9 $$

#查不包含，不包括
grep -v

#报错是不能用-v去除的，把报错输出到/dev/null就行了
f aa 2>/dev/null 

#l310 安装驱动
apt install printer-driver-gutenprint printer-driver-escpr escputil

#检查喷嘴 打印喷嘴测试图 默认打印机
escputil --nozzle-check --new 
#清洗打印头 默认打印机
escputil --clean-head --new 
#检查喷嘴  打印喷嘴测试图 指定打印机 打印机名称到 /etc/cups/printers.conf 找
escputil --nozzle-check --new --printer-name Epson_Stylus_Photo_R330
#清洗打印头  指定打印机 打印机名称到 /etc/cups/printers.conf 找
escputil --clean-head --new --printer-name Epson_Stylus_Photo_R330


#打印机的配置 在 /etc/cups/ppd 和 /usr/share/cups/model 下
*PageSize 4x6/4x6:	"<</PageSize[288 432]/ImagingBBox null>>setpagedevice"
*PageRegion 4x6/4x6:	"<</PageSize[288 432]/ImagingBBox null>>setpagedevice"

#cups的配置 监听端口要配置成ip，用机器名访问不了会报 无效请求
vim /etc/cups/cupsd.conf
Listen 172.16.14.135:631
Browsing On
#在需要访问的地方要加上允许的ip , admin下要加密码不加密??? 访问时也要用ip访问
<Location />
  Order allow,deny
  Allow 172.16.14.0/24
</Location>

<Location /admin>
  Order allow,deny
  Allow 172.16.14.190
  Encryption Never
</Location>

#添加打印机可以使用页面或 使用lpadmin lpstat

--看是否4k对齐
sudo parted
align-check opt n



#查看占用 umount时占用 device busy
fuser /home/yangyong/work



#android 用 linux 
aidlux
ssh root@ip -p 9022 
mima aidlux












------------------------------------不要乱装这个，用虚拟机可以尝试安装，不要用实体机装---------------------------

#libvulkan.so.1: cannot open shared object file: No such file or directory
apt install libvulkan1:amd64

#更新make 下4.3，   4.2 config的时候就过不去
http://ftp.gnu.org/gnu/make/
./configure --prefix=/opt/make43
. build.sh
# !!!!  千万不要执行这句，坑死人，不能删除make，删除后下边运行不了，而且用make安装的都会被删除 !!!!! sudo apt-get remove make
make install
sudo cp make /usr/bin/make

#GLIBC_2.29
#使用这个语句查看 strings /lib/x86_64-linux-gnu/libm.so.6 | grep GLIBC_
cd /usr/local
wget http://ftp.gnu.org/gnu/glibc/glibc-2.29.tar.gz
tar -zxf glibc-2.29.tar.gz
cd glibc-2.29
mkdir build
cd build/
sudo apt-get install gawk bison -y
../configure --prefix=/usr/local --disable-sanity-checks
make -j18
make install
cd /lib/x86_64-linux-gnu
ll

-------------------------------------------------------------------------------------------------------------------





---开接口权限

基础应用-杨福山  16:17:17
收件人: yangfushan@xkw.cn, liujibin@xkw.cn
, Provider管理员
抄送: litiekui@xkw.cn, wangwei01@xkw.cn, yuwenguang@xkw.cn

邮件标题：申请开通BAPI-Provier接口权限

邮件内容：

应用名称：
应用是否开通：是/否
申请原因：需要Provider的某些能力

申请开通接口列表：
MDM服务：
    /areas
    /areas/{id}
    ...
QBM服务：
    /resources
    /resources/{id}

基础应用-杨福山  16:17:34
加上抄送一下你们直属领导


