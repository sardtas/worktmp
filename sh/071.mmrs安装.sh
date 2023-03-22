
https://developer.download.nvidia.cn/compute/cuda/9.2/Prod/docs/sidebar/md5sum.txt


-----------------------centos7安装gcc
yum install centos-release-scl -y
yum install devtoolset-3-toolchain -y
scl enable devtoolset-3 bash
gcc --version

yum install centos-release-scl-rh centos-release-scl
yum check-update
yum install devtoolset-3-gcc  devtoolset-3-gcc-c++
source /opt/rh/devtoolset-3/enable
g++ --version


centos7默认带的包太老，得换一个
sudo rm -rf /usr/lib64/libstdc++.so.6
sudo ln -s  /opt/nvidia/nsight-systems/2019.3.7/Host-x86_64/libstdc++.so.6 /usr/lib64/libstdc++.so.6





--------------------------------waifu2x
apt install libsnappy-dev libgraphicsmagick1-dev libssl1.0-dev luarocks


#安装cmake3.14.2，默认是3.10.2版本 不安的话，distro在安装过程中会报错
https://cmake.org/download/


###-----或者使用以下命令安装 
#sudo apt install torch-trepl
#安装torch 这个只能用git下，因为要下载子目录，子目录实际上与项目平级。用git下载时会把平级的这些工程都下到子目录下。
# http://torch.ch/docs/getting-started.html 默认装在用户目录下了
git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch; bash install-deps;
./install.sh



git clone --depth 1 https://github.com/nagadomi/waifu2x.git

cd waifu2x
./install_lua_modules.sh

#报错：      fatal: 不是一个 git 仓库（或者任何父目录）：.git
#解决办法：  git init











