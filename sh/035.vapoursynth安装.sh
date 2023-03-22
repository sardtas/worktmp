-------------这个不好使，别用----------------
apt install build-essential yasm git libass-dev autoconf libtool libmagick++-dev
apt install nasm ffmpeg libass imagemagick libevent-dev-2.1-6 Libmemcached-dev Libmemcached-tools 
yum install nasm libass ImageMagick-devel libevent-devel libmemcached-devel
#下载zimg 
https://github.com/buaazp/zimg
git clone https://github.com/buaazp/zimg -b master --depth=1
mv zimg-master zimg
cd zimg 
make
cd bin  
./zimg conf/zimg.lua
cd 
vim .bashrc
export ZIMG_HOME=/p55/zimg-master
----------------------------------



git clone https://github.com/sekrit-twc/zimg.git
./autogen.sh
./configure --prefix=/opt/zimg --enable-x86simd
make
make install
cp /opt/zimg/lib/pkgconfig/zimg.pc /usr/lib/x86_64-linux-gnu/pkgconfig/
cp /work/program/anaconda3/lib/pkgconfig/python-3.7.pc /usr/lib/x86_64-linux-gnu/pkgconfig/











git clone https://github.com/vapoursynth/vapoursynth.git
./autogen.sh
./configure
make
make install




