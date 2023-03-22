create user 'etluser'@'%' identified by 'FT!9Otzov#wi4w1!';
CREATE DATABASE IF NOT EXISTS yourdbname DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
grant all privileges on  *.* to 'root'@'localhost';
use predict ;
grant all privileges on *.* to 'etluser'@'%' ;
FLUSH   PRIVILEGES; 

--改密码
update mysql.user set authentication_string=password('新密码') where user='用户名' and Host ='localhost';
flush privileges ;
























