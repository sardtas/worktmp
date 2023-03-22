#weave的安装
curl -L git.io/weave -o /usr/local/bin/weave
chmod a+x /usr/local/bin/weave
weave version   
weave launch

#在主机1上
docker run --name cc1 -h cc1 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
weave attach 3.3.3.2/24 cc1

#在主机2上
docker run --name cc2 -h cc2 --privileged=true -itd centos:7.6.1810 /usr/sbin/init
weave attach 3.3.3.2/24 cc1

#从主机1上连主机2的ip
weave connect 10.1.1.121

!!docker镜像重启后需要重新绑定！！

#在主机上访问设定后的ip， 在自己的主机上也得安这个才能访问这个网络。
weave expose 3.3.3.1/24



#docker machine不知道有什么用，好像是建一个带docker功能的docker主机。
docker-machine需要使用virtualbox，所以得先安装virtualbox，centos没看怎么安装，ubuntu可以直接装。
apt-get install linux-generic linux-image-generic linux-headers-generic linux-signed-generic
apt-get install virtualbox

curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine


