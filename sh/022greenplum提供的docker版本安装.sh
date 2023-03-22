docker pull pivotaldata/gpdb-devel
#docker run -it -p 15430:15432 --name gpdb0 -v /root/greenplum-db-gpdb-sandbox-tutorials-d734733/:/workspace/gpdb/tutorials -d pivotaldata/gpdb-devel
docker run -it --name gp0 -d pivotaldata/gpdb-devel
docker exec -it gp0 /bin/bash

#进入docker后，使用gpadmin来操作，会自动创建数据库
su gpadmin

#创建用户
createuser -P dlw

#创建数据库
createdb dlwdb

#进入命令行，建用户
psql dlwdb
CREATE USER cyj WITH PASSWORD 'cyj' NOSUPERUSER;
CREATE ROLE dcyls;
GRANT dcyls TO dlw,cyj;

#退出psql，修改允许登录，重启gp
cd /workspace/gpdb/gpAux/gpdemo/datadirs/qddir/demoDataDir-1
vim pg_hba.conf
gpstop -r

cd /workspace/gpdb/contrib/dblink
make
make install
psql -f dblink.sql dlwdb

#改配置文件，设置高一些的虚拟内存
gpconfig -c gp_vmem_protect_limit -v 25600MB
gpconfig -c max_statement_mem -v 16384MB
gpconfig -c statement_mem -v 2400MB
gpconfig -c vm_protect -v 2048MB





