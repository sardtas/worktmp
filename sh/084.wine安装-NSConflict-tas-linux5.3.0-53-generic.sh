dpkg --add-architecture i386 
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
#u20  sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'

apt install libsdl2-dev libsdl2-2.0-0
#download faudio
tar -xf faudio_19.07.orig.tar.gz
cd FAudio-19.07
mkdir build
cd build 
cmake ../
make
sudo make install 
sudo apt update -o Acquire::https::Proxy="http://127.0.0.1:58591"
sudo apt install --install-recommends winehq-stable -o Acquire::https::Proxy="http://127.0.0.1:58591"


apt install -y --install-recommends winehq-stable -o Acquire::https::Proxy="http://10.1.1.114:58591"


#安装qq过程
cd
mkdir wine
cd wine
WINEARCH=win32 WINEPREFIX=/root/wine/win10 winecfg
WINEARCH=win32 WINEPREFIX=/root/wine/win10 winetricks


richtx32




