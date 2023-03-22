docker pull nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
docker pull nvidia/cuda:10.1-cudnn7-devel-centos7




conda create -n py27 python=2.7
pip install torch opencv-python scipy

cd /work/program/matlab/extern/engines/python

python setup.py build --build-base="builddir" install
python setup.py install --prefix="installdir"
python setup.py build --build-base="builddir" install --prefix="installdir"
python setup.py install --user

#matlab的so包太老，需要使用一个新的才行
ln -s /usr/lib/i386-linux-gnu/libstdc++.so.6 /work/program/matlab/sys/os/glnxa64/libstdc++.so.6

cuda装10的话，9.0的so会找不到
ln -s /usr/local/cuda/targets/x86_64-linux/lib/libcudart.so.10.1 /usr/local/cuda/targets/x86_64-linux/lib/libcudart.so.9.0
#重新加载动态链接库
sudo /sbin/ldconfig -v




python demo.py --model model/model_srresnet.pth --dataset Set5 --image 12n --scale 4 --cuda

python eval.py --model model/model_srresnet.pth --dataset Set5


pip install opencv-python


ninjal
conda install pytorch torchvision cudatoolkit=10.0 -c pytorch
-----------------mmsr

pip install torch numpy opencv-python lmdb pyyaml torchvision
cd ./codes/models/archs/dcn
python setup.py develop
pip install tb-nightly future


python test.py -opt options/test/aa.yml




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


