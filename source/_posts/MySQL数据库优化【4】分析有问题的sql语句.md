---
title: MySQL数据库优化【4】分析有问题的sql语句
date: 2018-03-21 15:22:38
tags:
  - MySQL
  - 数据库优化
categories: db
---
## 通过慢查日志分析有问题的语句
### 1、查询次数多切每次查询占用时间长的SQL

通常为pt-qeury-digest分析的前几个查询，查看pt-query-digest 第三部分

Exec time 项为占用时间

### 2、IO大的SQL

注意pt-query-digest分析中Rows examine项，扫描的行数多，也就表示占的IO大

### 3、未命中索引的SQL

注意pt-query-digest中Rows examine 和 Rows Send 的对比

如果Rows examine >> Rows Send，就说明想要的数据少， 但是扫描到了大量的数据

---
## 使用explain查询SQL的执行计划

eg:`mysql> explain select customer_id,first_name,last_name from customer`

    mysql> explain select customer_id,first_name,last_name from customer;
    +----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------+
    | id | select_type | table    | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra |
    +----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------+
    |  1 | SIMPLE      | customer | NULL       | ALL  | NULL          | NULL | NULL    | NULL |  599 |   100.00 | NULL  |
    +----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------+
    1 row in set, 1 warning (0.01 sec)

* table：显示查询的哪张表
* partitions: 表示给定表所使用的区域使用expain partitions才会有值
* type：这是重要的列，显示连接使用了哪种类型，从最好到最差的连接类型为`const`、`eq_reg`、`ref`、`range`、`index`、`ALL`
    - const为常数查找,基本上用到主键查询或者唯一索引查询；
    - eq_reg为范围查找
    - ref为基于索引的查找
    - range为基于索引的范围查找
    - index为对于索引的扫描
    - ALL为表扫描
* possible_keys: 显示可能应用在这张表中的索引。如果为空，没有可能的索引。
* key：实际使用的索引，如果为空，则没有使用索引
* key_len：使用的索引的长度。在不损失精确性的情况下，长度越短越好。
* ref：显示索引的哪一列被使用了，如果可能的话，是一个常数。
* rows：MYSQL认为必须检查的用来放回请求数据的行数。
* filtered：显示了通过条件过滤出的行数的百分比估计值
* extra：额外的属性值。需要注意的返回值
    - Using filesort：\[使用文件排序\]看到这个的时候，查询就需要优化了，MYSQL需要进行额外的步骤来发现如何对放回的行排序。他根据连接类型及存储排序键值和匹配条件的全部行的指针来排序全部行
    - Using temporary：\[查询用到临时表\]看到这个的时候，查询就需要优化了，这里，MYSQL需要创建一个临时表来存储结果，这通常发生在对不同的列集进行ORDER BY上，而不是GROUP BY上

---
上一章:[MySQL数据库优化【3】慢查日志分析工具](/MySQL数据库优化【3】慢查日志分析工具/)