在ubuntu 18.04上安装的
apt install -y cmake make 
apt install clinfo ocl-icd-libopencl1 opencl-headers ocl-icd-opencl-dev lsb-core
apt install python3-pip  libopencv-dev
git clone "https://github.com/DeadSix27/waifu2x-converter-cpp"
cd waifu2x-converter-cpp
mkdir out && cd out
cmake ..
make -j4
sudo make install




#照片清晰度处理 注意看一下python要3 
git clone https://github.com/TencentARC/GFPGAN.git
cd GFPGAN

pip install basicsr
pip install facexlib

pip install -r requirements.txt
sudo python setup.py develop

pip install realesrgan

#下载模型，这个命令可能下不动，用浏览器下
wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -P experiments/pretrained_models
#这几个放到  /home/yangyong/.local/lib/python3.6/site-packages/facexlib/weights/ 下
https://github.com/xinntao/facexlib/releases/download/v0.1.0/detection_Resnet50_Final.pth
https://github.com/xinntao/facexlib/releases/download/v0.2.2/parsing_parsenet.pth

#用cpu跑的话，得改代码， if not torch.cuda.is_available():  # CPU 这下边的用下边的复制，就这不一样 half=False) 
#这个放到/home/yangyong/.local/lib/python3.6/site-packages/realesrgan/weights/ 下
https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.1/RealESRGAN_x2plus.pth


python inference_gfpgan.py -i inputs/whole_imgs -o results -v 1.3 -s 2




