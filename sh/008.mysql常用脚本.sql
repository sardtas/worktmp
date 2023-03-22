1.创建用户:
# 指定ip：192.118.1.1的mjj用户登录
create user 'mjj'@'192.118.1.1' identified by '123';
# 指定ip：192.118.1.开头的mjj用户登录
create user 'mjj'@'192.118.1.%' identified by '123';
# 指定任何ip的mjj用户登录
create use 'mjj'@'%' identified by '123';
2.删除用户
drop user '用户名'@'IP地址';
3.修改用户
rename user '用户名'@'IP地址' to '新用户名'@'IP地址';
4.修改密码
set password for '用户名'@'IP地址'=Password('新密码');
#查看权限
show grants for '用户'@'IP地址'
#授权
grant select ,insert,update on db1.t1 to "mjj"@'%';
# 表示有所有的权限，除了grant这个命令，这个命令是root才有的。
grant all privileges  on db1.t1 to "mjj"@'%';
#取消权限
取消来自远程服务器的mjj用户对数据库db1的所有表的所有权限
revoke all on db1.* from 'mjj'@"%";  
取消来自远程服务器的mjj用户所有数据库的所有的表的权限
revoke all privileges on '*' from 'mjj'@'%';

# 备份：数据表结构+数据
mysqdump -u root db1 > db1.sql -p
# 备份：数据表结构
mysqdump -u root -d db1 > db1.sql -p
#导入现有的数据到某个数据库
#1.先创建一个新的数据库
create database db10;
# 2.将已有的数据库文件导入到db10数据库中
mysqdump -u root -d db10 < db1.sql -p


--创建测试表
create table test(
	id int;
);

--add支持多列，change/drop需要在每列前添加关键字，逗号隔开，'column'可有可无

--添加多列
alter table test add (c1 char(1),c2 char(1));	--正确，add支持多列
alter table test add column (c1 char(1),c2 char(1));	--正确
alter table test add c1 char(1),add c2 char(1);		--正确

--修改多列
alter table test change c1 c3 char(1),change c2 c4 char(1);		--正确
alter table test change column c1 c3 char(1),change column c2 c4 char(1);		--正确
--name关键字作为字段名，重命名需要加反引号(`)
alter table table_name change `name` field_name varchar(50);

alter table test change (c1 c3 char(1),c2 c4 char(1));		--错误

--删除多列
alter table test drop c1,drop c2;	--正确
alter table test drop column c1,drop column c2;		--正确

alter table test drop c1,c2;	--错误
alter table test drop (c1,c2);	--错误


【Mysql的bin目录】\mysql –u用户名 –p密码 –D数据库<【sql脚本文件路径全名】，示例：
C:\MySQL\bin\mysql –uroot –p123456 -Dtest<C:\test.sql
Mysql>source 【sql脚本文件的路径全名】 或 Mysql>\. 【sql脚本文件的路径全名】，示例：
source C:\test.sql 或者 \. C:\test.sql
打开 MySQL Command Line Client，输入数据库密码进行登录，然后使用 source 命令或者 \.



--建库 建用户
CREATE DATABASE dc DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

GRANT ALL ON dc.* TO 'dc'@'%' IDENTIFIED BY 'dc';

--给用户建立备份库 或 cdc同步数据的权限 
alter user dc with replication;
--在有的版本上边这个语句不好用。
grant replication slave on *.* to 'dc'@'%' ;
--使用sdc同步数据时要给replication client的权限，注意on dc.* 是在什么库上给这个权限
grant replication client on *.* to 'dc'@'%' ;

--看cdc日志 log binlog 
show binary logs;
show binlog events in 'mysql-bin.000001';









