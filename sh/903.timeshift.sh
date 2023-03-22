add-apt-repository -y ppa:teejee2008/ppa
apt update
apt install timeshift
lsblk | grep sdb

#单找一个备份盘，分区，格式化
parted /dev/sdb  mklabel gpt
parted /dev/sdb  mkpart primary 0% 100%
mkfs.ext4  /dev/sdb1
