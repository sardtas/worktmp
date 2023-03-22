--安装外部连接组件
create extension  postgres_fdw;
--建server的连接
CREATE SERVER bi82 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.1.1.82', dbname 'dc', port '58000');
--建一个用户的映射 哪个用户用这个连接，就for 哪个用户 
CREATE USER MAPPING FOR fdw_user
        SERVER bi82
        OPTIONS (user 'yangyong', password 'yangyong@xkwbi_23kll8@la./#21a');
--建一个外部表
CREATE FOREIGN TABLE f_softnew (
        id int NOT NULL, -- 自增ID
	softid int8 NOT NULL, -- 资料ID
	softname varchar(255) NULL, -- 资料名称
	resource_source varchar(32) NULL, -- 资源来源
	subject_type varchar(32) NULL, -- 学科类型
	period_type varchar(32) NULL, -- 学段
	grade_type varchar(32) NULL, -- 年级
	version_type varchar(32) NULL, -- 教材版本
	soft_type varchar(32) NULL, -- 资源类型
	soft_point numeric(22,2) NULL, -- 普通点
	soft_advpoint numeric(22,2) NULL, -- 高级点
	soft_money numeric(22,2) NULL, -- 储值
	add_date date NULL, -- 上传日期
	is_del boolean NULL, -- 是否删除
	first_download_date date null, -- 首次下载日期,--限上传30天内
	is_valid boolean NULL, -- 是否有效资源
	system_source varchar(8) NOT NULL, -- 系统来源:1-中学学科网;2-小学学科网
	etl_status varchar NULL, -- ETL状态
	etl_date date NULL, -- ETL日期
	areaid varchar(32) NULL, -- 资料来源省份ID
	soft_cash numeric(22,2) NULL, -- 现金
	textbookid varchar(32) NULL, -- 教材版本id
	textbookcatalogid varchar(32) NULL, -- 教材目录id
	pointid varchar(32) NULL, -- 知识点id
	courseid varchar(32) NULL, -- 课程id
	xkwclassid varchar(32) NULL, -- 新栏目id
	userid int4 NULL, -- 作者id
	username varchar(64) NULL, -- 作者姓名
	adduserid int4 NULL, -- 添加人id
	adduser varchar(64) NULL, -- 添加人姓名
	softlanguage varchar(32) NULL, -- 类别
	resource_source_original varchar(8) null, -- 资料来源,--不合并普通点和免费
	boutique_type varchar(8) NULL, -- 精品资料类型：0非精品资源，1精品解析资源，2精品创作资源
	original_softid int4 NULL -- 小学资料表原始记录的softid
)
        SERVER bi82
        OPTIONS (schema_name 'bi_adm', table_name 'a_res_soft_info_new');


--建表时的分布,默认用主键，没主键用第一列，用  DISTRIBUTED可指定 DISTRIBUTED BY (id)
create table softnew1   as select * from f_softnew;

--默认建表是行表，要建列表加 参数
 WITH (appendonly=true, orientation=column)
--
create table l_xxd  WITH (appendonly=true, orientation=column,compresstype=zlib,   compresslevel=9)
as select * from xxd;

--具体参数
WITH ( storage_parameter=value [, ... ] )                            
--是否只能追加数据 只追加数据时才可以使用列存储，才能压缩
    APPENDONLY={TRUE|FALSE}       
--指定块大小
    BLOCKSIZE={8192-2097152}                              
--指定存储方式 行 或 列
    ORIENTATION={COLUMN|ROW}                                
--指定压缩方式
    COMPRESSTYPE={ZLIB|QUICKLZ|RLE_TYPE|NONE} 
--压缩级别
    COMPRESSLEVEL={0-9}                                       
--占空因数
    FILLFACTOR={10-100}                                      
--是否带oids， 需要测试一下不带会有什么影响
    OIDS[=TRUE|FALSE]                                       



--可以针对每一列做压缩配置
CREATE TABLE T3 (c1 int ENCODING (compresstype=zlib,   compresslevel=1),
                  c2 char ENCODING (compresstype=quicklz, blocksize=65536),
                  c3 char, COLUMN c3 ENCODING (compresstype=RLE_TYPE) )
    WITH (appendonly=true, orientation=column)
    PARTITION BY RANGE (c3) (START ('1900-01-01'::DATE)          
                             END ('2100-12-31'::DATE),
                             COLUMN c3 ENCODING (zlib));
                            
                            
--
create extension multicorn ;


create user dc with password 'dcuat123';

grant all privileges on database dc to dc  ;

alter user yangyong with password 'yyuat123';





drop table  bi_fdm.d_pape_usercreatedpaper;
CREATE TABLE bi_fdm.d_pape_usercreatedpaper (
	id int4 NOT NULL,
	userid int4 NULL,
	username varchar(50) NULL,
	createtimeon timestamp NULL,
	quesbankid int4 NULL,
	papername varchar(500) NULL,
	paperurl varchar(500) NULL,
	userpaypoint int2 NULL,
	userpaymoney float8 NULL,
	userip varchar(50) NULL,
	status int2 NULL, -- 下载记录是否被标记删除（0：不删除，1删除），被删除的页面不展示
	webtype int2 NULL,
	etl_status bpchar(1) NOT NULL, -- 抽取状态:U-更新;I-插入;D-删除
	etl_date date NULL,
	schooluserid int4 NULL, -- 学校用户_学校ID
	groupid int4 NULL, -- 用户分组：1-普通用户；2-高级用户；3-e卷通高端；4-e卷通普通；5-e卷通中端；6-尊享用户
	stageid int4 NULL, -- 学段id
	subjectid int4 NULL, -- 科目id
	produsage_schoolid int4 NULL -- 学校产品使用明细统计--学校标识
)
PARTITION BY RANGE (createtimeon)(
	partition d_pape_usercreatedpaper201801 start ('2018-01-01') inclusive end ('2018-02-01') exclusive, 
	partition d_pape_usercreatedpaper201802 start ('2018-02-01') inclusive end ('2018-03-01') exclusive,
	partition d_pape_usercreatedpaper201803 start ('2018-03-01') inclusive end ('2018-04-01') exclusive,
	partition d_pape_usercreatedpaper201804 start ('2018-04-01') inclusive end ('2018-05-01') exclusive,
	partition d_pape_usercreatedpaper201805 start ('2018-05-01') inclusive end ('2018-06-01') exclusive,
	partition d_pape_usercreatedpaper201806 start ('2018-06-01') inclusive end ('2018-07-01') exclusive,
	partition d_pape_usercreatedpaper201807 start ('2018-07-01') inclusive end ('2018-08-01') exclusive,
	partition d_pape_usercreatedpaper201808 start ('2018-08-01') inclusive end ('2018-09-01') exclusive,
	partition d_pape_usercreatedpaper201809 start ('2018-09-01') inclusive end ('2018-10-01') exclusive,
	partition d_pape_usercreatedpaper201810 start ('2018-10-01') inclusive end ('2018-11-01') exclusive,
	partition d_pape_usercreatedpaper201811 start ('2018-11-01') inclusive end ('2018-12-01') exclusive,
	partition d_pape_usercreatedpaper201812 start ('2018-12-01') inclusive end ('2019-01-01') exclusive,
	
	partition d_pape_usercreatedpaper201901 start ('2019-01-01') inclusive end ('2019-02-01') exclusive, 
	partition d_pape_usercreatedpaper201902 start ('2019-02-01') inclusive end ('2019-03-01') exclusive,
	partition d_pape_usercreatedpaper201903 start ('2019-03-01') inclusive end ('2019-04-01') exclusive,
	partition d_pape_usercreatedpaper201904 start ('2019-04-01') inclusive end ('2019-05-01') exclusive,
	partition d_pape_usercreatedpaper201905 start ('2019-05-01') inclusive end ('2019-06-01') exclusive,
	partition d_pape_usercreatedpaper201906 start ('2019-06-01') inclusive end ('2019-07-01') exclusive,
	partition d_pape_usercreatedpaper201907 start ('2019-07-01') inclusive end ('2019-08-01') exclusive,
	partition d_pape_usercreatedpaper201908 start ('2019-08-01') inclusive end ('2019-09-01') exclusive,
	partition d_pape_usercreatedpaper201909 start ('2019-09-01') inclusive end ('2019-10-01') exclusive,
	partition d_pape_usercreatedpaper201910 start ('2019-10-01') inclusive end ('2019-11-01') exclusive,
	partition d_pape_usercreatedpaper201911 start ('2019-11-01') inclusive end ('2019-12-01') exclusive,
	partition d_pape_usercreatedpaper201912 start ('2019-12-01') inclusive end ('2020-01-01') exclusive,
	
	partition d_pape_usercreatedpaper202001 start ('2020-01-01') inclusive end ('2020-02-01') exclusive, 
	partition d_pape_usercreatedpaper202002 start ('2020-02-01') inclusive end ('2020-03-01') exclusive,
	partition d_pape_usercreatedpaper202003 start ('2020-03-01') inclusive end ('2020-04-01') exclusive,
	partition d_pape_usercreatedpaper202004 start ('2020-04-01') inclusive end ('2020-05-01') exclusive,
	partition d_pape_usercreatedpaper202005 start ('2020-05-01') inclusive end ('2020-06-01') exclusive,
	partition d_pape_usercreatedpaper202006 start ('2020-06-01') inclusive end ('2020-07-01') exclusive,
	partition d_pape_usercreatedpaper202007 start ('2020-07-01') inclusive end ('2020-08-01') exclusive,
	partition d_pape_usercreatedpaper202008 start ('2020-08-01') inclusive end ('2020-09-01') exclusive,
	partition d_pape_usercreatedpaper202009 start ('2020-09-01') inclusive end ('2020-10-01') exclusive,
	partition d_pape_usercreatedpaper202010 start ('2020-10-01') inclusive end ('2020-11-01') exclusive,
	partition d_pape_usercreatedpaper202011 start ('2020-11-01') inclusive end ('2020-12-01') exclusive,
	partition d_pape_usercreatedpaper202012 start ('2020-12-01') inclusive end ('2021-01-01') exclusive,
	
	partition d_pape_usercreatedpaper202101 start ('2021-01-01') inclusive end ('2021-02-01') exclusive, 
	partition d_pape_usercreatedpaper202102 start ('2021-02-01') inclusive end ('2021-03-01') exclusive,
	partition d_pape_usercreatedpaper202103 start ('2021-03-01') inclusive end ('2021-04-01') exclusive,
	partition d_pape_usercreatedpaper202104 start ('2021-04-01') inclusive end ('2021-05-01') exclusive,
	partition d_pape_usercreatedpaper202105 start ('2021-05-01') inclusive end ('2021-06-01') exclusive,
	partition d_pape_usercreatedpaper202106 start ('2021-06-01') inclusive end ('2021-07-01') exclusive,
	partition d_pape_usercreatedpaper202107 start ('2021-07-01') inclusive end ('2021-08-01') exclusive,
	partition d_pape_usercreatedpaper202108 start ('2021-08-01') inclusive end ('2021-09-01') exclusive,
	partition d_pape_usercreatedpaper202109 start ('2021-09-01') inclusive end ('2021-10-01') exclusive,
	partition d_pape_usercreatedpaper202110 start ('2021-10-01') inclusive end ('2021-11-01') exclusive,
	partition d_pape_usercreatedpaper202111 start ('2021-11-01') inclusive end ('2021-12-01') exclusive,
	partition d_pape_usercreatedpaper202112 start ('2021-12-01') inclusive end ('2022-01-01') exclusive,
	default partition d_pape_usercreatedpaper
);





DROP TABLE bi_fdm.d_zxxk_cl_consumelog;

CREATE TABLE bi_fdm.d_zxxk_cl_consumelog (
	id int4 NOT NULL, -- 序号
	channelid int4 NULL, -- 频道ID,主数据上线了，不再使用此字段作为判断
	infoid int4 NULL, -- 资源ID,关联soft_info_new的id
	userid int4 NULL, -- 用户id
	username varchar(64) NULL, -- 用户名
	schooluserid int4 NULL, -- 下载用户所属学校的id
	consumepoint numeric(12,2) NULL, -- 下载消耗的点数
	consumeadvpoint int4 NULL, -- 下载消耗的高级点数
	consumemoney numeric(12,2) NULL, -- 下载消耗的钱数
	consumetime timestamp NULL, -- 下载时间
	userdownip varchar(256) NULL, -- 下载用户的ip
	editor varchar(64) NULL, -- 编辑人员
	censor varchar(64) NULL, -- 审核人员
	isboutique int4 NULL, -- 是精品数据
	original_softtypeid int4 NULL, -- 资料类型id
	requestsource int4 NULL, -- 请求来源 1-学科网 2-M站
	platform int4 NULL, -- 请求的平台类型 0-PC 1-andriod 2-IOS
	consumetype int4 NULL, -- 消费类型
	iparea varchar(256) NULL, -- 下载ip地址的地区
	downinterface int4 NULL, -- 下载通道身份（1-网校通;2-网学通;3-视频通；4-计点；5-计天；6-IP网校通；7-扫码；8-包月；9-第三方现金；10卡券; 11-视频包月; 20-初中高端网校通；21-初中中端网校通;22-初中普通网校通；23-高中高端网校通；24-高中中端网校通；25-高中普通网校通；26-高中视频通；27-初中视频通）
	consumermb numeric(12,2) NULL, -- 下载消耗的人民币
	product int4 NULL, -- 所属产品
	prov_name varchar(64) NULL, -- 下载ip所属省份
	etl_status bpchar(1) NULL, -- 抽取状态:U-更新;I-插入;D-删除
	etl_date date NULL, -- 抽取时间
	title varchar(512) NULL, -- 下载的文件标题
	clientinfo varchar(64) NULL, -- ut
	consumecount int4 NULL, -- 包月会员消费份数
	iscomment int4 NULL, -- 是否评论
	accountsource int4 NULL, -- 账号来源，null或1-学科网，2-微信小程序
	resourcetype int4 NULL, -- 资源类型：null或0-普通资料；1-专辑成套；2-专题成套
	resourceprice numeric(12,2) NULL, -- 资源价格
	resourcepricetype int4 NULL, -- 资源价格类型：1-储值、2-高级点、3-普通点、4-免费、5-第三方
	consumeprice numeric(12,2) NULL, -- 消费价格
	consumepricetype int4 NULL, -- 消费类型：1-储值、2-高级点、3-普通点、4-免费、5-扫码现金、6-包月份数、7-卡券 、8-学校公共储值、9-资源卡    等类型
	discount int4 NULL, -- 折扣： 默认不打折
	editorid int4 NULL, -- 资料作者id
	subjectid int4 NULL, -- 学科id
	stageid int4 NULL, -- 学段id
	softtypeid int4 NULL, -- 资料类型id（映射后的，非原系统的）
	produsage_schoolid int4 null, -- 学校产品使用明细统计,--学校标识
	soft_level varchar(8) NULL, -- 资料等级（1普通，3特供，4精品，5第三方，N其他未知）
	downinterface_text varchar(22) NULL, -- 下载通道身份名称
	batchid int4 NULL, -- 下载批次id
	albumid int4 NULL, -- 专辑id
	system_source varchar(8) NULL, -- 来源系统表：1中学，2小学
	original_subjectid int4 NULL, -- 原始subjectid
	original_softid int4 NULL, -- 原始softid，来源自历史小学下载记录
	isduplicate bool NULL, -- 是否重复下载，来源自历史小学下载记录
	description varchar(50) NULL -- 下载描诉，来源自历史小学下载记录
)
PARTITION BY RANGE (consumetime)
(
partition d_zxxk_cl_consumelog201801 start ('2018-01-01') inclusive end ('2018-02-01') exclusive, 
	partition d_zxxk_cl_consumelog201802 start ('2018-02-01') inclusive end ('2018-03-01') exclusive,
	partition d_zxxk_cl_consumelog201803 start ('2018-03-01') inclusive end ('2018-04-01') exclusive,
	partition d_zxxk_cl_consumelog201804 start ('2018-04-01') inclusive end ('2018-05-01') exclusive,
	partition d_zxxk_cl_consumelog201805 start ('2018-05-01') inclusive end ('2018-06-01') exclusive,
	partition d_zxxk_cl_consumelog201806 start ('2018-06-01') inclusive end ('2018-07-01') exclusive,
	partition d_zxxk_cl_consumelog201807 start ('2018-07-01') inclusive end ('2018-08-01') exclusive,
	partition d_zxxk_cl_consumelog201808 start ('2018-08-01') inclusive end ('2018-09-01') exclusive,
	partition d_zxxk_cl_consumelog201809 start ('2018-09-01') inclusive end ('2018-10-01') exclusive,
	partition d_zxxk_cl_consumelog201810 start ('2018-10-01') inclusive end ('2018-11-01') exclusive,
	partition d_zxxk_cl_consumelog201811 start ('2018-11-01') inclusive end ('2018-12-01') exclusive,
	partition d_zxxk_cl_consumelog201812 start ('2018-12-01') inclusive end ('2019-01-01') exclusive,
	
	partition d_zxxk_cl_consumelog201901 start ('2019-01-01') inclusive end ('2019-02-01') exclusive, 
	partition d_zxxk_cl_consumelog201902 start ('2019-02-01') inclusive end ('2019-03-01') exclusive,
	partition d_zxxk_cl_consumelog201903 start ('2019-03-01') inclusive end ('2019-04-01') exclusive,
	partition d_zxxk_cl_consumelog201904 start ('2019-04-01') inclusive end ('2019-05-01') exclusive,
	partition d_zxxk_cl_consumelog201905 start ('2019-05-01') inclusive end ('2019-06-01') exclusive,
	partition d_zxxk_cl_consumelog201906 start ('2019-06-01') inclusive end ('2019-07-01') exclusive,
	partition d_zxxk_cl_consumelog201907 start ('2019-07-01') inclusive end ('2019-08-01') exclusive,
	partition d_zxxk_cl_consumelog201908 start ('2019-08-01') inclusive end ('2019-09-01') exclusive,
	partition d_zxxk_cl_consumelog201909 start ('2019-09-01') inclusive end ('2019-10-01') exclusive,
	partition d_zxxk_cl_consumelog201910 start ('2019-10-01') inclusive end ('2019-11-01') exclusive,
	partition d_zxxk_cl_consumelog201911 start ('2019-11-01') inclusive end ('2019-12-01') exclusive,
	partition d_zxxk_cl_consumelog201912 start ('2019-12-01') inclusive end ('2020-01-01') exclusive,
	
	partition d_zxxk_cl_consumelog202001 start ('2020-01-01') inclusive end ('2020-02-01') exclusive, 
	partition d_zxxk_cl_consumelog202002 start ('2020-02-01') inclusive end ('2020-03-01') exclusive,
	partition d_zxxk_cl_consumelog202003 start ('2020-03-01') inclusive end ('2020-04-01') exclusive,
	partition d_zxxk_cl_consumelog202004 start ('2020-04-01') inclusive end ('2020-05-01') exclusive,
	partition d_zxxk_cl_consumelog202005 start ('2020-05-01') inclusive end ('2020-06-01') exclusive,
	partition d_zxxk_cl_consumelog202006 start ('2020-06-01') inclusive end ('2020-07-01') exclusive,
	partition d_zxxk_cl_consumelog202007 start ('2020-07-01') inclusive end ('2020-08-01') exclusive,
	partition d_zxxk_cl_consumelog202008 start ('2020-08-01') inclusive end ('2020-09-01') exclusive,
	partition d_zxxk_cl_consumelog202009 start ('2020-09-01') inclusive end ('2020-10-01') exclusive,
	partition d_zxxk_cl_consumelog202010 start ('2020-10-01') inclusive end ('2020-11-01') exclusive,
	partition d_zxxk_cl_consumelog202011 start ('2020-11-01') inclusive end ('2020-12-01') exclusive,
	partition d_zxxk_cl_consumelog202012 start ('2020-12-01') inclusive end ('2021-01-01') exclusive,
	
	partition d_zxxk_cl_consumelog202101 start ('2021-01-01') inclusive end ('2021-02-01') exclusive, 
	partition d_zxxk_cl_consumelog202102 start ('2021-02-01') inclusive end ('2021-03-01') exclusive,
	partition d_zxxk_cl_consumelog202103 start ('2021-03-01') inclusive end ('2021-04-01') exclusive,
	partition d_zxxk_cl_consumelog202104 start ('2021-04-01') inclusive end ('2021-05-01') exclusive,
	partition d_zxxk_cl_consumelog202105 start ('2021-05-01') inclusive end ('2021-06-01') exclusive,
	partition d_zxxk_cl_consumelog202106 start ('2021-06-01') inclusive end ('2021-07-01') exclusive,
	partition d_zxxk_cl_consumelog202107 start ('2021-07-01') inclusive end ('2021-08-01') exclusive,
	partition d_zxxk_cl_consumelog202108 start ('2021-08-01') inclusive end ('2021-09-01') exclusive,
	partition d_zxxk_cl_consumelog202109 start ('2021-09-01') inclusive end ('2021-10-01') exclusive,
	partition d_zxxk_cl_consumelog202110 start ('2021-10-01') inclusive end ('2021-11-01') exclusive,
	partition d_zxxk_cl_consumelog202111 start ('2021-11-01') inclusive end ('2021-12-01') exclusive,
	partition d_zxxk_cl_consumelog202112 start ('2021-12-01') inclusive end ('2022-01-01') exclusive,
	default partition d_zxxk_cl_consumelog
)
;



DROP TABLE bi_fdm.d_zxxk_cl_consumelog;

CREATE TABLE bi_fdm.d_zxxk_cl_consumelog (
	id int4 NOT NULL, -- 序号
	channelid int4 NULL, -- 频道ID,主数据上线了，不再使用此字段作为判断
	infoid int4 NULL, -- 资源ID,关联soft_info_new的id
	userid int4 NULL, -- 用户id
	username varchar(64) NULL, -- 用户名
	schooluserid int4 NULL, -- 下载用户所属学校的id
	consumepoint numeric(12,2) NULL, -- 下载消耗的点数
	consumeadvpoint int4 NULL, -- 下载消耗的高级点数
	consumemoney numeric(12,2) NULL, -- 下载消耗的钱数
	consumetime timestamp NULL, -- 下载时间
	userdownip varchar(256) NULL, -- 下载用户的ip
	editor varchar(64) NULL, -- 编辑人员
	censor varchar(64) NULL, -- 审核人员
	isboutique int4 NULL, -- 是精品数据
	original_softtypeid int4 NULL, -- 资料类型id
	requestsource int4 NULL, -- 请求来源 1-学科网 2-M站
	platform int4 NULL, -- 请求的平台类型 0-PC 1-andriod 2-IOS
	consumetype int4 NULL, -- 消费类型
	iparea varchar(256) NULL, -- 下载ip地址的地区
	downinterface int4 NULL, -- 下载通道身份（1-网校通;2-网学通;3-视频通；4-计点；5-计天；6-IP网校通；7-扫码；8-包月；9-第三方现金；10卡券; 11-视频包月; 20-初中高端网校通；21-初中中端网校通;22-初中普通网校通；23-高中高端网校通；24-高中中端网校通；25-高中普通网校通；26-高中视频通；27-初中视频通）
	consumermb numeric(12,2) NULL, -- 下载消耗的人民币
	product int4 NULL, -- 所属产品
	prov_name varchar(64) NULL, -- 下载ip所属省份
	etl_status bpchar(1) NULL, -- 抽取状态:U-更新;I-插入;D-删除
	etl_date date NULL, -- 抽取时间
	title varchar(512) NULL, -- 下载的文件标题
	clientinfo varchar(64) NULL, -- ut
	consumecount int4 NULL, -- 包月会员消费份数
	iscomment int4 NULL, -- 是否评论
	accountsource int4 NULL, -- 账号来源，null或1-学科网，2-微信小程序
	resourcetype int4 NULL, -- 资源类型：null或0-普通资料；1-专辑成套；2-专题成套
	resourceprice numeric(12,2) NULL, -- 资源价格
	resourcepricetype int4 NULL, -- 资源价格类型：1-储值、2-高级点、3-普通点、4-免费、5-第三方
	consumeprice numeric(12,2) NULL, -- 消费价格
	consumepricetype int4 NULL, -- 消费类型：1-储值、2-高级点、3-普通点、4-免费、5-扫码现金、6-包月份数、7-卡券 、8-学校公共储值、9-资源卡    等类型
	discount int4 NULL, -- 折扣： 默认不打折
	editorid int4 NULL, -- 资料作者id
	subjectid int4 NULL, -- 学科id
	stageid int4 NULL, -- 学段id
	softtypeid int4 NULL, -- 资料类型id（映射后的，非原系统的）
	produsage_schoolid int4 null, -- 学校产品使用明细统计,--学校标识
	soft_level varchar(8) NULL, -- 资料等级（1普通，3特供，4精品，5第三方，N其他未知）
	downinterface_text varchar(22) NULL, -- 下载通道身份名称
	batchid int4 NULL, -- 下载批次id
	albumid int4 NULL, -- 专辑id
	system_source varchar(8) NULL, -- 来源系统表：1中学，2小学
	original_subjectid int4 NULL, -- 原始subjectid
	original_softid int4 NULL, -- 原始softid，来源自历史小学下载记录
	isduplicate bool NULL, -- 是否重复下载，来源自历史小学下载记录
	description varchar(50) NULL -- 下载描诉，来源自历史小学下载记录
)
PARTITION BY RANGE (consumetime)
(
partition d_zxxk_cl_consumelog201801 start ('2018-01-01') inclusive end ('2018-02-01') exclusive, 
	partition d_zxxk_cl_consumelog201802 start ('2018-02-01') inclusive end ('2018-03-01') exclusive,
	partition d_zxxk_cl_consumelog201803 start ('2018-03-01') inclusive end ('2018-04-01') exclusive,
	partition d_zxxk_cl_consumelog201804 start ('2018-04-01') inclusive end ('2018-05-01') exclusive,
	partition d_zxxk_cl_consumelog201805 start ('2018-05-01') inclusive end ('2018-06-01') exclusive,
	partition d_zxxk_cl_consumelog201806 start ('2018-06-01') inclusive end ('2018-07-01') exclusive,
	partition d_zxxk_cl_consumelog201807 start ('2018-07-01') inclusive end ('2018-08-01') exclusive,
	partition d_zxxk_cl_consumelog201808 start ('2018-08-01') inclusive end ('2018-09-01') exclusive,
	partition d_zxxk_cl_consumelog201809 start ('2018-09-01') inclusive end ('2018-10-01') exclusive,
	partition d_zxxk_cl_consumelog201810 start ('2018-10-01') inclusive end ('2018-11-01') exclusive,
	partition d_zxxk_cl_consumelog201811 start ('2018-11-01') inclusive end ('2018-12-01') exclusive,
	partition d_zxxk_cl_consumelog201812 start ('2018-12-01') inclusive end ('2019-01-01') exclusive,
	
	partition d_zxxk_cl_consumelog201901 start ('2019-01-01') inclusive end ('2019-02-01') exclusive, 
	partition d_zxxk_cl_consumelog201902 start ('2019-02-01') inclusive end ('2019-03-01') exclusive,
	partition d_zxxk_cl_consumelog201903 start ('2019-03-01') inclusive end ('2019-04-01') exclusive,
	partition d_zxxk_cl_consumelog201904 start ('2019-04-01') inclusive end ('2019-05-01') exclusive,
	partition d_zxxk_cl_consumelog201905 start ('2019-05-01') inclusive end ('2019-06-01') exclusive,
	partition d_zxxk_cl_consumelog201906 start ('2019-06-01') inclusive end ('2019-07-01') exclusive,
	partition d_zxxk_cl_consumelog201907 start ('2019-07-01') inclusive end ('2019-08-01') exclusive,
	partition d_zxxk_cl_consumelog201908 start ('2019-08-01') inclusive end ('2019-09-01') exclusive,
	partition d_zxxk_cl_consumelog201909 start ('2019-09-01') inclusive end ('2019-10-01') exclusive,
	partition d_zxxk_cl_consumelog201910 start ('2019-10-01') inclusive end ('2019-11-01') exclusive,
	partition d_zxxk_cl_consumelog201911 start ('2019-11-01') inclusive end ('2019-12-01') exclusive,
	partition d_zxxk_cl_consumelog201912 start ('2019-12-01') inclusive end ('2020-01-01') exclusive,
	
	partition d_zxxk_cl_consumelog202001 start ('2020-01-01') inclusive end ('2020-02-01') exclusive, 
	partition d_zxxk_cl_consumelog202002 start ('2020-02-01') inclusive end ('2020-03-01') exclusive,
	partition d_zxxk_cl_consumelog202003 start ('2020-03-01') inclusive end ('2020-04-01') exclusive,
	partition d_zxxk_cl_consumelog202004 start ('2020-04-01') inclusive end ('2020-05-01') exclusive,
	partition d_zxxk_cl_consumelog202005 start ('2020-05-01') inclusive end ('2020-06-01') exclusive,
	partition d_zxxk_cl_consumelog202006 start ('2020-06-01') inclusive end ('2020-07-01') exclusive,
	partition d_zxxk_cl_consumelog202007 start ('2020-07-01') inclusive end ('2020-08-01') exclusive,
	partition d_zxxk_cl_consumelog202008 start ('2020-08-01') inclusive end ('2020-09-01') exclusive,
	partition d_zxxk_cl_consumelog202009 start ('2020-09-01') inclusive end ('2020-10-01') exclusive,
	partition d_zxxk_cl_consumelog202010 start ('2020-10-01') inclusive end ('2020-11-01') exclusive,
	partition d_zxxk_cl_consumelog202011 start ('2020-11-01') inclusive end ('2020-12-01') exclusive,
	partition d_zxxk_cl_consumelog202012 start ('2020-12-01') inclusive end ('2021-01-01') exclusive,
	
	partition d_zxxk_cl_consumelog202101 start ('2021-01-01') inclusive end ('2021-02-01') exclusive, 
	partition d_zxxk_cl_consumelog202102 start ('2021-02-01') inclusive end ('2021-03-01') exclusive,
	partition d_zxxk_cl_consumelog202103 start ('2021-03-01') inclusive end ('2021-04-01') exclusive,
	partition d_zxxk_cl_consumelog202104 start ('2021-04-01') inclusive end ('2021-05-01') exclusive,
	partition d_zxxk_cl_consumelog202105 start ('2021-05-01') inclusive end ('2021-06-01') exclusive,
	partition d_zxxk_cl_consumelog202106 start ('2021-06-01') inclusive end ('2021-07-01') exclusive,
	partition d_zxxk_cl_consumelog202107 start ('2021-07-01') inclusive end ('2021-08-01') exclusive,
	partition d_zxxk_cl_consumelog202108 start ('2021-08-01') inclusive end ('2021-09-01') exclusive,
	partition d_zxxk_cl_consumelog202109 start ('2021-09-01') inclusive end ('2021-10-01') exclusive,
	partition d_zxxk_cl_consumelog202110 start ('2021-10-01') inclusive end ('2021-11-01') exclusive,
	partition d_zxxk_cl_consumelog202111 start ('2021-11-01') inclusive end ('2021-12-01') exclusive,
	partition d_zxxk_cl_consumelog202112 start ('2021-12-01') inclusive end ('2022-01-01') exclusive,
	default partition d_zxxk_cl_consumelog
)
;


--gp中分区表中不用加d_zxxk_cl_consumelog 这种前缀，会自动加
--DROP TABLE bi_fdm.l_zxxk_cl_consumelog;

CREATE TABLE bi_fdm.l_zxxk_cl_consumelog (
	id int4 NOT NULL, -- 序号
	channelid int4 NULL, -- 频道ID,主数据上线了，不再使用此字段作为判断
	infoid int4 NULL, -- 资源ID,关联soft_info_new的id
	userid int4 NULL, -- 用户id
	username varchar(64) NULL, -- 用户名
	schooluserid int4 NULL, -- 下载用户所属学校的id
	consumepoint numeric(12,2) NULL, -- 下载消耗的点数
	consumeadvpoint int4 NULL, -- 下载消耗的高级点数
	consumemoney numeric(12,2) NULL, -- 下载消耗的钱数
	consumetime timestamp NULL, -- 下载时间
	userdownip varchar(256) NULL, -- 下载用户的ip
	editor varchar(64) NULL, -- 编辑人员
	censor varchar(64) NULL, -- 审核人员
	isboutique int4 NULL, -- 是精品数据
	original_softtypeid int4 NULL, -- 资料类型id
	requestsource int4 NULL, -- 请求来源 1-学科网 2-M站
	platform int4 NULL, -- 请求的平台类型 0-PC 1-andriod 2-IOS
	consumetype int4 NULL, -- 消费类型
	iparea varchar(256) NULL, -- 下载ip地址的地区
	downinterface int4 NULL, -- 下载通道身份（1-网校通;2-网学通;3-视频通；4-计点；5-计天；6-IP网校通；7-扫码；8-包月；9-第三方现金；10卡券; 11-视频包月; 20-初中高端网校通；21-初中中端网校通;22-初中普通网校通；23-高中高端网校通；24-高中中端网校通；25-高中普通网校通；26-高中视频通；27-初中视频通）
	consumermb numeric(12,2) NULL, -- 下载消耗的人民币
	product int4 NULL, -- 所属产品
	prov_name varchar(64) NULL, -- 下载ip所属省份
	etl_status bpchar(1) NULL, -- 抽取状态:U-更新;I-插入;D-删除
	etl_date date NULL, -- 抽取时间
	title varchar(512) NULL, -- 下载的文件标题
	clientinfo varchar(64) NULL, -- ut
	consumecount int4 NULL, -- 包月会员消费份数
	iscomment int4 NULL, -- 是否评论
	accountsource int4 NULL, -- 账号来源，null或1-学科网，2-微信小程序
	resourcetype int4 NULL, -- 资源类型：null或0-普通资料；1-专辑成套；2-专题成套
	resourceprice numeric(12,2) NULL, -- 资源价格
	resourcepricetype int4 NULL, -- 资源价格类型：1-储值、2-高级点、3-普通点、4-免费、5-第三方
	consumeprice numeric(12,2) NULL, -- 消费价格
	consumepricetype int4 NULL, -- 消费类型：1-储值、2-高级点、3-普通点、4-免费、5-扫码现金、6-包月份数、7-卡券 、8-学校公共储值、9-资源卡    等类型
	discount int4 NULL, -- 折扣： 默认不打折
	editorid int4 NULL, -- 资料作者id
	subjectid int4 NULL, -- 学科id
	stageid int4 NULL, -- 学段id
	softtypeid int4 NULL, -- 资料类型id（映射后的，非原系统的）
	produsage_schoolid int4 null, -- 学校产品使用明细统计,--学校标识
	soft_level varchar(8) NULL, -- 资料等级（1普通，3特供，4精品，5第三方，N其他未知）
	downinterface_text varchar(22) NULL, -- 下载通道身份名称
	batchid int4 NULL, -- 下载批次id
	albumid int4 NULL, -- 专辑id
	system_source varchar(8) NULL, -- 来源系统表：1中学，2小学
	original_subjectid int4 NULL, -- 原始subjectid
	original_softid int4 NULL, -- 原始softid，来源自历史小学下载记录
	isduplicate bool NULL, -- 是否重复下载，来源自历史小学下载记录
	description varchar(50) NULL -- 下载描诉，来源自历史小学下载记录
) WITH (appendonly=true, orientation=column,compresstype=zlib,   compresslevel=9)
PARTITION BY RANGE (consumetime)
(
partition l_zxxk_cl_consumelog201801 start ('2018-01-01') inclusive end ('2018-02-01') exclusive, 
	partition l_zxxk_cl_consumelog201802 start ('2018-02-01') inclusive end ('2018-03-01') exclusive,
	partition l_zxxk_cl_consumelog201803 start ('2018-03-01') inclusive end ('2018-04-01') exclusive,
	partition l_zxxk_cl_consumelog201804 start ('2018-04-01') inclusive end ('2018-05-01') exclusive,
	partition l_zxxk_cl_consumelog201805 start ('2018-05-01') inclusive end ('2018-06-01') exclusive,
	partition l_zxxk_cl_consumelog201806 start ('2018-06-01') inclusive end ('2018-07-01') exclusive,
	partition l_zxxk_cl_consumelog201807 start ('2018-07-01') inclusive end ('2018-08-01') exclusive,
	partition l_zxxk_cl_consumelog201808 start ('2018-08-01') inclusive end ('2018-09-01') exclusive,
	partition l_zxxk_cl_consumelog201809 start ('2018-09-01') inclusive end ('2018-10-01') exclusive,
	partition l_zxxk_cl_consumelog201810 start ('2018-10-01') inclusive end ('2018-11-01') exclusive,
	partition l_zxxk_cl_consumelog201811 start ('2018-11-01') inclusive end ('2018-12-01') exclusive,
	partition l_zxxk_cl_consumelog201812 start ('2018-12-01') inclusive end ('2019-01-01') exclusive,
	
	partition l_zxxk_cl_consumelog201901 start ('2019-01-01') inclusive end ('2019-02-01') exclusive, 
	partition l_zxxk_cl_consumelog201902 start ('2019-02-01') inclusive end ('2019-03-01') exclusive,
	partition l_zxxk_cl_consumelog201903 start ('2019-03-01') inclusive end ('2019-04-01') exclusive,
	partition l_zxxk_cl_consumelog201904 start ('2019-04-01') inclusive end ('2019-05-01') exclusive,
	partition l_zxxk_cl_consumelog201905 start ('2019-05-01') inclusive end ('2019-06-01') exclusive,
	partition l_zxxk_cl_consumelog201906 start ('2019-06-01') inclusive end ('2019-07-01') exclusive,
	partition l_zxxk_cl_consumelog201907 start ('2019-07-01') inclusive end ('2019-08-01') exclusive,
	partition l_zxxk_cl_consumelog201908 start ('2019-08-01') inclusive end ('2019-09-01') exclusive,
	partition l_zxxk_cl_consumelog201909 start ('2019-09-01') inclusive end ('2019-10-01') exclusive,
	partition l_zxxk_cl_consumelog201910 start ('2019-10-01') inclusive end ('2019-11-01') exclusive,
	partition l_zxxk_cl_consumelog201911 start ('2019-11-01') inclusive end ('2019-12-01') exclusive,
	partition l_zxxk_cl_consumelog201912 start ('2019-12-01') inclusive end ('2020-01-01') exclusive,
	
	partition l_zxxk_cl_consumelog202001 start ('2020-01-01') inclusive end ('2020-02-01') exclusive, 
	partition l_zxxk_cl_consumelog202002 start ('2020-02-01') inclusive end ('2020-03-01') exclusive,
	partition l_zxxk_cl_consumelog202003 start ('2020-03-01') inclusive end ('2020-04-01') exclusive,
	partition l_zxxk_cl_consumelog202004 start ('2020-04-01') inclusive end ('2020-05-01') exclusive,
	partition l_zxxk_cl_consumelog202005 start ('2020-05-01') inclusive end ('2020-06-01') exclusive,
	partition l_zxxk_cl_consumelog202006 start ('2020-06-01') inclusive end ('2020-07-01') exclusive,
	partition l_zxxk_cl_consumelog202007 start ('2020-07-01') inclusive end ('2020-08-01') exclusive,
	partition l_zxxk_cl_consumelog202008 start ('2020-08-01') inclusive end ('2020-09-01') exclusive,
	partition l_zxxk_cl_consumelog202009 start ('2020-09-01') inclusive end ('2020-10-01') exclusive,
	partition l_zxxk_cl_consumelog202010 start ('2020-10-01') inclusive end ('2020-11-01') exclusive,
	partition l_zxxk_cl_consumelog202011 start ('2020-11-01') inclusive end ('2020-12-01') exclusive,
	partition l_zxxk_cl_consumelog202012 start ('2020-12-01') inclusive end ('2021-01-01') exclusive,
	
	partition l_zxxk_cl_consumelog202101 start ('2021-01-01') inclusive end ('2021-02-01') exclusive, 
	partition l_zxxk_cl_consumelog202102 start ('2021-02-01') inclusive end ('2021-03-01') exclusive,
	partition l_zxxk_cl_consumelog202103 start ('2021-03-01') inclusive end ('2021-04-01') exclusive,
	partition l_zxxk_cl_consumelog202104 start ('2021-04-01') inclusive end ('2021-05-01') exclusive,
	partition l_zxxk_cl_consumelog202105 start ('2021-05-01') inclusive end ('2021-06-01') exclusive,
	partition l_zxxk_cl_consumelog202106 start ('2021-06-01') inclusive end ('2021-07-01') exclusive,
	partition l_zxxk_cl_consumelog202107 start ('2021-07-01') inclusive end ('2021-08-01') exclusive,
	partition l_zxxk_cl_consumelog202108 start ('2021-08-01') inclusive end ('2021-09-01') exclusive,
	partition l_zxxk_cl_consumelog202109 start ('2021-09-01') inclusive end ('2021-10-01') exclusive,
	partition l_zxxk_cl_consumelog202110 start ('2021-10-01') inclusive end ('2021-11-01') exclusive,
	partition l_zxxk_cl_consumelog202111 start ('2021-11-01') inclusive end ('2021-12-01') exclusive,
	partition l_zxxk_cl_consumelog202112 start ('2021-12-01') inclusive end ('2022-01-01') exclusive,
	default partition l_zxxk_cl_consumelog
)
;




-- DROP TABLE bi_adm.a_usr_user_ulog;
CREATE TABLE bi_adm.a_usr_user_ulog (
	id int8 NULL, -- 用户登录记录ID
	userid int4 NULL, -- 用户ID
	userip varchar(50) NULL, -- 用户IP
	logintime timestamp NULL, -- 登录时间
	status int4 NULL, -- 状态
	appkey varchar(50) NULL, -- 应用关键字
	service varchar NULL, -- 服务页面
	service_type varchar(64) NULL, -- 服务类型
	app_source varchar(32) NULL, -- 产品来源
	etl_status bpchar(1) NULL, -- 抽取状态:U-更新;I-插入;D-删除
	etl_date date NULL,
	terminal varchar(16) NULL, -- 登录终端 web ,app , h5
	product varchar(32) NULL -- 登录产品
)
PARTITION BY RANGE (etl_date)(	
	partition p201801 start ('2018-01-01') inclusive end ('2018-02-01') exclusive, 
	partition p201802 start ('2018-02-01') inclusive end ('2018-03-01') exclusive,
	partition p201803 start ('2018-03-01') inclusive end ('2018-04-01') exclusive,
	partition p201804 start ('2018-04-01') inclusive end ('2018-05-01') exclusive,
	partition p201805 start ('2018-05-01') inclusive end ('2018-06-01') exclusive,
	partition p201806 start ('2018-06-01') inclusive end ('2018-07-01') exclusive,
	partition p201807 start ('2018-07-01') inclusive end ('2018-08-01') exclusive,
	partition p201808 start ('2018-08-01') inclusive end ('2018-09-01') exclusive,
	partition p201809 start ('2018-09-01') inclusive end ('2018-10-01') exclusive,
	partition p201810 start ('2018-10-01') inclusive end ('2018-11-01') exclusive,
	partition p201811 start ('2018-11-01') inclusive end ('2018-12-01') exclusive,
	partition p201812 start ('2018-12-01') inclusive end ('2019-01-01') exclusive,
	
	partition p201901 start ('2019-01-01') inclusive end ('2019-02-01') exclusive, 
	partition p201902 start ('2019-02-01') inclusive end ('2019-03-01') exclusive,
	partition p201903 start ('2019-03-01') inclusive end ('2019-04-01') exclusive,
	partition p201904 start ('2019-04-01') inclusive end ('2019-05-01') exclusive,
	partition p201905 start ('2019-05-01') inclusive end ('2019-06-01') exclusive,
	partition p201906 start ('2019-06-01') inclusive end ('2019-07-01') exclusive,
	partition p201907 start ('2019-07-01') inclusive end ('2019-08-01') exclusive,
	partition p201908 start ('2019-08-01') inclusive end ('2019-09-01') exclusive,
	partition p201909 start ('2019-09-01') inclusive end ('2019-10-01') exclusive,
	partition p201910 start ('2019-10-01') inclusive end ('2019-11-01') exclusive,
	partition p201911 start ('2019-11-01') inclusive end ('2019-12-01') exclusive,
	partition p201912 start ('2019-12-01') inclusive end ('2020-01-01') exclusive,
	
	partition p202001 start ('2020-01-01') inclusive end ('2020-02-01') exclusive, 
	partition p202002 start ('2020-02-01') inclusive end ('2020-03-01') exclusive,
	partition p202003 start ('2020-03-01') inclusive end ('2020-04-01') exclusive,
	partition p202004 start ('2020-04-01') inclusive end ('2020-05-01') exclusive,
	partition p202005 start ('2020-05-01') inclusive end ('2020-06-01') exclusive,
	partition p202006 start ('2020-06-01') inclusive end ('2020-07-01') exclusive,
	partition p202007 start ('2020-07-01') inclusive end ('2020-08-01') exclusive,
	partition p202008 start ('2020-08-01') inclusive end ('2020-09-01') exclusive,
	partition p202009 start ('2020-09-01') inclusive end ('2020-10-01') exclusive,
	partition p202010 start ('2020-10-01') inclusive end ('2020-11-01') exclusive,
	partition p202011 start ('2020-11-01') inclusive end ('2020-12-01') exclusive,
	partition p202012 start ('2020-12-01') inclusive end ('2021-01-01') exclusive,
	
	partition p202101 start ('2021-01-01') inclusive end ('2021-02-01') exclusive, 
	partition p202102 start ('2021-02-01') inclusive end ('2021-03-01') exclusive,
	partition p202103 start ('2021-03-01') inclusive end ('2021-04-01') exclusive,
	partition p202104 start ('2021-04-01') inclusive end ('2021-05-01') exclusive,
	partition p202105 start ('2021-05-01') inclusive end ('2021-06-01') exclusive,
	partition p202106 start ('2021-06-01') inclusive end ('2021-07-01') exclusive,
	partition p202107 start ('2021-07-01') inclusive end ('2021-08-01') exclusive,
	partition p202108 start ('2021-08-01') inclusive end ('2021-09-01') exclusive,
	partition p202109 start ('2021-09-01') inclusive end ('2021-10-01') exclusive,
	partition p202110 start ('2021-10-01') inclusive end ('2021-11-01') exclusive,
	partition p202111 start ('2021-11-01') inclusive end ('2021-12-01') exclusive,
	partition p202112 start ('2021-12-01') inclusive end ('2022-01-01') exclusive,
	default partition pall
);


