---
title: PHP扩展-Redis
date: 2019-03-04 09:39:23
tags:
    - PHP
    - PHP扩展
categories: rd
author: 冯天鹤
---

### 安装Redis
在[redis.io](https://redis.io/)下载lts版本源码

编译源码
```
$ tar -zxvf redis-xxxx.tar.gz
$ cd redis-xxxx
$ make
$ make PREFIX=/usr/local/redis install
```

配置文件
```
$ mkdir /usr/local/redis/etc/
$ cp redis.conf /usr/local/redis/etc/
$ cd /usr/local/redis/bin/

$ vim /usr/local/redis/etc/redis.conf

```
修改一下配置
redis以守护进程的方式运行
no表示不以守护进程的方式运行(会占用一个终端)
`daemonize yes`

---

### 安装php扩展

我的服务器是php5.6 我选用的phpredis 是 2.2.8 版本
首先下载扩展[PECL](http://pecl.php.net/package/redis)

```
$ tar -zxvf redis-2.2.8.tgz
$ cd redis-2.2.8
$ phpize #用phpize生成configure配置文件
$ ./configure --with-php-config=/usr/bin/php-config #配置
$ make  #编译
$ make install  #安装
```
然后会提示一个目录，通过`php -i | grep php.ini` 查找PHP配置文件，然后将redis.so添加到扩展列表中
---

### 应用php扩展

#### Apache
平滑重启apache(不会对当前启动的程序产生影响)
`apachectl -k graceful`

#### Nginx
Nginx 是通过php-fpm加载的扩展

php 5.3.3 以后的php-fpm 不再支持 php-fpm 以前具有的 /Data/apps/php7/sbin/php-fpm(start|stop|reload)等命令，所以不要再看这种老掉牙的命令了，需要使用信号控制

master进程可以理解以下信号

INT, TERM 立刻终止
QUIT 平滑终止
USR1 重新打开日志文件
USR2 平滑重载所有worker进程并重新载入配置和二进制模块

一个简单直接的重启方法：

先查看php-fpm的master进程号
```
$ ps aux|grep php-fpm
root      1565  0.0  0.6 499908  6596 ?        Ss   Feb27   0:10 php-fpm: master process (/etc/php-fpm.conf)
apache    1566  0.0  3.1 503588 32176 ?        S    Feb27   0:03 php-fpm: pool www
apache    1567  0.0  3.0 503552 31080 ?        S    Feb27   0:03 php-fpm: pool www
apache    1568  0.0  3.1 502880 31868 ?        S    Feb27   0:03 php-fpm: pool www
apache    1569  0.0  3.1 504372 32196 ?        S    Feb27   0:03 php-fpm: pool www
apache    1570  0.0  2.8 503556 28844 ?        S    Feb27   0:03 php-fpm: pool www
apache    1963  0.0  3.0 503040 31192 ?        S    Feb27   0:03 php-fpm: pool www
apache    5390  0.0  2.7 503540 28556 ?        S    Feb28   0:02 php-fpm: pool www
apache    5657  0.0  2.8 503568 29400 ?        S    Mar01   0:02 php-fpm: pool www
apache    7421  0.0  2.6 503308 26968 ?        S    Mar01   0:02 php-fpm: pool www
root     23263  0.0  0.0 103264   844 pts/1    S+   11:28   0:00 grep php-fpm

$ kill -USR2 1565 #重启php-fpm
$ ps aux|grep php-fpm #重新看下进程号
root     23275  0.0  0.6 499908  6560 ?        Ss   11:30   0:00 php-fpm: master process (/etc/php-fpm.conf)
apache   23276  0.0  0.5 499908  5664 ?        S    11:30   0:00 php-fpm: pool www
apache   23277  0.0  0.5 499908  5664 ?        S    11:30   0:00 php-fpm: pool www
apache   23278  0.0  0.5 499908  5664 ?        S    11:30   0:00 php-fpm: pool www
apache   23279  0.0  0.5 499908  5672 ?        S    11:30   0:00 php-fpm: pool www
apache   23280  0.0  0.5 499908  5672 ?        S    11:30   0:00 php-fpm: pool www
root     23282  0.0  0.0 103264   844 pts/1    S+   11:30   0:00 grep php-fpm
```