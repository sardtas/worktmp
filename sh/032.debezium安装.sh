/*****这个不用了，装debezium的时候太麻烦，因为各组件装在不同的机器上，而且组件装在哪个位置也不知道，本地启动也无法启动。
#confluent docker安装
git clone https://github.com/confluentinc/examples
cd examples
git checkout 5.3.1-post
cd cp-all-in-one/
docker-compose up -d --build
docker-compose ps

#看一下，如果都up了，就好了，如果还有没up的，docker-compose up -d
#访问本地的9021端口就可以看到页面了
http://localhost:9021/
#将下载好的devezium的几个包放到docker 的 cnfldemos/kafka-connect-datagen 中的/usr/share/confluent-hub-components 下

*******************/

#配置jdk8 增加jdk8的java_home 和 path 
cd
vim .bashrc

#下载confluent包，解压后修改bin下的confluent
tar -zxf confluent-5.2.3-2.11.tar.gz 
ln -s confluent-5.2.3 confluent
vim confluent/bin/confluent
#在最开始增加下面这句话
export CLASSPATH=/root/confluent/share/java/debezium-connector-mysql/*.jar;/root/confluent/share/java/debezium-connector-postgres/*.jar;/root/confluent/share/java/debezium-connector-sqlserver/*.jar;$CLASSPATH
#将几个debezium的包放到confluent/share/java下
cd /confluent/share/java
tar -zxf /root/debezium-connector-mysql-0.9.5.Final-plugin.tar.gz
tar -zxf /root/debezium-connector-postgres-0.9.5.Final-plugin.tar.gz
tar -zxf /root/debezium-connector-sqlserver-0.9.5.Final-plugin.tar.gz

#mysql 的连接用户还需要一个reload权限
mysql
grant reload on *.* to 'dc'@'%';

#启动confluent
/root/confluent/bin/confluent start
#访问页面 
http://localhost:9021
#在kafka-connect中增加数据库的监控 mysql 和 postgresql都可以增加，sqlserver在增加页面上有很多项没有，增加后无法正常读取数据，需要使用url增加
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://172.17.1.2:8083/connectors/  -d '{"name": "sqlserver507", "config": {"connector.class" : "io.debezium.connector.sqlserver.SqlServerConnector",        "tasks.max" : "1", "database.server.name" : "sqlserver1", "database.hostname" : "172.16.189.141","database.port" : "1433", "database.user" : "dc","database.password" : "dc","database.dbname" : "dc","database.history.kafka.bootstrap.servers" : "172.17.1.2:9092","database.history.kafka.topic": "sqlserver507topic" }}'

curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://172.17.0.4:8083/connectors/  -d '{"name": "sqlserver507", "config": {"connector.class" : "io.debezium.connector.sqlserver.SqlServerConnector",        "tasks.max" : "1", "database.server.name" : "sqlserver1", "database.hostname" : "172.16.189.141","database.port" : "1433", "database.user" : "dc","database.password" : "dc","database.dbname" : "dc","database.history.kafka.bootstrap.servers" : "172.17.0.4:9092","database.history.kafka.topic": "sqlserver507topic"}}'



#url 启动mysql的cdc消费
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://172.17.0.4:8083/connectors/  -d '{"name":"mysql-connector","config": { "connector.class": "io.debezium.connector.mysql.MySqlConnector",     "database.hostname": "172.17.1.3", "database.port": "3306", "database.user": "dc", "database.password": "dc",  "database.server.id": "100",  "database.server.name": "m56",  "database.history.kafka.bootstrap.servers": "172.17.0.4:9092",  "database.history.kafka.topic": "dbhistory.inventory" , "include.schema.changes": "true" }}'

"transforms": "unwrap,changetopic", "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope", "transforms.changetopic.type":"org.apache.kafka.connect.transforms.RegexRouter", "transforms.changetopic.regex":"(.*)",  "transforms.changetopic.replacement":"$1-smt" 


#使用kafka可以看到监控到的信息
/root/confluent/bin/kafka-console-consumer --bootstrap-server localhost:9092 --topic sqlserver507topic


#如果要测试，可以使用本地文件启动：
#建一个mysql.properties的文件，内容如下：
name=mysql-connector
connector.class=io.debezium.connector.mysql.MySqlConnector
database.hostname=172.17.1.3
database.port=3306
database.user=dc
database.password=dc
database.server.id=100
database.server.name=m56 
database.whitelist=dc.duser
database.history.kafka.bootstrap.servers=172.17.1.2:9092
database.history.kafka.topic=dbhistory.debezium1
include.schema.changes=true

transforms=unwrap,changetopic
transforms.unwrap.type=io.debezium.transforms.UnwrapFromEnvelope
transforms.changetopic.type=org.apache.kafka.connect.transforms.RegexRouter
transforms.changetopic.regex=(.*)
transforms.changetopic.replacement=$1-smt

#使用本地单机启动
bin/connect-standalone.sh config/connect-standalone.properties mysql.properties





#使用ksql 必须有主键才能用。
create table b ( a int, b int, c varchar) with (kafka_topic='sqlserver1.dbo.b', value_format='JSON', key='a');
CREATE TABLE users_original (registertime BIGINT, gender VARCHAR, regionid VARCHAR, userid VARCHAR) WITH \
(kafka_topic='users', value_format='JSON', key = 'userid');


create table xuser ( userid int, username varchar  ) with (kafka_topic='topicmysql506', value_format='JSON', key='key');


create table duser ( userid int, username varchar(64) , loginname varchar(64) , schoolid int, isinit int ,
 inittime timestamp , isdeleted int, deletetime timestamp, createtime timestamp , etl_status varchar(10),
etl_date date ) with (kafka_topic='topicmysql506', value_format='JSON', key='key');




{"name": "userid", "type": "int"},
{"name": "username",  "type": "string"},
{"name": "loginname", "type": "string"},
{"name": "schoolid", "type": "int"},
{"name": "isinit", "type": "int"},
{"name": "inittime", "type": "string"},
{"name": "isdeleted", "type": "string"},
{"name": "deletetime", "type": "string"},
{"name": "createtime", "type": "string"},
{"name": "etl_status", "type": "string"},
{"name": "etl_date", "type": "string"}

userid int NOT NULL PRIMARY KEY , -- 用户ID
	username varchar(64) NULL, -- 用户名
	loginname varchar(64) NULL, -- 登录名
	schoolid int NULL, -- 学校ID
	isinit bool NULL, -- 是否初始化
	inittime timestamp NULL, -- 初始化时间
	isdeleted bool NULL, -- 是否已删除
	deletetime timestamp NULL, -- 删除时间
	createtime timestamp NOT NULL, -- 创建时间
	etl_status varchar(1) NULL,
	etl_date date NULL


#必须先执行这个一次，要不schema不能更改，有改动以后就一直报错无法使用
#这个是向前还是向后支持的，如果schema registry的数据定义有过修改，它会自动检测是否兼容，不兼容就不让改。把这个改成none后就不检测了。
curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
--data '{"compatibility": "NONE"}' \
http://172.17.0.7:8081/config

#java用，全string
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
--data '{"schema": "{\"type\": \"record\", \"name\": \"ve_topicmysql506\", \"fields\": [{\"name\": \"userid\", \"type\": \"int\"}, {\"name\": \"username\",  \"type\": \"string\"},{\"name\": \"loginname\",  \"type\": \"string\"}, {\"name\": \"schoolid\",  \"type\": \"int\"},  {\"name\": \"isinit\", \"type\": \"int\"},{\"name\": \"inittime\",  \"type\": \"string\"},{\"name\": \"isdeleted\",  \"type\": \"string\"},{\"name\": \"deletetime\",  \"type\": \"string\"},{\"name\": \"createtime\",  \"type\": \"string\"},{\"name\": \"etl_status\",  \"type\": \"string\"},{\"name\": \"etl_date\",  \"type\": \"string\"},{\"name\": \"ttti111\",  \"type\": \"string\"},{\"name\": \"ttti112\",  \"type\": \"string\"}]}"}' \
http://172.17.0.7:8081/subjects/topicmysql506/versions

#schema registry的数据不支持时间格式，只能用long型，如果数据中有null的情况，要在定义中写[\"null\", \"long\"] 这种。
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
--data '{"schema": "{\"type\": \"record\", \"name\": \"ve_topicmysql506\", \"fields\": [{\"name\": \"userid\", \"type\": \"int\"}, {\"name\": \"username\",  \"type\": \"string\"},{\"name\": \"loginname\",  \"type\": [\"null\", \"string\"]}, {\"name\": \"schoolid\",  \"type\": [\"null\", \"int\"]},  {\"name\": \"isinit\", \"type\": \"int\"},{\"name\": \"inittime\",  \"type\": \"long\"},{\"name\": \"isdeleted\",  \"type\": \"int\"},{\"name\": \"deletetime\",  \"type\": [\"null\", \"long\"]},{\"name\": \"createtime\",  \"type\": \"long\"},{\"name\": \"etl_status\",  \"type\": \"string\"},{\"name\": \"etl_date\",  \"type\": \"long\"},{\"name\": \"ttti111\",  \"type\": \"string\"},{\"name\": \"ttti112\",  \"type\": \"string\"}]}"}' \
http://172.17.0.7:8081/subjects/topicmysql506/versions




curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
--data '{"compatibility": "NONE"}' \
http://172.17.0.7:8081/config



# Deletes all schema versions registered under the subject "Kafka-value"
  curl -X DELETE http://172.17.0.7:8081/subjects/topicmysql506


# Deletes version 1 of the schema registered under subject "Kafka-value"
  curl -X DELETE http://172.17.0.7:8081/subjects/topicmysql506/versions/1


# Deletes the most recently registered schema under subject "Kafka-value"
  curl -X DELETE http://172.17.0.7:8081/subjects/topicmysql506/versions/latest








