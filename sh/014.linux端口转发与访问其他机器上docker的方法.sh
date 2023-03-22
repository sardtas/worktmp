#linux的ssh可以根据端口转发访问请求，相当于一个中转站。比如有三台服务器a, b, c ，a和c互相之间不能连通，但a和b，b和c之间可以连通，这时可以使用b做中转站。
在a上执行 ssh -L 8080:c:80 -N b 即可将a的8080端口转向c的80端口，a和与a在同一网段内的机器都可以通过a:8080来访问实际的c:80的服务。
这个命令是在a上执行一个ssh连接，连接到b，然后通过b来转发到c，上边这个命令会需要输入密码，并保持一个登录了b的窗口，这个窗口不能关，关了就不能转发了。
如果a上用的用户和登录b的用户不一样，还要在b前边加上 用户名@b
为了不用单独总开一个窗口，可以在a到b建立一个免密登录，在a和b上执行ssh-keygen，然后把a的.ssh/id_rsa.pub考到b的.ssh下，并导入authorized_keys里，再在命令的最后加上 &即可。
 ssh -L 8080:c:80 -N b &
这样就可以关闭窗口了。
ssh的反向连接还可以用于在家里连接公司的电脑。


#docker是建立在某台主机的虚拟网络下的，这个虚拟网络从其他机器无法访问，有时候使用起来很麻烦，比如在docker上建立了hadoop集群，要看hadoop的网页ui，就得用ssh一个端口一个端口的映射，或是在一台linux主机上使用ssh -X 连接到有docker的主机，再在命令行里启动firefox。
#后来在测试cdh集群时，单台机器的内存不足以启动很多个docker虚拟机，就尝试是否可以将docker的ip放到局域网，尝试了半天似乎不行，指定了ip后无法连接其他机器，有可能是局域网的路由有限制。最后想到可以使用linux作为路由来转发地址。
#docker的默认网段是172.17.0.1/24，docker的ip又是自动获得，所以需要将各主机的docker网段分开，比如两台主机a和b，a的地址不动，将b上docker的默认地址改为172.17.1.1/24
#先关闭docker服务，修改后再启动
service docker stop
vim /etc/docker/daemon.json
{
  "debug" : false,
  "default-address-pools" : [
    {
      "base" : "172.17.1.0/24",
      "size" : 24
    }
  ]
}
service docker start

#这样b上的docker网段就变为172.17.1.1/24了，然后开启a和b的转发，增加route指向，并关闭
#临时生效
echo "1" > /proc/sys/net/ipv4/ip_forward
#永久生效的话，需要修改sysctl.conf，将ipv4转发前面的注释符号#去掉
vim /etc/sysctl.conf
net.ipv4.ip_forward = 1
#清除所有的iptables规则 iptables -F	
#允许接收
iptables -P INPUT ACCEPT	
#允许发送数据包
iptables -P FORWARD ACCEPT	
#iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth1 -j MASQUERADE //MASQUERADE方式配置nat
#iptables-save > /etc/sysconfig/iptables

#在b上执行
route add -net 172.17.0.0/24 gw a(a的ip)
#在a上执行
route add -net 172.17.1.0/24 gw b(b的ip)

#如果是windows的话，得用下面这个命令
route add 172.17.0.0 mask 255.255.255.0 a(a的ip)

#看route信息的话，linux上用 route， windows上用 route print

































