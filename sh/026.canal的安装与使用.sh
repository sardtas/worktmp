#mysql的binlog中记录了Mysql的操作，记录的方式是 数据 操作， {"data":[{"apk":4,"b":"2"}],"database":"dc","destination":"example","es":1566799743000,"groupId":null,"isDdl":false,"old":null,"pkNames":["apk"],"sql":"","table":"d","ts":1566799743572,"type":"INSERT"}
#数据中会把这一条数据的所有字段都记录下来，最后有一个记录是insert 或 update 或 delete ， 对于数据库中的实际操作语句并不能体现出来。canal的配置文件中必须设置一个主键，canal对目标数据库的操作会根据这个设置的主键来进行，比如配置了softid为主键，对于update和delete都会把softid作为where 条件来执行语句。
#这就要求源库的表如果有数据的更新或删除，则必须有一个唯一的不重复的列（可以不是主键），也可以是类似于复合主键的多个列的组合。而目标端也要有对应的列，列名可以不一样，在配置文件中可以指定。
#canal并不能校验同步，只是把源端的语句拿到目标端执行一下，比如因某些原因导致了源表与目标表数据不一致，这时源表执行update操作，而操作的这条数据在目标表中不存在，这时不会报错，目标数据库中会执行update语句，但更改的行数为0,这条数据是不会进入到目标表的。
#canal的数据监控端deployer可以配置到zookeeper上做负载。数据消费端adapter也可以启动多个，读取zookeeper上的内容，如果两个adapter配置了一样的内容，只会有一个会进行读取，另一个处于等待，数据不会出现重复。若想使用多个数据消费端，则需要配置多个instance,每个instance可以对应一个消费端。

!!canal可以读取到表的ddl变化，但不会在目标端执行，目前暂时未提供ddl的功能，只支持insert update delete。
!!canal同步的表都是可以没有主键的，但建议使用主键，这样可以更好的保证数据一致性，同时目标端的表一定要根据配置的targetPK建主键或索引，否则update或delete时性能极低，会直接影响同步效率。
!!truncate 表属于ddl语句，是不会同步的。源系统不能使用truncate，这样会导致后续的同步出问题。
!!canal默认使用utf8mb4从Mysql读取数据，在测试中由于目标库默认是ascII编码，插入数据时报错，长度不够，很快会导致了canal内存溢出，内存溢出后会不停尝试回收内存，cpu使用达到100%，程序不会退出，数据不再插入。修复问题后重新启动adapter，程序从之前错误处开始插入。
!!mysql与postgresql的数据类型对应比较吻合，sqlserver中由于没有boolean类型，mysql中的boolean型在同步时需要进行处理，sqlserver中使用bit来记录布尔型。

canal目前支持的mysql版本包括5.5、5.6、5.7、8.0，官方说明文档中说4.X版本也是支持的，只是进行了简单的测试。

#canal安装 https://github.com/alibaba/canal/wiki/QuickStart
jdk1.6以上版本即可支持canal，为了通用性，建议使用jdk1.8
#canal-canal包是解析binlog日志用的，解压后通过配置即可使用。一定要先建一个目录再进入目录后解压，这个项目在打包时是把项目中的东西直接打包的，解压时不是一个文件夹
mkdir canal
cd canal
tar -zxf ../canal.deployer-1.1.3.tar.gz

conf/canal.properties 配置总体属性，基本不用改动。
conf/example文件夹下是配置要监控哪个数据库的，通过 cp -r example mysqla 来复制一份配置文件，再修改mysqla/instance.properties来配置，配置完成后在修改一下canal.properties中的canal.destinations = example
instance中主要改以下三项：
canal.instance.master.address=127.0.0.1:3306
canal.instance.dbUsername=canal
canal.instance.dbPassword=canal

#canal.adapter是向目标端数据库写数据的
mkdir adapter
cd adapter
tar -zxf ../canal.adapter-1.1.3.tar.gz
conf/application.yml 是配置要写到哪个数据库的文件 ，以下这段是写入到postgresql的，如果有多个就多写几段，key值不一样就行。另外要注意写法，冒号后要加空格，缩进每次都是两个空格。
  - name: rdb
    key: postgres1
    properties:
      jdbc.driverClassName: org.postgresql.Driver
      jdbc.url: jdbc:postgresql://172.17.0.6:5432/postgres
      jdbc.username: dc
      jdbc.password: dc
      threads: 1
      commitSize: 3000

conf/rdb/*.yml 是要同步的表，每个文件对应一个表，表可以是字段一致的，如果不一致，需要在这个文件里写对应关系。
dataSourceKey: defaultDS
destination: example
groupId: g1
outerAdapterKey: postgres1  #这里与application.yml中的key对应
concurrent: false
dbMapping:
  database: dc   #读取源库的
  table: d_xxxk_xx_userdownload   #读取源库的
  targetTable: public.d_xxxk_xx_userdownload  #要写入库的
  targetPk:     #这里不要写东西，格式就是这样，这里的内容在下一行或下面多行，
    id: id      #这里的格式是 源表主键： 目标表主键 ， 如果是复合主键，多写几行，每行一个对应关系
  mapAll: true  #这里是全表对应，两边表的字段一样就用这个，如果要做映射，这个位置写 false
  targetColumns: #这个也是不写东西，要对应的字段都写下边
    id:          #因为上面用了mapAll， 所以这里可以不写 这里是第一个映射字段
    name:        #这里是第二个映射字段
    role_id:     #第三个....
    c_time:
    test1:


#测试
使用kettle从82上把d_xxxk_xx_userdownload导入到本地docker下的mysql数据库，使用canal监控mysql数据表的写入，同步到另外一台机器上docker下postgresql的不记录日志的nologged表中
数据导入开始时速度大约在 3400条/秒
后稍有减少，大约稳定在2900条/秒
整个过程平均速度在2284条/秒
mysql机器的磁盘io约在5M/秒 占用60%左右 
目标机postgresql 的磁盘io约在1.5M/秒左右，占用在10%以内

测试中发现canal是从binlog中读取日志，每次读取一定行数后，将数据按设置的pk进行排序后再插入到目标端的，canal会记录已经读取的binlog中的位置，如果插入失败，则不更改位置，再次继续时仍从此位置读取。

#官方性能参考文档
https://github.com/alibaba/canal/wiki/Performance


官方下载版目前提供了1.1.3版本，github上现在是1.1.4版本，1.1.4版本中有一个canal-admin将1.1.3版本中的配置文件全放到数据库中了，可以在页面进行配置了。
#建议先使用1.1.3，因为java端的连接方式用到的jar包现在mave上还没有1.1.4,在springboot项目中的pom里只能使用1.1.3的。






















