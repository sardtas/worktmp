在cmd中运行以下命令：
route add 172.17.0.0 mask 255.255.255.0 10.1.1.97
route add 172.17.1.0 mask 255.255.255.0 10.1.1.87

通过浏览器访问，cdh集群：
http://172.17.0.3:7180/
用户名和密码都是admin

storm集群：
http://172.17.1.2:8086/

cd /etc/yum.repos.d/
rm -f *



127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.3	cc1
172.17.0.4	cc2
172.17.0.5	cc3



select * from bi_rpt.r_log_pv_page_keep_time_s t,
    bi_rpt.r_log_dim_domain_url tt
where t.routeid = tt.url and t.domainid = tt.domainid and tt.domainname = '微营销' and tt.urlname = '工作台'
  and t.stat_date >= '20190601'::date
order by t.stat_date , t.userid;



docker run --name cc1 -h cc1 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name cc2 -h cc2 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name cc3 -h cc3 --privileged=true -itd centos:7.6.1810 /usr/sbin/init


docker run --name c11 -h c11  --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name c12 -h c12  --privileged=true -itd centos:7.6.1810 /usr/sbin/init
docker run --name c13 -h c13  --privileged=true -itd centos:7.6.1810 /usr/sbin/init




/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 25432 postgresql scm scm scm
/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 25432 postgresql metastore hive hive
/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 25432 postgresql oozie oozie oozie
/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 25432 postgresql hue hue hue



/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql scm scm scm
/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql metastore hive hive
/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql oozie oozie oozie
/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql hue hue hue
/usr/share/cmf/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql ams ams ams


cd /etc/yum.repos.d/
rm -f *


docker cp /work/tmp/pc88.repo cc1:/etc/yum.repos.d/
docker cp /work/tmp/pc88.repo cc2:/etc/yum.repos.d/
docker cp /work/tmp/pc88.repo cc3:/etc/yum.repos.d/

docker cp /work/tmp/hosts cc1:/
docker cp /work/tmp/hosts cc2:/
docker cp /work/tmp/st.sh cc1:/
docker cp /work/tmp/st.sh cc2:/
docker cp /work/tmp/hosts cc3:/
docker cp /work/tmp/st.sh cc3:/

docker cp /work/tmp/ntp.conf cc1:/etc/
docker cp /work/tmp/ntp.conf cc2:/etc/
docker cp /work/tmp/ntp.conf cc3:/etc/



docker cp /work/tmp/pc88.repo c11:/etc/yum.repos.d/
docker cp /work/tmp/pc88.repo c12:/etc/yum.repos.d/
docker cp /work/tmp/pc88.repo c13:/etc/yum.repos.d/

docker cp /work/tmp/hosts c11:/
docker cp /work/tmp/hosts c12:/
docker cp /work/tmp/hosts c13:/
docker cp /work/tmp/st.sh c11:/
docker cp /work/tmp/st.sh c12:/
docker cp /work/tmp/st.sh c13:/

docker cp /work/tmp/ntp.conf c11:/etc/
docker cp /work/tmp/ntp.conf c12:/etc/
docker cp /work/tmp/ntp.conf c13:/etc/





chmod 4755 /bin/ping
#在docker下的话，要安装ntp和文支持
yum -y install ntp
rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #修改时区
yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common #安装中文支持
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

yum -y install wget net-tools httpd vim openssh-server openssh-clients initscripts oracle-j2sdk1.7 psmisc
cd /etc/yum.repos.d/
rpm --import http://10.1.1.87/yumrepo/RPM-GPG-KEY-cloudera

echo 'export HADOOP_USER_NAME=hive' >> /etc/profile
echo 'export LANG=zh_CN.UTF-8' >> /etc/profile
chmod +x /etc/rc.d/rc.local
echo 'echo never > /sys/kernel/mm/transparent_hugepage/defrag' >> /etc/rc.local
echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local

echo 'export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera' >> /root/.bashrc
echo 'export PATH=/usr/java/jdk1.7.0_67-cloudera/bin:$PATH' >> /root/.bashrc
echo 'export HADOOP_USER_NAME=hive' >> /root/.bashrc
echo 'export LANG=zh_CN.UTF-8' >> /root/.bashrc




docker stop cc1; docker stop cc2; docker stop cc3 
docker rm cc1; docker rm cc2; docker rm cc3 

docker restart cc1; docker restart cc2; docker restart cc3 

docker stop cdh1 ; docker stop cdh2; docker stop cdh3; docker stop cdh4; docker stop cdh5

yum  install  cloudera-manager-server


scp yangyong@10.1.1.97:/work/soft/yumrepo/pa5.14.2/* /opt/cloudera/parcel-repo/

scp yangyong@10.1.1.97:/work/soft/yumrepo/pa5.13.2/* /opt/cloudera/parcel-repo/

scp yangyong@10.1.1.87:/work/soft/yumrepo/pa5/* /opt/cloudera/parcel-repo/
scp yangyong@10.1.1.97:/work/soft/yumrepo/pa/* /opt/cloudera/parcel-repo/

chmod 777 /opt/cloudera/parcel-repo/
chmod 777 /data
chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/*
cd /opt/cloudera/parcel-repo/


10.1.1.87:15432
172.17.0.2


metastore


hbase.table.sanity.checks
false


docker run --name dp10_1 -e POSTGRES_PASSWORD=uat123 -p 15432:5432 -d postgres:10.9


/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql scm scm scm
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql metastore hive hive
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql oozie oozie oozie
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql hue hue hue
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 10.1.1.97 -P 15432 postgresql ams ams ams

/opt/cloudera/cm/schema/scm_prepare_database.sh -h 172.17.0.2 -P 5432 postgresql scm scm scm
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 172.17.0.2 -P 5432 postgresql metastore hive hive
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 172.17.0.2 -P 5432 postgresql oozie oozie oozie
/opt/cloudera/cm/schema/scm_prepare_database.sh -h 172.17.0.2 -P 5432 postgresql hue hue hue




sqoop import   \
--connect jdbc:postgresql://10.1.1.90:5432/dc_logs --username bi_log --password bi_log123456 -m 1 \
--table s_aliyun_log --fields-terminated-by '\001' --append --direct \
--columns requesttime,appid,userid,url,prevurl,eventname,ip,userislogin,browser,os,browser_ver,os_ver,insert_time,receive_time,uuid,topic,data1,eeid,query \
--where " requesttime> '20190501'::date " \
--target-dir /user/hive/warehouse/slog -- --schema bi_srcapp 




Unexpected driver error occurred while connecting to database
  Inconsistent constant pool data in classfile for class org/apache/hadoop/hbase/client/Row. Method lambda$static$0(Lorg/apache/hadoop/hbase/client/Row;Lorg/apache/hadoop/hbase/client/Row;)I at index 57 is CONSTANT_MethodRef and should be CONSTANT_InterfaceMethodRef
  Inconsistent constant pool data in classfile for class org/apache/hadoop/hbase/client/Row. Method lambda$static$0(Lorg/apache/hadoop/hbase/client/Row;Lorg/apache/hadoop/hbase/client/Row;)I at index 57 is CONSTANT_MethodRef and should be CONSTANT_InterfaceMethodRef



zkServer.sh stop 
rm -rf storm/logs/*
rm -rf storm/tmp/*
rm zk/data/version-2/*



