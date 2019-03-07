---
title: 分析Haproxy日志
date: 2019-03-05 19:23:33
tags:
    - Haproxy
    - Logstash
    - Filebeat
categories: server
author: 冯天鹤
---
> 我使用的是Ubuntu机器

### 安装Elasticsearch

* 【可选】安装JDK `sudo apt install openjdk-8-jdk-headless`（如果本机有请跳过）（如果没有 使用java命令 ,系统会提示用什么命令安装）

![ubuntu 无 java 提示](/images/201903051953.jpg)

* 在[elastic.co](https://www.elastic.co/downloads/past-releases)上下载 Elasticsearch OSS 版本
* 【可选】配置JAVA环境变量（如果本机有请跳过,就用jdk1.8 不要用其他版本）

        命令一：which java

        命令二：ls -lrt /usr/bin/java

        命令三：ls -lrt /etc/alternatives/java

        最后将会得出这样的目录 /usr/lib/jvm/java-8-openjdk-amd64(每个人不一样，以实际情况为准)

* 【可选】配置环境变量，执行命令 vi /etc/profile；然后进入编辑模式，在文件的最后添加下面的配置

        JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

        JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

        CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH

        PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

* 执行命令 source /etc/profile 使用环境变量生效

* 在 usr 下创建 elasticsearch 目录 `sudo mkdir /usr/elasticsearch`

* tar -zxvf 下载下来的 elasticsearch-oss-x.x.x.tar.gz 放到 /usr/elasticsearch 下

* 【可选】创建ES用户和组（创建elsearch用户组及elsearch用户），因为使用root用户执行ES程序，将会出现错误；所以这里需要创建单独的用户去执行ES 文件；命令如下（如果存在普通用户就不用新建了）

        命令一：groupadd elsearch

        命令二：useradd elsearch -g elsearch

        命令三：chown -R elsearch:elsearch /usr/elasticsearch  该命令是更改该文件夹下所属的用户组的权限

* 在`/usr/elasticsearch`中创建ES数据文件和日志文件

        命令一：mkdir -p data (修改所属权限)

        命令二：mkdir -p logs (修改所属权限)

* 修改 `/usr/elasticsearch/config/elasticsearch.yml` 文件 （可以使用默认）

* 使用 `/usr/elasticsearch/bin/elasticsearch -d` 用后台启动

* 测试是否启动成功

![测试elasticsearch是否启动成功](/images/201903060941.jpg)

---

### 安装Logstash

> Logstash是一个开源的服务器端数据处理管道，可以同时从多个数据源获取数据，并对其进行转换，然后将其发送到你最喜欢的“存储”。（当然，我们最喜欢的是Elasticsearch）

![logstash 工作原理](/images/201903060941.jpg)

* 在[elastic.co](https://www.elastic.co/downloads/past-releases)上下载 Logstash 并解压

* 配置logstash

* 在logstash下运行 `./bin/logstash -f 自定义配置文件路径` 启动logstash

* tail 日志 显示Non-zero metrics in the last 30s字样就启动成功了

ps: 无知的我一直在tail 生成的日志，其实已经写进去了，只不过没有日志，可能修改日志级别就好了

---

### 安装Filebeat

* 在[elastic.co](https://www.elastic.co/downloads/past-releases)上下载 Filebeat OSS 并解压

（使用`getconf LONG_BIT`查看ubuntu位数）

* 修改yml配置文件，将output转为logstash的。(如果配置文件看着乱，可以自己再写一个 filebeat -e -c 配置文件路径)

* 启动对haproxy 和 logstash的支持

        ./filebeat modules enable haproxy
        ./filebeat modules enable logstash

---

### 安装Kibana

* 在[elastic.co](https://www.elastic.co/downloads/past-releases)上下载 Kiana OSS 并解压

* 然后到kibana安装目录的config下，编辑kibana.yml配置文件，(可以使用默认)

* `./bin/kibana &` 启动然后输入exit就后台启动了

* 浏览器 `127.0.0.1:5601` 打开kibana控制台
---

### 验证数据

GET 请求 elasticsearch服务器/_search 查看是否有数据

---

### 遇到的问题

#### 如何切换kibana控制台的数据源

> 二货的我用自带的测试数据打开了，在 左侧 Management -> Index Patterns -> create index pattern
> 输入index-name 下一步创建，再切回面板就好了

#### 汉化Kibana界面

> 奶奶的，不光二，英语还不好。算了 汉化吧

        wget -c  https://codeload.github.com/anbai-inc/Kibana_Hanization/zip/master -O Kibana_Hanization-master.zip
        下载并解压
        执行汉化命令 `python main.py ~/kibana-6.6.1-linux-x86_64/`
        重启kibana(汉化只能解决部分问题，重要的还是学英语吧)

---

### 相关文章

