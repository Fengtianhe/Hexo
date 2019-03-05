---
title: 分析Haproxy日志
date: 2019-03-05 19:23:33
tags: Haproxy
categories: server
author: 冯天鹤
---
> 我使用的是Ubuntu机器

### 安装Elasticsearch

* 安装JDK `sudo apt install openjdk-11-jdk-headless`（如果本机有请跳过）（如果没有 使用java命令 ,系统会提示用什么命令安装）

![ubuntu 无 java 提示](/images/201903051953.jpg)

* 在[elastic.co](https://www.elastic.co/downloads/past-releases)上下载 Elasticsearch OSS 版本
* 配置JAVA环境变量（如果本机有请跳过）

        命令一：which java

        命令二：ls -lrt /usr/bin/java

        命令三：ls -lrt /etc/alternatives/java

        最后将会得出这样的目录 /usr/lib/jvm/java-11-openjdk-amd64(每个人不一样，以实际情况为准)

* 配置环境变量，执行命令 vi /etc/profile；然后进入编辑模式，在文件的最后添加下面的配置

        JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

        JRE_HOME=/usr/java/jdk1.8.0_151/jre

        CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH

        PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

* 执行命令 source /etc/profile 使用环境变量生效

* 在 usr 下创建 elasticsearch 目录 `sudo mkdir /usr/elasticsearch`

* tar -zxvf 下载下来的 elasticsearch-oss-x.x.x.tar.gz 放到 /usr/elasticsearch 下

* 创建ES用户和组（创建elsearch用户组及elsearch用户），因为使用root用户执行ES程序，将会出现错误；所以这里需要创建单独的用户去执行ES 文件；命令如下

        命令一：groupadd elsearch

        命令二：useradd elsearch -g elsearch

        命令三：chown -R elsearch:elsearch /usr/elasticsearch  该命令是更改该文件夹下所属的用户组的权限

* 在`/usr/elasticsearch`中创建ES数据文件和日志文件

        命令一：mkdir -p data (修改所属权限)

        命令二：mkdir -p logs (修改所属权限)

* 修改 `/usr/elasticsearch/config/elasticsearch.yml` 文件 （可以使用默认）
