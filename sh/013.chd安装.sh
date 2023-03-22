#新建docker虚拟机
docker run --name cdh1 -h cdh1 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name cdh2 -h cdh2 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name cdh3 -h cdh3 --privileged=true -itd centos:7.6.1810 /usr/sbin/init

#配置使用本地的仓库repo
yum -y install wget
cd /etc/yum.repos.d/
rm -f *
wget http://10.1.1.87/yumrepo/pc88.repo
yum clean all
yum makecache

#在docker下的话，需要给root设置密码。几台机器的密码要设置一样。
passwd root
#在docker下安装的话，修改一下ping文件的权限，如果不改的话，只有root可以用ping，安装过程中会认为网络不通。
chmod 4755 /bin/ping
#在docker下的话，要安装ntp和文支持
yum -y install ntp
rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #修改时区
yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common #安装中文支持
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8



#看一下有没有默认已经安装了的jdk，有的话remove掉
yum list installed | grep jdk
yum remove jdk名字

#开始安装
yum -y install wget net-tools httpd vim openssh-server openssh-clients 
cd /etc/yum.repos.d/
rpm --import http://10.1.1.87/yumrepo/RPM-GPG-KEY-cloudera
yum -y install oracle-j2sdk1.8

#试一下如果java不能用则建一个连接，不知道为什么有时候装完不能用。
java -version
#如果不行，则将java写入path
echo 'export JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera' >> /etc/profile
echo 'export PATH=/usr/java/jdk1.8.0_181-cloudera/bin:$PATH' >> /etc/profile
echo 'export HADOOP_USER_NAME=hdfs' >> /etc/profile
echo 'export LANG=zh_CN.UTF-8' >> /etc/profile


#如果是装在docker中，不是使用ssh root登录的，还需要把这些配置放在.bashrc中，登录后执行一下 . .bashrc
echo 'export JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera' >> /root/.bashrc
echo 'export PATH=/usr/java/jdk1.8.0_181-cloudera/bin:$PATH' >> /root/.bashrc
echo 'export HADOOP_USER_NAME=hdfs' >> /root/.bashrc
echo 'export LANG=zh_CN.UTF-8' >> /root/.bashrc




#禁用透明页
chmod +x /etc/rc.d/rc.local
echo 'echo never > /sys/kernel/mm/transparent_hugepage/defrag' >> /etc/rc.local
echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local

#修改使用swap的设置，值要尽量小于10 ,似乎用不着，安装的过程中cdh自动进行设置了。
echo 10 > /proc/sys/vm/swappiness
echo 'vm.swappiness=10' >> /etc/sysctl.conf
##################

#设置 ntp 
vim /etc/ntp.conf
server 10.1.1.97
restrict 10.1.1.97 nomodify notrap noquery
server 127.0.0.1 # local clock
fudge 127.0.0.1 stratum 10

#再把其他的server 注释掉
systemctl start ntpd

#配置/etc/hosts
vim /etc/hosts

#不要相信网上说的分别安装daemons 和agent，安装之后主机有一定机率认为有agent的机器已经加入一个集群了 cloudera-manager-daemons cloudera-manager-agent
#！！！只在主节点安装server 
yum -y install  cloudera-manager-server

#wget https://archive.cloudera.com/cm6/6.2.0/redhat7/yum/cloudera-manager.repo
#rpm --import https://archive.cloudera.com/cm6/6.2.0/redhat7/yum/RPM-GPG-KEY-cloudera
#设置无密码登录 ssh-keygen 



#新建一个用于存放数据的文件夹，注意实体机要对应实际硬盘来配置，比如有6块硬盘用于存储数据，则可以挂在/data/1 /data/2 /data/3 这样的目录上。
!!!!只能建最上层的目录，不能把具体的datanode目录建出来，否则会hadoop会出现无法退出safemode的问题。
mkdir -p /data/1
#如果是实体机，修改vim /etc/fstab 文件，增加硬盘的挂载。
chmod -R 777 /data


#从主机登录一下其他机器，保证know_hosts中有其他机器的信息
ssh cdh1
ssh cdh2
ssh cdh3

#!!!只在主机上设置，如果这个文件夹不存在，就新建一个 mkdir -p /opt/cloudera/parcel-repo
scp yangyong@10.1.1.87:/work/soft/yumrepo/pa/* /opt/cloudera/parcel-repo/

chmod 777 /opt/cloudera/parcel-repo/
chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/*
mv /opt/cloudera/parcel-repo/CDH-6.2.0-1.cdh6.2.0.p0.967373-el7.parcel.sha1 /opt/cloudera/parcel-repo/CDH-6.2.0-1.cdh6.2.0.p0.967373-el7.parcel.sha

#!!!在数据库那台机器上安装
sudo yum install python-pip
sudo pip install psycopg2==2.7.5 --ignore-installed

CREATE user scm LOGIN PASSWORD 'scm';
CREATE DATABASE scm OWNER scm ENCODING 'UTF8';

CREATE user hive LOGIN PASSWORD 'hive';
CREATE DATABASE metastore OWNER hive ENCODING 'UTF8';

CREATE user oozie LOGIN PASSWORD 'oozie';
CREATE DATABASE oozie OWNER oozie ENCODING 'UTF8';

CREATE user hue LOGIN PASSWORD 'hue';
CREATE DATABASE hue OWNER hue ENCODING 'UTF8';

###########出错时重装前需要先清数据库############
drop database scm;
drop database metastore;
drop database oozie;
drop database hue;
CREATE DATABASE scm OWNER scm ENCODING 'UTF8';
CREATE DATABASE metastore OWNER hive ENCODING 'UTF8';
CREATE DATABASE oozie OWNER oozie ENCODING 'UTF8';
CREATE DATABASE hue OWNER hue ENCODING 'UTF8';
############################################


#!!!只在主机上执行初始化数据库
#sudo /opt/cloudera/cm/schema/scm_prepare_database.sh [options] <databaseType> <databaseName> <databaseUser> <password>
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql scm scm scm
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql metastore hive hive
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql oozie oozie oozie
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql hue hue hue

#######################cdh5版本的
#yum -y install initscripts psmisc
#/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 25432 postgresql scm scm scm
#/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 25432 postgresql metastore hive hive
#/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 25432 postgresql oozie oozie oozie
#/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 25432 postgresql hue hue hue
#######################
#只在主机上启动server 一定不要启动agent #看后台的输出
systemctl start cloudera-scm-server
tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log


#等一会启动后，主机的7180端口即可访问(集群配置完成后，从这个页面可以连接到各个组件的查看页面)。
http://cdh1:7180


#页面上的操作 !!!!一定要用chrome浏览器 
用户名和密码 admin/admin

select edition 时选择free 

!!!在specify hosts 选择时，主机会自动处于当前管理的主机中，按cdh1,cdh2,cdh3选择其他主机后，点对勾的时候要把当前管理的主机中的主节点也勾上。

选择存储库时，选择自定义存储库，如果选择从网上下载的话，基本上下载不动。cm网站的时候使用http://10.1.1.87/yumrepo/cm
!!!选择方法中要选parcel，cdh版本要看有没有6.2.0可以选，如果只有一个5.16或更早的可选，有可能是/opt/cloudera/parcel-repo/CDH-6.2.0-1.cdh6.2.0.p0.967373-el7.parcel.sha1 这个没改名，如果之前装过，没有装成功，到这里没得选，基本就得重装了。

djk安装选项页中不用勾选jdk，之前已经安装过了。

提供ssh登录凭据页，使用root用户安装，使用密码。

在安装工作节点时，可以点开detail看一下，但看一看之后一定要关上，不能一直看，如果在安装结束时没关，页面自动跳到下一页时，下一页是灰的，无法操作，程序无法完成安装。
如果发生这种情况，后退一下浏览器，退回上个页面可以关闭detail。

inspect hosts页中如果连接其他机器总是有问题，有可能是ping的权限没改。



集群设置时选择 operational database 或自选安装组件

自定义角色分配中 hadoop的datanode尽量选上所有主机，hbase thrift server

数据库设置页的hive连接使用jdbc  jdbc:postgresql://10.1.1.97:15432/metastore 用户名密码以上文中设置的为准
oozie和hue的hostname要加端口号比如 10.1.1.97:15432 

审核更改中需要对系统进行配置 将几个红色标记的内容填写完整
/data/dn
/data/nn
/data/snn
/data/nm

#在安装了sqoop的机器上运行 sqoop需要用到psql命令从pg库取数据
yum install postgresql-devel

#在安装了sqoop的机器上运行 sqoop中没有postgresql的包，建一个软连接
ln -s /opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/jars/postgresql-9.0-801.jdbc4.jar /opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/lib/sqoop/lib/postgresql-9.0-801.jdbc4.jar


#在安装了sqoop的机器上运行 使用sqoop从数据库同步数据 
#-m 3 可以使用3个查询来读取数据，当不是 -m 1 时，需要带 --split-by 参数，这个必须跟一个int型的字段，sqoop会根据(max(字段)-min(字段)) / 3 来分这三个查询语句
#hive 
sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --fields-terminated-by '\001' --append --direct \
--columns requesttime,appid,userid,url,prevurl,eventname,ip,userislogin,browser,os,browser_ver,os_ver,insert_time,receive_time,uuid,topic,data1,eeid,query \
--where " requesttime> '20190517'::date " \
--target-dir /user/hive/warehouse/bi_srcapp.db/slog -- --schema bi_srcapp 

#hbase
sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --hbase-table 'SLOG'  --hbase-row-key 'receive_time' --column-family 'cf1' \
--columns requesttime,appid,userid,url,prevurl,eventname,ip,userislogin,browser,os,browser_ver,os_ver,insert_time,receive_time,uuid,topic,data1,eeid,query \
--where " requesttime >= '20190521'::date and requesttime < '20190522'::date "  -- --schema bi_srcapp


sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --hbase-table 'SLOG'  --hbase-row-key 'receive_time' --column-family 'cf1' \
--columns requesttime,appid,userid,url,prevurl,eventname,ip,userislogin,browser,os,browser_ver,os_ver,insert_time,receive_time,uuid,topic,data1,eeid,query \
--where " requesttime >= '20190601'::date and requesttime < '20190701'::date "  -- --schema bi_srcapp




#######################增加新服务器操作#############################

docker run --name cdh4 -h cdh4 -v /sdd1/cdh4data:/data --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name cdh5 -h cdh5 -v /sde1/cdh5data:/data --privileged=true -itd centos:7.6.1810 /usr/sbin/init

#在前三台服务器的/etc/hosts中增加这两台服务器的ip和机器名
vim /etc/hosts

#在cdh的控制页面添加新主机，删除已有主机即可，数据会自动同步到新主机上。




















