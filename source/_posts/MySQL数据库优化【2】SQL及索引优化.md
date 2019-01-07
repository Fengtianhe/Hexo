---
title: MySQL数据库优化【2】SQL及索引优化
date: 2018-03-15 16:40:18
tags:
  - MySQL
  - 数据库优化
categories: db
author: 冯天鹤
---

## 准备数据
首先我们需要大量的数据进行分析，这里我们可以使用MySQL官方提供的sakila数据库：

http://dev.mysql.com/doc/index-other.html

sakila数据库的安装使用过程：

http://dev.mysql.com/doc/sakila/en/sakila-installation.html

## 安装数据
下载好数据，依次倒入Schama和Data，显示如下则为成功

    USE sakila;
    Database changed

    SHOW TABLES;
    +----------------------------+
    | Tables_in_sakila           |
    +----------------------------+
    | actor                      |
    | address                    |
    | category                   |
    | city                       |
    | country                    |
    | customer                   |
    | customer_list              |
    | film                       |
    | film_actor                 |
    | film_category              |
    | film_list                  |
    | film_text                  |
    | inventory                  |
    | language                   |
    | nicer_but_slower_film_list |
    | payment                    |
    | rental                     |
    | sales_by_film_category     |
    | sales_by_store             |
    | staff                      |
    | staff_list                 |
    | store                      |
    +----------------------------+
    22 rows in set (0.00 sec)

    SELECT COUNT(*) FROM film;
    +----------+
    | COUNT(*) |
    +----------+
    | 1000     |
    +----------+
    1 row in set (0.02 sec)

    SELECT COUNT(*) FROM film_text;
    +----------+
    | COUNT(*) |
    +----------+
    | 1000     |
    +----------+
    1 row in set (0.00 sec)

## MySQL慢查询日志的开启方式和储存格式
通过慢查询日志我们可以看到那些sql是应该优化的，那我们如何发现有问题的SQL呢？
答案就是 使用MySQL慢查日志对效率问题的SQL进行监控

1. 设置慢查询日志路径(设置权限)

    `set global slow_query_log_file= '/Users/fengtianhe/Log/mysql/mysql-slow.log';`

1. 设置没有索引的记录到慢查询日志

	`set global log_queries_not_using_indexes=on;`

1. 查看mysql是否开启慢查询日志

	`show variables like 'slow_query_log';`

1. 开启慢查询日志

	`set global slow_query_log=on;`

1. 查看超过多长时间的sql进行记录到慢查询日志

	`show variables like 'long_query_time';`

1. 设置sql执行长时间(如果没发现生效， 就退出数据库重新链接)

    `set global long_query_time=0;`

## 试一试

设置慢查日志之后的你们一定迫不及待了吧，让我们试试吧

    use sakila;
    select * from actor;

这时我们可以看看日志，就记录了我们这次查询的记录由于演示我们把超时设置为0，所以日志中会记录所有的信息,也记录了我们执行的语句

![](/images/20180315-1.jpg)

那么让我们看看慢查询日志都记录了些什么

1. 执行SQL的主机信息

`# User@Host: root[root] @ localhost []`

2. SQL的执行信息

`# Query_time: 0.000461  Lock_time: 0.000064 Rows_sent: 200  Rows_examined: 200
 SET timestamp=1521105352;`

3. SQL的执行时间

`SET timestamp=1521105352;`

4. SQL的内容

`select  * from actor;`

---
上一章:[MySQL数据库优化【1】简介](/MySQL数据库优化【1】简介/)
下一章:[MySQL数据库优化【3】慢查日志分析工具](/MySQL数据库优化【3】慢查日志分析工具/)