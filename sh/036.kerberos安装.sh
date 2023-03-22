#主要参考以下安装过程：
https://blog.csdn.net/lovebomei/article/details/79807484



yum -y install ntp
rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #修改时区
yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common #安装中文支持
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

#在主机上
yum install krb5-server krb5-libs krb5-auth-dialog vim 
 /var/kerberos/krb5kdc/kdc.conf

#修改默认 管理域 ， 
示例：
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 XKW.COM = {
  #master_key_type = aes256-cts
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }

#修改krb5设置
vim /etc/krb5.conf
示例：
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 pkinit_anchors = /etc/pki/tls/certs/ca-bundle.crt
 default_realm = XKW.COM
 default_ccache_name = KEYRING:persistent:%{uid}

[realms]
 XKW.COM = {
  kdc = kc1
  admin_server = kc1
 }

[domain_realm]
 .xkw.cn = XKW.COM
 xkw.cn = XKW.COM


#初始化，同时配置一个密码 uat123
/usr/sbin/kdb5_util create -s -r XKW.COM

/usr/sbin/kadmin.local -q "addprinc admin/admin"

#调整权限
vim /var/kerberos/krb5kdc/kadm5.acl

#启动
systemctl start krb5kdc
systemctl start kadmin


kadmin.local
xst -k /xxx/xxx/kerberos.keytab hdfs/hadoop1


#在需要使用kerberos的机器上安装
yum install -y krb5-workstation krb5-libs krb5-auth-dialog krb5-devel openldap-clients



[domain_realm]
 cc1 = XKW.COM
 cc2 = XKW.COM
 cc3 = XKW.COM
 cc4 = XKW.COM
 cc5 = XKW.COM
 cc6 = XKW.COM
 cc7 = XKW.COM
 cc8 = XKW.COM
 cc9 = XKW.COM
 kdc = XKW.COM


cdh/cdh123456









