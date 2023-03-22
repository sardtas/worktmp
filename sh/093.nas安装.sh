#gluster安装
wget -O - https://download.gluster.org/pub/gluster/glusterfs/9/rsa.pub | apt-key add -

apt update
apt install glusterfs-server

#启动服务 
service glusterd start
service glusterd status

#建立多台服务器上的同步文件夹
gluster volume create gv0 replica 3 node01.mydomain.net:/export/sdb1/brick \
    node02.mydomain.net:/export/sdb1/brick                                   \
    node03.mydomain.net:/export/sdb1/brick


#在本地建立复制 也可以设置replica 为 1 
gluster volume create gv0 replica 3 uk20:/data/b1 uk20:/data/b2 uk20:/data/b3

#启用同步
gluster volume info
gluster volume start gv0

#必须挂在一个地方才能用，直接操作/data/b1不好使
mount -t glusterfs uk20:/gv0 /mnt

#在/mnt下进行操作，/data/b*/下边也会出现相应文件







