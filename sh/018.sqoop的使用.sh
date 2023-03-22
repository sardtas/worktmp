hadoop中数据的存储是以文本为主的，所以特殊字符在hadoop中会导致数据错误，比如pg的varchar型字段中有“回行”，导入的数据在被hive识别过程中会认为这一行的数据已经结束，会按下一行开始转换数据，就会多出一行来，所以要加--hive-drop-import-delims，hive早期版本默认的列分隔符是逗号，现在已经是^A了，这个是默认不可见的，在linux下为'\001'，在java中是"\u0001"
--direct 是使用数据库工具读取数据，装sqoop的机器上要有数据库的客户端，然后将数据直接写入hdfs。不带这个就使用jdbc连接，然后使用mr将数据处理后写入hdfs。带这个参数的语句会快不少。带了这个参数就不能使用 --hive-drop-import-delims 了，数据库中的回行会导致数据导入hive后多出一行，使数据发生错误。如果确认要导数据的表中没有回行，才能使用这个参数。

sqoop import   \
--connect jdbc:postgresql://10.1.1.82:58000/dc --username dc --password dc123456 -m 1 \
--table r_rpt_school_download --fields-terminated-by '\001' --hive-drop-import-delims --direct \
--create-hive-table --hive-import \
-- --schema bi_rpt 


sqoop import   \
--connect jdbc:postgresql://10.1.1.82:58000/dc --username dc --password dc123456 -m 1 \
--table tmpy1 --fields-terminated-by '\001' --direct --hive-drop-import-delims --create-hive-table --hive-import \
-- --schema bi_rpt 


sqoop import   \
--connect jdbc:postgresql://10.1.1.82:58000/dc --username dc --password dc123456 -m 1 \
--fields-terminated-by '\001' --direct --create-hive-table --hive-drop-import-delims --hive-import \
--table a_res_soft_info -- --schema bi_adm 


sqoop import   \
--connect jdbc:postgresql://10.1.1.82:58000/dc --username dc --password dc123456 -m 1 \
--fields-terminated-by '\001' --direct --create-hive-table --hive-drop-import-delims --hive-import \
--table d_xxxk_xx_userdownload -- --schema bi_fdm 

sqoop import   \
--connect jdbc:postgresql://10.1.1.82:58000/dc --username dc --password dc123456 -m 1 \
--fields-terminated-by '\001'  --create-hive-table  --hive-drop-import-delims --hive-import \
--table d_pape_usercreatedpaper --hive-table bi_fdm.d_pape_usercreatedpaper -- --schema bi_fdm 




sqoop import   \
--connect jdbc:postgresql://10.1.1.82:58000/dc --username dc --password dc123456 -m 1 \
--direct --create-hive-table --hive-import \
--table d_sal_b_schoolcustomer  --hive-table bi_fdm.d_sal_b_schoolcustomer  -- --schema bi_fdm 


--hive-drop-import-delims


sqoop import --connect jdbc:postgresql://10.1.1.82:58000/dc --username dc --password dc123456 -m 1 --direct --create-hive-table --hive-import --table d_sal_b_schoolcustomer  --hive-table bi_fdm.d1 --hive-drop-import-delims  -- --schema bi_fdm 
















