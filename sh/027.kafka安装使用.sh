canal使用zookeeper，kafka也使用zookeeper，使用kafka的时候要用kafka的端口 cc1:9092,cc2:9092,cc3:9092
kafka-console-producer --broker-list localhost:9092 --topic k1
kafka-console-consumer --bootstrap-server cc1:9092,cc2:9092,cc3:9092 --topic k1

#启动kafka
kafka-server-start.sh /root/kafka/config/server.properties > kafka.log 2>&1 &


#看kafka的topic
kafka-topics --bootstrap-server cc1:9092,cc2:9092,cc3:9092 --list

#删除topic
kafka-topics --bootstrap-server localhost:9092 --delete topicmysql506

#如果在cdh中更换kafka的服务器的话，会引起topic中的分区丢失，尽量不要在运行中进行服务器调整。
#如果调整后报 Kafka Broker Offline Partitions Test:There are 210 offline partitions 错误，需要在zookeeper中删除kafka的topic记录
/opt/cloudera/parcels/CDH/lib/zookeeper/bin/zkCli.sh -server cc3:2181,cc7:2181,cc8:2181
rmr /brokers/topics

#数据保存时间，默认是7天
Data Retention Hours
log.retention.hours

但是有的时候我们需要对某一个主题的消息存留的时间进行变更，而不影响其他主题。
可以使用命令：
kafka-configs.sh –zookeeper localhost:2181 –entity-type topics –entity-name topicName –alter –add-config log.retention.hours=120
使得主题的留存时间保存为5天
如果报错的话，可以将时间单位更改成毫秒：
kafka-configs.sh –zookeeper localhost:2181 –entity-type topics –entity-name test –alter –add-config retention.ms=43200000





