confluent schema registry 是一个单独的服务，并不在kafka上，以下简称csr。通过url访问可以对csr进行设置。
csr的设置并不会影响kafka，kafka的写入读取都和以前是一样的。只有在使用了csr的程序在生产和消费过程中才起作用。
比如设置了一个topic的sr，使用kafka或使用streamsets对这个topic写入不符合规则的数据可以成功。使用一般程序也可以拿到数据。但使用sr程序(avro格式)去消费这个数据会出错。
streamsets中写入kafka数据时可以选择csr方式。
使用csr生产和消费的数据必须严格匹配字段，多了少了都会报错。

#必须先执行这个一次，要不schema不能更改，有改动以后就一直报错无法使用
#这个是向前还是向后支持的，如果schema registry的数据定义有过修改，它会自动检测是否兼容，不兼容就不让改。把这个改成none后就不检测了。
curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
--data '{"compatibility": "NONE"}' \
http://172.17.0.7:8081/config

#schema registry的数据不支持时间格式，只能用long型，如果数据中有null的情况，要在定义中写[\"null\", \"long\"] 这种。
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
--data '{"schema": "{\"type\": \"record\", \"name\": \"ve_topicmysql506\", \"fields\": [{\"name\": \"userid\", \"type\": \"int\"}, {\"name\": \"username\",  \"type\": \"string\"},{\"name\": \"loginname\",  \"type\": [\"null\", \"string\"]}, {\"name\": \"schoolid\",  \"type\": [\"null\", \"int\"]},  {\"name\": \"isinit\", \"type\": \"int\"},{\"name\": \"inittime\",  \"type\": \"long\"},{\"name\": \"isdeleted\",  \"type\": \"int\"},{\"name\": \"deletetime\",  \"type\": [\"null\", \"long\"]},{\"name\": \"createtime\",  \"type\": \"long\"},{\"name\": \"etl_status\",  \"type\": \"string\"},{\"name\": \"etl_date\",  \"type\": \"long\"},{\"name\": \"ttti111\",  \"type\": \"string\"},{\"name\": \"ttti112\",  \"type\": \"string\"},{\"name\": \"news\",  \"type\": [\"null\", \"string\"]}]}"}' \
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






