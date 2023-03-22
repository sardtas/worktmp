#看系统中是否默认带了mariadb安装包，有的话就删除。
rpm -qa | grep mariadb
rpm -e --nodeps mariadb-libs

#安装中文
yum -y install ntp
rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #修改时区
yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common #安装中文支持
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8


#从https://dev.mysql.com/downloads/repo/yum/ 能查到对应版本的yum源记录，安装对应版本的
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm

#接下来可以通过yum repolist all | grep mysql查看yum源中的mysql安装包,默认mysql80是enabled，禁用80,开启57
yum repolist all | grep mysql
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
#再看一下是否关闭了80,开启了57
yum repolist all | grep mysql
#安装mysql
#yum install mysql-community-server
yum install mysql-community-server-5.6.16-1.el7.x86_64


#docker mysql:5.7版本修改，增加log_bin = mysql_bin
vim /etc/mysql/mysql.conf.d/mysqld.cnf
#增加或修改以下几项 
!!生产环境的编码不要改，改了会影响已经存在的表
[client]
default-character-set=utf8mb4
[mysqld]
binlog-format=ROW
server_id = 100
log-bin=mysql-bin
character-set-server=utf8mb4

#重启mysql 
#debian ubuntu使用：
service mysql restart
#redhat centos使用：
systemctl restart mysqld

#进入mysql，查看是否已经生效
mysql
show variables like 'log_bin%';
#建数据库和用户 这个可以用作测试，生产环境不要动
#create database dc;
#create user 'dc'@'%' identified by 'dc';
#grant all privileges on dc.* to dc;


#插入数据后查看binlog的情况 
show binlog events;
show master status\G

#查看binlog的文件
show binary logs;
show binlog events;
show binlog events in 'mysql-bin.000004';

mysqlbinlog --start-datetime='2016-08-02 00:00:00' --stop-datetime='2016-08-03 23:01:01' -d hadoop /var/lib/mysql/mysql-bin.000001
mysqlbinlog --start-position=100 --stop-position=10000 -d dc /var/lib/mysql/mysql-bin.000004


#建canal的读取用户
CREATE USER canal IDENTIFIED BY 'canal';  
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'canal'@'%';
-- GRANT ALL PRIVILEGES ON *.* TO 'canal'@'%' ;
FLUSH PRIVILEGES;







