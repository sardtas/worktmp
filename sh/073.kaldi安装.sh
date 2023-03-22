#安装waifu2x
#使用docker下的显卡驱动需要使用nvidia-docker 
#centos7以上才能用
wget https://nvidia.github.io/nvidia-docker/centos7/x86_64/nvidia-docker.repo
yum install nvidia-docker2

# ubuntu 看这个页面 https://nvidia.github.io/nvidia-docker/
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |   sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

apt install nvidia-docker2

service docker restart


nvidia-docker run --name waif -itd nagadomi/waifu2x /bin/bash

th waifu2x.lua -crop_size 128 -m noise_scale -resume 2 -noise_level 0 -i miku_small.png -o aa.png


find /root/01in -name "*.png" -o -name "*.jpg" > image_list.txt
th waifu2x.lua -crop_size 128 -m noise_scale -resume 2 -noise_level 3 -l ./image_list.txt -o /root/01out/%s_%d.png




#
nvidia-docker run --name kaldi -itd kaldiasr/kaldi:2019-10
#进入docker后看tools和src下的INSTALL说明
cd tools
make -j 12

cd ../src 
./configure --shared
make depend -j 8
make -j 8
make ext

cd
vim .bashrc
#增加path /opt/kaldi/src/onlinebin
cd /opt/kaldi/egs/voxforge/online_demo
./run.sh --test-mode live

#docker下有kaldi的镜像，但下载以后还是不能直接使用，需要安装一些依赖包。要跑测试的话还需要下载数据文件。
sudo apt-get install libasound-dev
cd tools 
extras/check_dependencies.sh
make -j 8




---------------以下这些都不用
apt install -y flac gfortran gawk gzip bzip2 p7zip make libstdc++

#下载 tcl 安装 
http://www.tcl.tk/software/tcltk/download.html

cd tcl8.6.9/unix
configure --prefix=/usr/local/tcl
make
make test
make install



#安装srilm
#下载安装文件
http://www.speech.sri.com/projects/srilm/download.html








