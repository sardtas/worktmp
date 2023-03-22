#安装gimage
sudo add-apt-repository ppa:sandromani/gimagereader
sudo apt-get update
sudo apt-get install gimagereader tesseract-ocr tesseract-ocr-eng
卸载 gimagereader 命令：
sudo apt-get remove gimagereader


#OCRFeeder
sudo apt-get install tesseract-ocr tesseract-ocr-eng tesseract-ocr-chi-sim autoconf automake libtool libleptonica-dev 
sudo apt install ocrfeeder
#装好后，如果程序打不开的话，用管理员身份用编辑器打开/usr/share/applications/ocrfeeder.desktop文件， 将其中“exec=ocrfeeder -i %f”中后面的参数“-i %f”去掉，然后保存就能打开了。要想识别中文，有一个重要的更改需要做，要将软件工具中的OCR引擎编辑项中把“zh:chi-sim”改为“zh:chi_sim”




