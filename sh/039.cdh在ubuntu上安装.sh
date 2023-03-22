文件
https://archive.cloudera.com/cm6/6.3.1/ubuntu1804/apt/pool/contrib/e/enterprise

https://archive.cloudera.com/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-bionic.parcel
https://archive.cloudera.com/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-bionic.parcel.sha1
https://archive.cloudera.com/cdh6/6.3.2/parcels/manifest.json

-----------------------------------
scp * yy@pc33:/opt
scp * yy@pc44:/opt
scp * pc55:/opt
scp * pc66:/opt
-----------------------------------

#用root用户执行
apt install ntp
chmod 777 /opt
cd /opt
apt-key add archive.key
mv cloudera-manager.list /etc/apt/sources.list.d/
apt-get update
cp cloudera-* /var/cache/apt/archives/ 
apt install -yq openjdk-8-jdk cloudera-manager-daemons cloudera-manager-agent 

#在主机上准备安装文件
mkdir -p /opt/cloudera/parcel-repo
mv CDH-* /opt/cloudera/parcel-repo/
mv manifest.json /opt/cloudera/parcel-repo/
chown -R cloudera-scm:cloudera-scm /opt/cloudera/
#在主机上装mysql
apt install cloudera-manager-server
apt install -yq mysql-server mysql-client libmysqlclient-dev libmysql-java
vim /etc/mysql/mysql.conf.d/mysqld.cnf 
#去掉bind 127.0.0.1
#sudo mysql_secure_installation
#sudo mysql -h127.0.0.1 -uroot -p
mysql

-- 创建数据库
-- Cloudera Manager Server
CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Activity Monitor
CREATE DATABASE amon DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Reports Manager
CREATE DATABASE rman DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Hue
CREATE DATABASE hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Hive Metastore Server
CREATE DATABASE hive DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Sentry Server
CREATE DATABASE sentry DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Cloudera Navigator Audit Server
CREATE DATABASE nav DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Cloudera Navigator Metadata Server
CREATE DATABASE navms DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
-- Oozie
CREATE DATABASE oozie DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
 
#创建用户并授权
GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'scm123456';
GRANT ALL ON amon.* TO 'amon'@'%' IDENTIFIED BY 'amon123456';
GRANT ALL ON rman.* TO 'rman'@'%' IDENTIFIED BY 'rman123456';
GRANT ALL ON hue.* TO 'hue'@'%' IDENTIFIED BY 'hue123456';
GRANT ALL ON hive.* TO 'hive'@'%' IDENTIFIED BY 'hive123456';
GRANT ALL ON sentry.* TO 'sentry'@'%' IDENTIFIED BY 'sentry123456';
GRANT ALL ON nav.* TO 'nav'@'%' IDENTIFIED BY 'nav123456';
GRANT ALL ON navms.* TO 'navms'@'%' IDENTIFIED BY 'navms123456';
GRANT ALL ON oozie.* TO 'oozie'@'%' IDENTIFIED BY 'oozie123456';



/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm123456
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql amon amon amon123456
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql rman rman rman123456
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql hue hue hue123456
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql hive hive hive123456
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql sentry sentry sentry123456
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql nav nav nav123456
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql navms navms navms123456
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql oozie oozie oozie123456
######################################

drop database scm;
drop user scm;
CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'scm123456';

#######################

#在各个机器上执行
service cloudera-scm-agent start
#在主机上执行
systemctl start cloudera-scm-server
#查看启动日志，等待Jetty启动完成
tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log



!!!!!
安装过程中主机会在几台分机上安装agent,在安装时要选择公用路径，不要选cloudera的，因为cloudera的网站连不上。会报复制文件错误。



