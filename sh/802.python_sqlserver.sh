pip install pymssql


import pymssql

conn = pymssql.connect(host='127.0.0.1',
                       user='sa',
                       password='123',
                       database='SQLTest',
                       charset='utf8')

#查看连接是否成功
cursor = conn.cursor()
sql = 'select * from student'
cursor.execute(sql)
#用一个rs变量获取数据
rs = cursor.fetchall()

print(rs)


try:
    conn = pymssql.connect(host='127.0.0.1',
                           user='sa',
                           password='123',
                           database='SQLTest',
                           charset='utf8')
    cursor = conn.cursor()
    sql = 'insert into student values('0001', '张三', 18, '男', '文学院')'
    cursor.execute(sql)
    conn.commit()
except Exception as ex:
    conn.rollback()
    raise ex
finally:
    conn.close()
