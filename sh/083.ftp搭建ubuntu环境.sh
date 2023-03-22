apt-get install vsftpd  

mkdir /opt/hadoopnfs
mount -t nfs -o vers=3,proto=tcp,nolock,noatime,sync,noacl pc33:/ /opt/hadoopnfs 

#这个文件就看着改吧，加一个默认目录
/etc/vsftpd.conf

listen=YES
listen_ipv6=NO	
local_umask=022
anonymous_enable=NO	
chroot_local_user=NO
local_root=/home/xkw/ftp


#不允许登录的在这个表里设置，允许谁登录的话，就建用户就可以了
vim /etc/ftpusers

service vsftpd start  
