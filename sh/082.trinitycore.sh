sudo apt-get install git clang cmake make gcc g++ libmariadbclient-dev libssl1.0-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mysql-server p7zip


sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100

#https://github.com/TrinityCore/TrinityCore/releases
#从这个页面下载sourece和TDB资料包


cd TrinityCore
mkdir build
cd build

sudo mkdir -p /data/wow/server
sudo chown -R yangyong:yangyong /data

cmake ../ -DCMAKE_INSTALL_PREFIX=/data/wow/server
make 
make install

cd /work/d/game/
rar x wlkwow.rar
cd wlkwow
/data/wow/server/bin/mapextractor
/data/wow/server/bin/vmap4extractor
mkdir vmaps
/data/wow/server/bin/vmap4assembler Buildings vmaps
/data/wow/server/bin/mmaps_generator
cp -r dbc maps vmaps mmaps /data/wow/server/data


cd /data/wow/server/etc
cp worldserver.conf.dist worldserver.conf
cp authserver.conf.dist authserver.conf
vim worldserver.conf
#修改datadir的值
DataDir = "/data/wow/server/data"

#在数据库中建用户和database
su
mysql
GRANT USAGE ON * . * TO 'trinity'@'%' IDENTIFIED BY 'trinity' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 ;
CREATE DATABASE `world` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE `characters` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE `auth` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON `world` . * TO 'trinity'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `characters` . * TO 'trinity'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `auth` . * TO 'trinity'@'%' WITH GRANT OPTION;

cd /data/wow/server/bin
7zr x /work/soft/game/wow20031/TDB_full_world_335.20031_2020_03_16.7z -o./





