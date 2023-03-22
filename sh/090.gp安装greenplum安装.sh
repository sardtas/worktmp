#下载gp的安装包 安装
https://github.com/greenplum-db/gpdb/releases/tag/6.23.0

#设置打开连接数等 


#编辑配置文件
cd 
mkdir conf
mkdir gpmaster
#把集群的机器做好ssh互联，seg的机器名写到这个hosts里 主要自己也要可以直连  cat id_rsa.pub >> authorized_keys 
vim conf/clust_hosts
#把默认配置cp一份，改数据位置和机器配置
cp /usr/local/greenplum-db/docs/cli_help/gpconfigs/gpinitsystem_config ~/conf/
#主要是以下几项和端口
ARRAY_NAME="yygp1"
MASTER_HOSTNAME=u18
MASTER_DIRECTORY=/home/yangyong/gpmaster
#这里的目录要提前建好
declare -a DATA_DIRECTORY=(/opt/sda/gg /opt/sdb/gg /opt/sdc/gg )
declare -a MIRROR_DATA_DIRECTORY=(/data1/mirror /data1/mirror /data1/mirror /data2/mirror /data2/mirror /data2/mirror)
MACHINE_LIST_FILE=/home/gpadmin/conf/clust_hosts


#初始化数据库
gpinitsystem -c /home/gpadmin/conf/gpinitsystem_config -a
#gpinitsystem -c /home/gpadmin/conf/gpinitsystem_config -s sdw1 -a #配置standby命令

#安装完后，pg_hba.conf 里得自己调整一下。
#初始化之后会自动启动，如果手动启动，要加一个路径
export MASTER_DATA_DIRECTORY=/home/yangyong/gpmaster/gpseg-1

gpstart
gpstop


#gpload不好使 还有一个默认安装 dataflow的也得注释掉     有时间试试 gpfdist
如果没有使用默认端口，改 /usr/local/greenplum-db-6.16.2/lib/python/gppylib/db/dbconn.py  第107行，把端口改对
改 /usr/local/greenplum-db-6.16.2/bin/gpload.py 1929行那一段都注了，gp没有dataflow


#插入慢 insert 慢, 以下修改也不好使，insert就是慢，用gpload
#关日志
gpconfig -c log_statement -v none
#关全局死锁开关
gpconfig -c gp_enable_global_deadlock_detector -v on

!!!如果gp安装的时候不是用的默认5432端口，gpconfig会不好使， 环境变量中增加 export PGPORT=5432 或修改 /usr/local/greenplum-db/lib/python/gppylib/db/dbconn.py
 def __init__( 改下面的默认端口
        if port is 0:
            self.pgport = int(os.environ.get('PGPORT', '45432'))
        else:
            self.pgport = int(po



