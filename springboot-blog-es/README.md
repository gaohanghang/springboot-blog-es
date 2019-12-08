简易博客检索系统使用前后端分离，前端使用 Vue ，后端使用 SpringBoot 数据库 MySQL 检索使用 ElasticSearch 同步数据使用 logstash
### SpringBoot 集成 ElasticSearch 实现 MySQL 数据同步
需要提前安装好 ElasticSearch 。logstash 安装下文有具体说明。
新建表 blog 必须有字段 id update_time，可参考项目中 entity 包下字段建表。
项目地址 [SpringBoot 搭建博客检索系统](https://github.com/sixkery/blog_index)
使用步骤
1. download 本项目
2. 修改 yml 文件中的数据库配置，es 配置。
3. 配置 logstash ，见下文。
4. 启动本项目，在本地 8081 端口访问项目，可以看到有两个按钮，分别是通过 MySQL 的模糊查询和 es 的检索耗时比较。

### 配置 logstash
使用 logstash 同步  mysql 中的数据。全量同步，增量更新
这里使用虚拟机中的 centos 。
前提，CentOS 中安装 ElasticSearch 。 
第一步，下载 [logstash](https://www.elastic.co/cn/downloads/past-releases#logstash) 
第二步，把数据库连接的驱动 jar 包放到 logstash 的目录中。
![enter description here](./images/1574645141708.png)
第三步，在 config 文件夹中新建文件 `mysql.conf`，配置数据库，es 端口等输入输出规则
```dsconfig
input{
  jdbc{
    # jdbc 驱动包位置
    jdbc_driver_library => "/home/es/logstash-6.2.4/mysql-connector-java-5.1.6.jar"
    # 要使用的驱动包类
    jdbc_driver_class => "com.mysql.jdbc.Driver" 
    # mysql 数据库的连接信息
    jdbc_connection_string => "jdbc:mysql://localhost:3306/blog"
    # mysql 用户
    jdbc_user => "root"
    # 密码
    jdbc_password => "密码"
    # 定时任务，多久执行一次查询，默认一分钟，如果想要没有延迟，可以使用 schedule => "* * * * *"
    schedule => "* * * * *"
    # 清空上一次的 sql_last_value 记录
    clean_run => true
    # 要执行的语句
    statement => "select * from t_blog where update_time > :sql_last_value and update_time < NOW() order by update_time desc"
    }
}

output {
  elasticsearch {
    # es host : port
    hosts => ["192.168.42.134:9200"]
    # 索引
    index => "blog"
    # _id
    document_id => "%{id}"
  }
}

```
第四步，以配置文件的方式启动 logstash
```shell
[es@localhost bin]$ ./logstash -f ../config/mysql.conf 
```
第五步，kibana 中查看是否同步成功
```shell

GET blog/_stats
// 查看全部数据
POST blog/_search
{
}
```