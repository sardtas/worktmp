
#------------------centos安装----------------------
curl https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo > /etc/yum.repos.d/mssql-server.repo

yum makecache
yum upgrade
yum install java-1.8.0-openjdk
yum install pciutils -y
yum install -y mssql-server
sudo /opt/mssql/bin/mssql-conf setup 


#更新huawei源
sed -i "s/#baseurl/baseurl/g" /etc/yum.repos.d/CentOS-Base.repo
sed -i "s/mirrorlist=http/#mirrorlist=http/g" /etc/yum.repos.d/CentOS-Base.repo
sed -i "s@http://mirror.centos.org@https://mirrors.huaweicloud.com@g" /etc/yum.repos.d/CentOS-Base.repo

#安装 2019
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2019.repo
yum install -y mssql-server
/opt/mssql/bin/mssql-conf setup
systemctl status mssql-server

firewall-cmd --zone=public --add-port=1433/tcp --permanent
firewall-cmd --reload

#安装命令行工具
curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/8/prod.repo
yum remove unixODBC-utf16 unixODBC-utf16-devel
yum install -y mssql-tools unixODBC-devel

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

#连接
sqlcmd -S localhost -U SA -P '<YourPassword>'


apt-get install software-properties-common
#------------------ubuntu 18.04 安装 ---------------------
#导入公共存储库 GPG 密钥：
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#为 SQL Server 2019 注册 Microsoft SQL Server Ubuntu 存储库：
add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"
#运行以下命令以安装 SQL Server：
apt-get update
apt-get install -y mssql-server
#包安装完成后，运行 mssql-conf setup，按照提示设置 SA 密码并选择版本。
/opt/mssql/bin/mssql-conf setup
#请确保为 SA 帐户指定强密码（最少 8 个字符，包括大写和小写字母、十进制数字和/或非字母数字符号）。
#完成配置后，验证服务是否正在运行：
systemctl status mssql-server --no-pager












