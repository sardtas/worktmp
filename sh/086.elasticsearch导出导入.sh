vim /etc/security/limits.conf
* soft nofile 65536
* hard nofile 65536


编辑 /etc/sysctl.conf，追加以下内容：
vm.max_map_count=655360 要大于262144
保存后，执行：
sysctl -p

#多个
bin/elasticsearch -E node.name=node0 -E cluster.name=bies -E path.data=node0_data -d
bin/elasticsearch -E node.name=node1 -E cluster.name=bies -E path.data=node1_data -d
bin/elasticsearch -E node.name=node2 -E cluster.name=bies -E path.data=node2_data -d

nohup /data/elastic_search/kibana-7.12.0-linux-x86_64/bin/kibana>/data/elastic_search/kibana-7.12.0-linux-x86_64/kibana.log 2>&1 &

#有用的 logstash
vim school-events-all-load-logstash.conf 
/data/elastic_search/logstash-7.12.0/bin/logstash -f /data/elastic_search/es_data_load/school-events-all-load-logstash.conf


#查配置 ip:port/index/_settings
curl -XGET http://localhost:9200/_settings
curl -XGET http://localhost:9200/logstash-warning-send/_settings

#设置索引最大返回条数
curl -XPUT http://localhost:9200/_settings -d '{ "index.max_result_window" :"200000000"}' -H "Content-Type: application/json"
curl -XPUT http://localhost:9200/logstash-warning-send/_settings -d '{ "index.max_result_window" :"200000000"}' -H "Content-Type: application/json"
#服务器上默认使用ipv6，直接用localhost不通。
curl -XPUT http://10.111.114.21:9200/logstash-school-events/_settings -d '{ "index.max_result_window" :"200000000"}' -H "Content-Type: application/json"



#对索引做调整
#去掉备份索引
curl -XPUT http://localhost:9200/_settings?pretty -d '{ "index": { "number_of_replicas": 0 } }' -H "Content-Type: application/json"

#加别名
curl -H "Content-Type: application/json" -XPOST 'http://localhost:9200/_aliases' -d '
    {
        "actions": [
            {"add": {"index": "logstash-selleras-yibi-records", "alias": "selleras-yibi-records"}}
        ]
    }'


#es查询
GET selleras-yibi-records/_search
{
 "query": {
   "match": {
     "flow_direction": "in"
   }
 }
  
}


#按条件删除数据
curl -X POST "http://localhost:9200/logstash-school-events/_delete_by_query" -m 3600 -H 'Content-Type: application/json' -d"${json_str}" 
#删除后只是标记，实际删除
curl -X POST "http://localhost:9200/logstash-school-events/_forcemergeonly_expunge_deletes=true"  -H 'Content-Type: application/json'


curl -X DELETE "localhost:9200/logstash-school-events"

/opt/logstash/bin/logstash -f /home/yangyong/work/bak/es/es_pc33/logstash-school-enent-template.json
/opt/logstash/bin/logstash -f /home/yangyong/work/bak/es/es_pc33/school-events-all-load-logstash.conf





#查询

GET custas-yibi-records/_search
{
 "query": {
   "match": {
     "flow_direction": "in"
   }
 }
  
}
------------------------------------------------------

GET custas-yibi-records/_search
{
  "from": 0, 
  "size": 20,   
  "sort": [
    {
       "id": "desc"     
    }
  ], 
  "query": { 
    "bool":{
      "must": [
        {
          "match": {
     		"schoolid": "478786"
		  }
        }, 
        {
          "match": {
     		"ruleid": "111"
		  }
        }

      ]
    }
  }
}



------------------------------------------------------





tmp_json_str='
{
  "query": { 
    "bool":{
      "filter": [
        {
          "range": {
            "event_time": {
                "gte": "2017-01-01 00:00:00",
                "lt": "2019-01-01 00:00:00",
                "format": "yyyy-MM-dd HH:mm:ss",
                "time_zone": "+08:00"
            }
          }
        }
      ]
    }
  }
}
'

tmp_json_str='
{
  "query": { 
    "bool":{
      "filter": [
        {
          "terms": {
            "event_type":["20"]
          }
        }
      ]
    }
  }
}
'
curl -X POST "http://10.111.114.21:9200/logstash-school-events/_delete_by_query" -m 3600 -H 'Content-Type: application/json' -d"${tmp_json_str}" 


/data/elastic_search/logstash-7.12.0/bin/logstash -f /data/elastic_search/es_data_load/school-events-all-load-logstash.conf

curl -X POST "http://localhost:9200/logstash-school-events/_delete_by_query" -m 3600 -H 'Content-Type: application/json' -d"${tmp_json_str}" 




#解压es后配置一下其他机器的访问 
network.host: 0.0.0.0

#安装监测工具metricbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.9.2-linux-x86_64.tar.gz
tar xzvf metricbeat-7.9.2-linux-x86_64.tar.gz
#看有什么模块
./metricbeat modules list
#开启模块
./metricbeat modules enable apache mysql
./metricbeat modules enable elasticsearch-xpack
#得把metricbeat.yml的用户改为root，要启哪个模块，哪个配置也得改root
chown root:root modles.d/linux.yml
chown root:root modles.d/elasticsearch.yml
chown root:root modles.d/elasticsearch-xpack.yml

#配置一下
./metricbeat setup -e
#用root开启
sudo chown root metricbeat.yml 
sudo chown root modules.d/system.yml 
sudo ./metricbeat -e



#安装elasticdump
sudo npm install -g elasticdump

#从pg导数据
multicorn


导出 
// 导出 index 的 mapping 到 .json 文件
elasticdump \
  --input=http://production.es.com:9200/my_index \
  --output=/data/my_index_mapping.json \
  --type=mapping
// 导出 index 的所有数据到 .json 文件
elasticdump \
  --input=http://production.es.com:9200/my_index \
  --output=/data/my_index.json \
  --type=data

elasticdump --input=http://localhost:9200/my_index --output=/work/tmp/44.json --type=data


导入
// 从 .json 文件导入 templates 到 ES 
elasticdump \
  --input=./templates.json \
  --output=http://es.com:9200/my_index \
  --type=template

elasticdump --input=/work/tmp/33.json --output=http://localhost:9200/al1 --type=template


curl -X GET  "bi03:9200/logstash-school-events/doc/1"

curl -X PUT  "localhost:9200/sales_log_index_new"
curl -X DELETE "localhost:9200/sales_log_index_new"

curl  -H "Content-Type: application/json" -X PUT 'localhost:9200/sales_log_index_new/doc/1' -d '
{
  "mappings": {
    "_doc": {      
        "sellerId": { "type": "text"},
        "sellerName": {  "type": "text"  },
        "systemName": {   "type": "text"  }
      }
    }  
}'

curl  -H "Content-Type: application/json" -X PUT 'localhost:9200/sales_log_index_new/doc/1' -d '
{"sellerId" : "xy03725",
          "sellerName" : "杨婷",
          "systemName" : "销售系统",
          "usedTime" : 63
}'

 curl -H "Content-Type: application/json"  -X PUT 'localhost:9200/aaa/tt1' -d '
{
  "user": "张三",
  "title": "工程师",
  "desc": "数据库管理"
}' 


curl -H "Content-Type: application/json" -XPOST 192.168.14.173:32000/test_index_1221/test_type/5 -d '{'user_name':"xiaoming"}'





curl  -H "Content-Type: application/json" -X PUT 'localhost:9200/sales_log_index_new9/_doc/6' -d '
 {
          "className" : "ModuleController",
          "methodName" : "menu",
          "methodParameter" : [
            {
              "value" : "31",
              "key" : "parentId"
            },
            {
              "value" : "1",
              "key" : "platform"
            }
          ],
          "nodeName" : "node-9999",
          "operateName" : "我的菜单",
          "remoteAddress" : "10.1.1.89",
          "requestParameter" : [
            {
              "value" : "31",
              "key" : "parentId"
            },
            {
              "value" : "1",
              "key" : "platform"
            },
            {
              "value" : "1600303580645",
              "key" : "_t"
            }
          ],
          "requestTime" : "2020-09-12 08:46:18",
          "requestURI" : "/api/module/menu",
          "response" : {
            "code" : 500,           
            "message" : "成功"
          },
          "sellerId" : "xy03725",
          "sellerName" : "杨婷",
          "systemName" : "销售系统",
          "usedTime" : 6113,
          "userAgent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36"
        }
'



#删除数据 
$ curl  -X POST "localhost:9200/selleras-yibi-records/_delete_by_query?pretty" \
  -H 'Content-Type:application/json' \
  -d '{
"query": {
"match_all":{}
 }
}'
