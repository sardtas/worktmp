#ubuntu 上装yum 不好使，所以在虚拟机上同步数据，在ubuntu上开apache提供http服务
#docker的虚拟机上 docker run --name yum1 --host-name yum1 -v /work/soft/yumrepo:/yumrepo --privileged -itd centos:7.6.1810 /usr/sbin/init
yum -y install wget net-tools httpd vim openssh-server openssh-clients createrepo yum-utils
cd /etc/yum.repos.d/
wget https://archive.cloudera.com/cm6/6.2.0/redhat7/yum/cloudera-manager.repo
yum repolist


reposync -r base -p /yumrepo/centos7
reposync -r updates -p /yumrepo/centos7
reposync -r extras -p /yumrepo/centos7
reposync -r cloudera-manager -p /yumrepo/cm

reposync -r pgdg94 -p /yumrepo/pg
reposync -r pgdg95 -p /yumrepo/pg
reposync -r pgdg96 -p /yumrepo/pg
reposync -r pgdg10 -p /yumrepo/pg
reposync -r pgdg11 -p /yumrepo/pg

#在实体机上执行  cm6的需要下载一个 allkeys.asc 再生成repo文件
sudo chmod 777 /work/soft/yumrepo/cm
sudo chmod 777 /work/soft/yumrepo/centos7

wget https://archive.cloudera.com/cm6/6.2.0/allkeys.asc -P /work/soft/yumrepo/cm/

createrepo --update /work/soft/yumrepo/cm
createrepo /work/soft/yumrepo/cm

createrepo --update /work/soft/yumrepo/centos7
createrepo /work/soft/yumrepo/centos7




createrepo --update /work/soft/yumrepo/cm5
createrepo /work/soft/yumrepo/cm5


createrepo --update /work/soft/yumrepo/pa5
createrepo /work/soft/yumrepo/pa5




