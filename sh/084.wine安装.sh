#查看对应版本
https://wiki.winehq.org/Gecko
https://wiki.winehq.org/Mono
#在这里下载
http://mirrors.ustc.edu.cn/wine/wine/

#为了下载mono快，在hosts中加入
193.1.193.66 nchc.dl.sourceforge.net
193.1.193.66 ncu.dl.sourceforge.net

#playonlinux 安装
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget http://deb.playonlinux.com/playonlinux_bionic.list -O /etc/apt/sources.list.d/playonlinux.list
sudo apt-get update
sudo apt-get install playonlinux
#https://dl.winehq.org/wine/wine-mono/

！！！系统有wine的就放到系统的wine下，没有的放playonlinux下
可能的安装目录
/usr/share/wine/gecko
/opt/wine-stable/share/wine/gecko/
#把下好的mono和gecko放到对应的目录下，mono和gecko目录不存在自己建

#把需要下载的东西ressources中的内容放到主目录的.PlayOnLinux下
cp /work/soft/ressources/* ~/.PlayOnLinux/ressources/

#不知道有没有用 LC_ALL=zh_CN.UTF-8

#用wine 安装东西 wine msiexec /i wine-mono-4.9.4.msi 放到相应的目录下，就不用手动安装了

#不好用：安装wine时报错，按报错的组件查32位，apt install gcc.i686
-- Cannot build a 32-bit program, you need to install 32-bit development libraries.


#安装winehq
#u18.04 先安装两个包，再装，要不装的时候就报错了，装不了
wget https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/i386/libfaudio0_19.07-0~bionic_i386.deb
wget https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/amd64/libfaudio0_19.07-0~bionic_amd64.deb
sudo dpkg -i libfaudio0_19.07-0~bionic_i386.deb
sudo dpkg -i libfaudio0_19.07-0~bionic_amd64.deb
sudo apt install -f 
#然后再试一遍看装不装上
sudo dpkg -i libfaudio0_19.07-0~bionic_i386.deb
sudo dpkg -i libfaudio0_19.07-0~bionic_amd64.deb

sudo dpkg --add-architecture i386 
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
sudo apt install --install-recommends winehq-stable


#u20.4
sudo dpkg --add-architecture i386 
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' 
sudo apt install --install-recommends winehq-stable








--------------------以下都是不好使的





#安装playonlinux 运行不了
https://www.playonlinux.com/en/download.html
#u18.04
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget http://deb.playonlinux.com/playonlinux_bionic.list -O /etc/apt/sources.list.d/playonlinux.list
sudo apt-get update
sudo apt-get install playonlinux

sudo dpkg --add-architecture i386 
#playonlinux 找不到32bits OpenGL库
sudo apt install xterm
sudo apt install wine-stable


#以下语句不好用，说有包冲突 
sudo apt install --install-recommends winehq-stable
#解决冲突
sudo apt-get install aptitude
sudo aptitude install winehq-stable


#安装deepin 商店， qq 微信
git clone https://gitee.com/wszqkzqk/deepin-wine-for-ubuntu.git
install.sh
sudo gedit /etc/sysctl.conf
#IPv6 disabled
net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1
sudo sysctl -p
ipconfig

#ubuntu 18.04
sudo vi /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"
GRUB_CMDLINE_LINUX="ipv6.disable=1"
sudo update-grub
sudo reboot


#安装其他exe 
#先得安这个
添加公钥
wget -nc https://download.opensuse.org/repositories/Emulators%3A/Wine%3A/Debian/xUbuntu_18.04/Release.key; apt-key add Release.key
添加仓库
sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./'
更新
sudo apt update
安装libfaudio0
sudo apt install libfaudio0
安装wine
sudo apt install --install-recommends winehq-stable
sudo dpkg --add-architecture i386    [Enable 32-bit Arch]
$ wget -nc https://dl.winehq.org/wine-builds/winehq.key
$ sudo apt-key add winehq.key
$ sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'  [Ubuntu 20.04 & Linux Mint 20]
$ sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' [Ubuntu 18.04 & Linux Mint 19.x]
$ sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main' [Ubuntu 16.04 & Linux Mint 18.x]


$ sudo apt-get update
$ sudo apt-get install --install-recommends winehq-stable

#还需要安mono 
apt install gnupg ca-certificates
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" |  tee /etc/apt/sources.list.d/mono-official-stable.list
apt update
apt install mono-devel

#还需要安装gecko 和 html gecko


#下载太慢，单独安装,先下安装包 ！！！编译失败，编着编着就死机了
https://mirrors.tuna.tsinghua.edu.cn/winehq/wine/source/
#安装需要的lib
apt-get install gcc-multilib g++-multilib module-assistant flex bison libx11-dev:i386 libfreetype6-dev:i386 libfreetype6-dev libxrender-dev:i386 libgnutls28-dev:i386


