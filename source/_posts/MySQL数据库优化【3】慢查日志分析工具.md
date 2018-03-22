---
title: MySQL数据库优化【3】慢查日志分析工具
date: 2018-03-19 15:19:46
tags: MySQL
categories: 数据库优化
---

## mysqldumpslow

用于查看并格式化慢查日志

如果系统中没有mysqldumpslow这个命令， 那么到mysql的安装目录下的bin目录下找这个命令，window可以设置环境变量， linux和mac用户可以设置软连接

    Usage: mysqldumpslow [OPTS...] [LOGS...]

    Pares and summarize the MySQL slow query log. Options are

    --verbose verbose
    --debug debug
    --help write this text to standard output

    -v           verbose
    -d           debug
    -s ORDER     what to sort by (al, at, ar, c, l, r, t), 'at' is default
                    al: average lock time
                    ar: average rows sent
                    at: average query time
                    c: count
                    l: lock time
                    r: rows sent
                    t: query time
    -r           reverse the sort order (largest last instead of first)
    -t NUM       just show the top n queries
    -a           don't abstract all numbers to N and strings to 'S'
    -n NUM       abstract numbers with at least n digits within names
    -g PATTERN   grep: only consider stmts that include this string
    -h HOSTNAME  hostname of db server for *-slow.log filename (can be wildcard),default is '*', i.e. match all
    -i NAME      name of server instance (if using mysql.server startup script)
    -l           don't subtract lock time from total time

例：`mysqldumpslow -t 3 mysql-slow.log | more`

输出：

    Reading mysql slow query log from mysql-slow.log
    Count: 1  Time=0.00s (0s)  Lock=0.00s (0s)  Rows=1.0 (1), root[root]@localhost
      show variables like 'S'

    Count: 1  Time=0.00s (0s)  Lock=0.00s (0s)  Rows=200.0 (200), root[root]@localhost
      select  * from actor

    Count: 1  Time=0.00s (0s)  Lock=0.00s (0s)  Rows=9.0 (9), root[root]@localhost
      show databases

由于演示，我们把慢查超时时间改成了0，所以前三条列出了以上这些，另外慢查日志中记录的是这个服务器所有的慢查语句， 而不是一个数据库的慢查日志

以上数据显示了数据执行的次数、执行时间、加锁时间、影响行数、执行角色和执行地址

## pt-query-digest
由于这是第三方工具，安装请自行查询

建议安装， 毕竟pt-query-digest比mysqldumpslow更强大

----------------------------------------
上一章:[MySQL数据库优化【2】SQL及索引优化](/MySQL数据库优化【2】SQL及索引优化/)
下一章:[MySQL数据库优化【4】分析有问题的sql语句](/MySQL数据库优化【4】分析有问题的sql语句/)