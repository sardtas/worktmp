默认的下载版中没有greenplum的写入，用这个git编译版带这个。

git clone git@github.com:alibaba/DataX.git
mvn -U clean package assembly:assembly -Dmaven.test.skip=true

执行过程中报错，看一下odpswriter下的pom.xml 和odpswriter/pom.xml
 <dependency>
			<groupId>com.aliyun.odps</groupId>
			<artifactId>odps-sdk-core</artifactId>
			<version>0.19.3-public</version>
		</dependency>
要将版本修改一下
<version>0.20.7-public</version>
	
编译成功后在target/datax-v1.0.3-hashdata下有个datax，在这个datax的bin目录下执行以下脚本。注意使用python 2代。
python2 datax.py -r postgresqlreader -w gpdbwriter

执行后会打印出一段json文件，将这个文件写到一个文本中，修改其中的参数后另存为 需要使用的名字.json， 然后用 python2 datax.py 需要使用的名字.json 来执行。
!!默认生成的json文件中，postgresql读取中没有column选项，但没有这一项就会报错，需要手动加上"column": ["*"], 这个github上的说明也不对，说是如果需要所有字段就写成"column": [""], 写成什么也没有也会报错。 最后的"channel": "1"这里需要一个数字型的值。

{
    "job": {
        "content": [
            {
                "reader": {
                    "name": "postgresqlreader", 
                    "parameter": {
		    	"column": ["*"], 
                        "connection": [
                            {
                                "jdbcUrl": ["jdbc:postgresql://10.1.1.82:58000/dc"], 
                                "table": ["bi_adm.a_res_soft_info"]
                            }
                        ], 
                        "password": "dc123456", 
                        "username": "dc"
                    }
                }, 
                "writer": {
                    "name": "gpdbwriter", 
                    "parameter": {
                        "column": ["id","softid","softname","resource_source","subject_type","period_type","grade_type", "version_type","soft_type","soft_point","soft_advpoint","soft_money","add_date","is_del","first_download_date","is_valid","system_source", "etl_status","etl_date","areaid"], 
                        "connection": [
                            {
                                "jdbcUrl": "jdbc:postgresql://172.17.0.3:15432/dlwdb", 
                                "table": ["bi_adm.a_res_soft_info"]
                            }
                        ], 
                        "password": "cyj", 
                        "postSql": [], 
                        "preSql": [], 
                        "segment_reject_limit": 0, 
                        "username": "cyj"
                    }
                }
            }
        ], 
        "setting": {
            "speed": {
                "channel": "1"
            }
        }
    }
}



