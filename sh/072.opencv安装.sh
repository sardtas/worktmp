sudo apt -y remove x264 libx264-dev
 
## Install dependencies
sudo apt -y install build-essential checkinstall cmake pkg-config yasm
sudo apt -y install git gfortran
sudo apt -y install libjpeg8-dev libpng-dev
 
sudo apt -y install software-properties-common
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
sudo apt -y update
 
sudo apt -y install libjasper1
sudo apt -y install libtiff-dev
 
sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
sudo apt -y install libxine2-dev libv4l-dev
cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h
cd "$cwd"
 
sudo apt -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt -y install libgtk2.0-dev libtbb-dev qt5-default
sudo apt -y install libatlas-base-dev
sudo apt -y install libfaac-dev libmp3lame-dev libtheora-dev
sudo apt -y install libvorbis-dev libxvidcore-dev
sudo apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt -y install libavresample-dev
sudo apt -y install x264 v4l-utils

sudo apt -y install libprotobuf-dev protobuf-compiler
sudo apt -y install libgoogle-glog-dev libgflags-dev
sudo apt -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

sudo apt -y install python3-dev python3-pip
sudo -H pip3 install -U pip numpy
sudo apt -y install python3-testresources
We are also going to install virtualenv and virtualenvwr


# create virtual environment
python3 -m venv opencv-master-py3
echo "# Virtual Environment Wrapper" >> ~/.bashrc
echo "alias workoncv-master=\"source /work/soft/opencv/opencv-master-py3/bin/activate\"" >> ~/.bashrc
source "$cwd"/OpenCV-"$cvVersion"-py3/bin/activate
 
# now install python libraries within this virtual environment

# quit virtual environment
deactivate

sudo apt install ccache
sudo apt install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt install libdc1394-22 libdc1394-22-dev
sudo apt install libv4l-dev v4l-utils
sudo ln -s /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h


-----------------------------可以试一下不装上边这些东西---------------
#就装下边这些试试

http://joey771.cn/2019/01/18/ubuntu%E5%AE%89%E8%A3%85OpenCL%E8%BF%90%E8%A1%8C%E5%8F%8A%E7%BC%96%E8%AF%91%E7%8E%AF%E5%A2%83/

apt install clinfo ocl-icd-libopencl1 opencl-headers ocl-icd-opencl-dev lsb-core
apt install python3-pip  libopencv-dev
从intel的网站上下载opencl安装，解压用root安装。这个安装必须要有界面，没界面得配置一些选项。

pip3 install opencv-python





#opencv必须得用git clone，直接下载zip包无法编译 VTK得编译安装
git clone git://vtk.org/VTK.git VTK
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

mkdir build
cd build 

cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D CMAKE_INSTALL_PREFIX=/work/workspace/git/opencv \
            -D INSTALL_C_EXAMPLES=ON \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D WITH_TBB=ON \
            -D WITH_V4L=ON \
            -D OPENCV_PYTHON3_INSTALL_PATH=/work/soft/opencv/opencv-master-py3/lib/python3.7/site-packages \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON ..

sudo ln -fs /usr/lib/libcurl.so.4 /usr/local/lib/

make -j4
sudo make install 
sudo ldconfig






----------------------------------问题汇总
开始报了一堆 对xxxx未定义的引用，发现是 cmake步骤的路径写错了，改好后重新cmake那些错误就没了。
对‘uuid_generate@UUID_1.0’未定义的引用
conda list | grep libtiff
conda remove libtiff
conda list | grep libuuid
conda remove libuuid
























