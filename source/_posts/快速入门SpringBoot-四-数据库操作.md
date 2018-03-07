---
title: 快速入门SpringBoot(四)----数据库操作
date: 2018-03-06 19:05:36
tags:
- Java
- SpringBoot
categories: 快速入门SpringBoot
---
## 安装依赖
说到数据库的操作, 我们需要两个依赖,分别是
```
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
```

## 修改配置文件
在配置文件中设置数据库配置

![application.yml](http://upload-images.jianshu.io/upload_images/2663172-f6d4473cead7d0b9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 创建Model类
然后创建一个类,定义字段和构造方法以及getter和setter方法, idea的快捷键是`control+回车`

![image.png](http://upload-images.jianshu.io/upload_images/2663172-d1816f5484e0a44b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后运行会发现数据库自动创建了一个表
![image.png](http://upload-images.jianshu.io/upload_images/2663172-c4ef149c0b1666d5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`ddl-auto`其他的属性值
![image.png](http://upload-images.jianshu.io/upload_images/2663172-fbe1f52db1dc262b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

***
数据库创建完毕然后进行数据库操作吧
先建一个RestfulApi的类

|请求类型|请求路径|功能|
|--|--|--|
|GET|/girls|获取列表|
|POST|/girls|创建一条数据|
|GET|/girls/{id}|通过id查询一条记录|
|PUT|/girls/{id}|通过id修改一条记录|
|DELETE|/girls/{id}|通过id删除一条记录|

## 创建一个JPA的接口类
![image.png](http://upload-images.jianshu.io/upload_images/2663172-f2b70cb2a344403a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](http://upload-images.jianshu.io/upload_images/2663172-f87a913ac665fae4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

也可以通过字段去查询
![image.png](http://upload-images.jianshu.io/upload_images/2663172-ca98c153ac1b6a2d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](http://upload-images.jianshu.io/upload_images/2663172-ab38480420a05907.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

jpa命名规则http://blog.csdn.net/sbin456/article/details/53304148