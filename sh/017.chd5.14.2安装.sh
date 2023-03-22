!!需要准备一个数据库作为cdh的资料库，注意版本尽量小于9,如果选择大于9的，安装过程中需要更换cdh的jdbc包，默认使用的jdbc无法连接10版本以上的pg。这个数据库可以装到cdh的一台机器上，但一定要注意重启时先关闭数据库，如果这个数据库出了问题，cdh的集群就没了，整个cdh的集群都要格掉重装。

#新建docker虚拟机
docker run --name cc1 -h cc1 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name cc2 -h cc2 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name cc3 -h cc3 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name cc4 -h cc4 --privileged=true -itd centos:7.6.1810 /usr/sbin/init

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
rpm --import http://10.1.1.87/soft/yumrepo/RPM-GPG-KEY-cloudera
#yum -y install oracle-j2sdk1.7
yum -y install oracle-j2sdk1.8

#试一下如果java不能用则建一个连接，不知道为什么有时候装完不能用。
java -version
#如果不行，则将java写入path
echo 'export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera' >> /etc/profile
echo 'export PATH=/usr/java/jdk1.7.0_67-cloudera/bin:$PATH' >> /etc/profile
echo 'export HADOOP_USER_NAME=hdfs' >> /etc/profile
echo 'export LANG=zh_CN.UTF-8' >> /etc/profile


#如果是装在docker中，不是使用ssh root登录的，还需要把这些配置放在.bashrc中，登录后执行一下 . .bashrc
echo 'export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera' >> /root/.bashrc
echo 'export PATH=/usr/java/jdk1.7.0_67-cloudera/bin:$PATH' >> /root/.bashrc
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
server 10.1.1.87
restrict 10.1.1.87 nomodify notrap noquery
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
mkdir -p /data
#如果是实体机，修改vim /etc/fstab 文件，增加硬盘的挂载。
chmod -R 777 /data


#从主机登录一下其他机器，保证know_hosts中有其他机器的信息 --可以不用
ssh cdh1
ssh cdh2
ssh cdh3

#!!!只在主机上设置，如果这个文件夹不存在，就新建一个 mkdir -p /opt/cloudera/parcel-repo
scp yangyong@10.1.1.87:/media/yangyong/d4y/soft/yumrepo/pa5/* /opt/cloudera/parcel-repo/

chmod 777 /opt/cloudera/parcel-repo/
chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/*


#!!!在数据库那台机器上安装
sudo yum install python-pip
sudo pip install psycopg2==2.7.5 --ignore-installed

#如果提示没有python-pip ，就得先装一下epel, docker下的centos可能没有epel，实体机装的centos一般默认带epel
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum install -y epel-release
#
CREATE user scm LOGIN PASSWORD 'scm';
CREATE DATABASE scm OWNER scm ENCODING 'UTF8';

CREATE user hive LOGIN PASSWORD 'hive';
CREATE DATABASE metastore OWNER hive ENCODING 'UTF8';

CREATE user oozie LOGIN PASSWORD 'oozie';
CREATE DATABASE oozie OWNER oozie ENCODING 'UTF8';

CREATE user hue LOGIN PASSWORD 'hue';
CREATE DATABASE hue OWNER hue ENCODING 'UTF8';

CREATE user ams LOGIN PASSWORD 'ams';
CREATE DATABASE ams OWNER ams ENCODING 'UTF8';


###########出错时重装前需要先清数据库############
drop database scm;
drop database metastore;
drop database oozie;
drop database hue;
drop database ams;
CREATE DATABASE scm OWNER scm ENCODING 'UTF8';
CREATE DATABASE metastore OWNER hive ENCODING 'UTF8';
CREATE DATABASE oozie OWNER oozie ENCODING 'UTF8';
CREATE DATABASE hue OWNER hue ENCODING 'UTF8';
CREATE DATABASE ams OWNER ams ENCODING 'UTF8';
############################################


#!!!只在主机上执行初始化数据库  一定要用ip ,不要用机器名
#sudo /opt/cloudera/cm/schema/scm_prepare_database.sh [options] <databaseType> <databaseName> <databaseUser> <password>
#######################cdh5版本的
yum -y install initscripts psmisc
/usr/share/cmf/schema/scm_prepare_database.sh -h 172.17.4.3 -P 5432 postgresql scm scm scm



###############安装 kerberos #######################
#在一台新的主机上安装
yum install krb5-server krb5-libs krb5-auth-dialog vim 
#配置 注意这里的管理域名一般都是大写的。
vim /var/kerberos/krb5kdc/kdc.conf
vim /etc/krb5.conf
#新建一个库，-r XKW.COM 是默认用哪个域
/usr/sbin/kdb5_util create -s -r XKW.COM
#建一个管理员用户,要记住过程中设置的密码。
/usr/sbin/kadmin.local -q "addprinc admin/admin"
#调整权限
vim /var/kerberos/krb5kdc/kadm5.acl

#启动服务
systemctl start krb5kdc
systemctl start kadmin

#进入kerberos管理命令行，给cdh建一个管理用户，注意名字是 xxx/admin@XKW.COM  这样的，
kadmin.local
addprinc cms/admin@XKW.COM

#在需要使用kerberos的机器上安装客户端
yum install -y krb5-workstation krb5-libs krb5-auth-dialog krb5-devel openldap-clients

#将配置文件考到客户端机器上
scp /etc/krb5.conf cc1:/etc/
scp /etc/krb5.conf cc2:/etc/
scp /etc/krb5.conf cc3:/etc/
scp /etc/krb5.conf cc4:/etc/
scp /etc/krb5.conf cc5:/etc/


#在客户端机器上登录一下试试看，如果没有报错，就可以了
kinit admin/admin@XKW.COM

!!!在构建cdh完成后hue的认证可能会出问题，要执行以下步骤：
#https://docs.cloudera.com/documentation/manager/5-1-x/Configuring-Hadoop-Security-with-Cloudera-Manager/cm5chs_enable_hue_sec_s10.html
在kdc主机上的kadmin.local中执行，注意hue所在机器名和域名：
modprinc -maxrenewlife 90day krbtgt/XKW.COM
modprinc -maxrenewlife 90day +allow_renewable hue/cc1@XKW.COM

#######################
#只在主机上启动server 一定不要启动agent #看后台的输出
systemctl start cloudera-scm-server
tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log


#等一会启动后，主机的7180端口即可访问(集群配置完成后，从这个页面可以连接到各个组件的查看页面)。
http://cdh1:7180


#页面上的操作 !!!!一定要用chrome浏览器 (尽量用chrome吧，感觉是随机出问题的!!)
用户名和密码 admin/admin

select edition 时选择free 

!!!在specify hosts 选择时，主机会自动处于当前管理的主机中，按cdh1,cdh2,cdh3选择其他主机后，点对勾的时候要把当前管理的主机中的主节点也勾上。

选择存储库时，选择自定义存储库，如果选择从网上下载的话，基本上下载不动。cm网站的时候使用http://10.1.1.87/yumrepo/cm5
增加一个streamsets的位置http://10.1.1.87/yumrepo/streamsets/
!!!选择方法中要选parcel，cdh版本要看有没有5.14.2可以选，点parcels下边的更多选项，增加一个phoenix的网站 http://10.1.1.87/yumrepo/phoenix5.14.2/
返回后等一小会，会出现phoenix的选项，选上再点继续。

djk安装选项页中不用勾选jdk，之前已经安装过了。

提供ssh登录凭据页，使用root用户安装，使用密码。

在安装工作节点时，可以点开detail看一下，但看一看之后一定要关上，不能一直看，如果在安装结束时没关，页面自动跳到下一页时，下一页是灰的，无法操作，程序无法完成安装。
如果发生这种情况，后退一下浏览器，退回上个页面可以关闭detail。

inspect hosts页中如果连接其他机器总是有问题，有可能是ping的权限没改。



集群设置时选择 operational database 或自选安装组件

自定义角色分配中 hadoop的datanode尽量选上所有主机，hbase thrift server

数据库设置页的hive连接使用jdbc  jdbc:postgresql://10.1.1.97:15432/metastore 用户名密码以上文中设置的为准
oozie和hue的hostname要加端口号比如 10.1.1.97:15432 

审核更改中需要对系统进行配置 将几个红色标记的内容填写完整,cdh5会自动检测本地的硬盘，注意把不打算给hadoop用的硬盘删除
如果机器少，可损失机器数量写0,如果机器多，就可以写多一点。
/data/dn
/data/nn
/data/snn
/data/nm

!!如果在审核更改后“集群设置”的这一步出现问题，就单独打开一个页面 http://cc1:7180
可以看到有错误的配置，点那个红色小扳手，给jobtracker(选一台机器)和tasktracke(选所有机器)选上服务器，finish之后回到原来的页面，点重新执行就可以了()。


#在安装了sqoop的机器上运行 sqoop需要用到psql命令从pg库取数据
yum install postgresql

#在安装了sqoop的机器上运行 sqoop中没有postgresql的包，建一个软连接
ln -s /opt/cloudera/parcels/CDH/jars/postgresql-9.1-901.jdbc4.jar /opt/cloudera/parcels/CDH/lib/sqoop/lib/postgresql-9.1-901.jdbc4.jar


#phoenix使用hbase需要的配置
打开cc1:7180的页面端，集群--hbase--配置 ，搜索 “hbase-site.xml” 会有两个结果，一个是 HBase 的服务端高级配置代码，一个是客户端高级配置代码 在这两个中增加以下三项(点用xml查看)：
<property><name>hbase.regionserver.wal.codec</name><value>org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec</value></property>
<property><name>phoenix.schema.isNamespaceMappingEnabled</name><value>true</value></property>
<property><name>phoenix.schema.mapSystemTablesToNamespace</name><value>true</value></property>



#hive连接phoenix需要加入phoenix的包，
ln -s /opt/cloudera/parcels/APACHE_PHOENIX/lib/phoenix/phoenix-4.14.0-cdh5.14.2-hive.jar /opt/cloudera/parcels/CDH/lib/hive/lib/phoenix-4.14.0-cdh5.14.2-hive.jar


#使用dbeaver连接hive
org.apache.hive 的 hive-jdbc的 1.1.0 版本
org.apache.hadoop 的 hadoop-common 的 2.6.0 版本
org.apache.hadoop 的 hadoop-client 的 2.6.0 版本

#使用dbeaver连接phoenix的话引入所有的phoenix包后，还需要设置属性
<property><name>hbase.regionserver.wal.codec</name><value>org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec</value></property>
<property><name>phoenix.schema.isNamespaceMappingEnabled</name><value>true</value></property>
<property><name>phoenix.schema.mapSystemTablesToNamespace</name><value>true</value></property>



#在安装了sqoop的机器上运行 使用sqoop从数据库同步数据 
#-m 3 可以使用3个查询来读取数据，当不是 -m 1 时，需要带 --split-by 参数，这个必须跟一个int型的字段，sqoop会根据(max(字段)-min(字段)) / 3 来分这三个查询语句
#hive 
sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --fields-terminated-by '\001' --append --direct \
--columns requesttime,appid,userid,url,prevurl,eventname,ip,userislogin,browser,os,browser_ver,os_ver,insert_time,receive_time,uuid,topic,data1,eeid,query \
--where " requesttime> '20190517'::date " \
--target-dir /user/hive/warehouse/bi_srcapp.db/s_aliyun_log -- --schema bi_srcapp 

#hbase
sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --hbase-table 'SLOG'  --hbase-row-key 'receive_time' --column-family '0' \
--columns requesttime,appid,userid,url,prevurl,eventname,ip,userislogin,browser,os,browser_ver,os_ver,insert_time,receive_time,uuid,topic,data1,eeid,query \
--where " requesttime >= '20190521'::date and requesttime < '20190622'::date "  -- --schema bi_srcapp


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

!!如果遇到ip .in-addr.arpa domain name pointer 一个错误机器名，是反向解析出错导致的，也不知道为什么会这样，重启了一下电脑，就出了一大堆问题。
rm -y /usr/bin/host
删除了host文件后,cdh执行反向解析时就找不到host文件了，就不解析了。

!!!!!!所有需要连接到hbase或phoenix的机器都要在hosts中写明cdh集群的每台机器对应的ip地址，因为服务请求发出时不论是ip还是机器名，信息从cdh返回时都是以机器名为准的，
不是以ip为准，这时发出请求的机器如果无法定位机器名，则任务不会成功，也不报错，只是不停的重试，重试。


#在网页上修改hive-site的配置增加动态分区
<property><name>hive.exec.dynamici.partition</name><value>true</value></property><property><name>hive.exec.dynamic.partition.mode</name><value>nonstrict</value></property>



#使用kudu的话，需要在网页端修改kudu的配置，这个超时默认是3分钟，但进行修改或删除时，3分钟很可能不够用。
修改项：Kudu Service Advanced Configuration Snippet (Safety Valve) for kudu-monitoring.properties
kudu_operation_timeout_ms = 1800000


#impala内存溢出，修改以下项为0,不限制，但可能会有其他问题产生。
Impala Daemon 内存限制 mem_limit

!!!!注意看一下机器名是否是bogon,bogon会影响后续的安装，用host 本机ip 看一下返回的名称是什么，如果是bogon，那就要改一下dns，/etc/resolv.conf文件中配置，如果dns返回是unknow，则会使用/etc/hosts中的配置，就没有问题了。

!!!!如果部署在多台机器的docker上，ip的连通是个问题，需要使用weave来解决，weave可以建立一个虚拟网络，cdh只能安装在这个虚拟网络上。安装完成后要把主机自带的/etc/hosts中的ip与名称映射注掉，要不agent找不到server

----以下是不管用的，仅在其他情况下参考一下就行了
!!!!使用docker 时hdfs无法分布在多台服务器上，修改ip检测即可。如果cloudera不能识别，就得升级docker，低版本docker有问题。
#从hdfs下拉的实例 进入，选每个datanode，分别设置 hdfs-site.xml 中 datanode NameNode SecondaryNameNode 增加下面这段
<property> <name>dfs.namenode.datanode.registration.ip-hostname-check</name> <value>false</value> </property>



