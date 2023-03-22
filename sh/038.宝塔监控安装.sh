#最好是装在centos上，
yum install wget curl python3-pip
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
curl http://download.bt.cn/install/update6.sh|bash


###只有ubuntu测试成功了，centos装不上，deepin也装不上
apt update
apt install -y vim python python-pip gcc wget curl
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh 
sudo bash install.sh
curl http://download.bt.cn/install/update6.sh|bash


Centos安装命令：
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh

试验性Centos/Ubuntu/Debian安装命令 独立运行环境（py3.7） 可能存在少量兼容性问题 不断优化中  
curl -sSO http://download.bt.cn/install/install_panel.sh && bash install_panel.sh
复制代码

Ubuntu/Deepin安装命令：
wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh

Debian安装命令：
wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh

Fedora安装命令:
wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh

Linux面板7.2.0升级命令：
curl http://download.bt.cn/install/update6.sh|bash
复制代码


Bt-Panel: http://172.17.1.3:8888/9f748ae6
username: ijoext0y
password: e152173b







