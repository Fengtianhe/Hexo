---
title: 快速入门SpringBoot(二)----项目的配置文件
date: 2018-03-06 19:03:14
tags:
- Java
- SpringBoot
categories: rd
author: 冯天鹤
---
项目都会有配置文件的, 配置数据库, redis 等等....
那么这个文件在哪藏着呢?
项目目录下src/main/resource下有个`application.properties`文件,这个就是配置文件,当然也有人用 yaml 做配置文件, 这个都是按照个人喜好相同的配置文件properties 和 yaml 写法有些区别

***yaml写法key 和value中间的空格一定不能少***

![properties文件](http://upload-images.jianshu.io/upload_images/2663172-47a93f0ad18af343.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![yml文件](http://upload-images.jianshu.io/upload_images/2663172-64653e727514c448.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


配置完了,如何使用,那就要归功于spring强大的注解功能了
![image.png](http://upload-images.jianshu.io/upload_images/2663172-ac9a4a5057761fac.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
配置文件没有变量类型, 我们只需要在定义的时候加上类型就可以了
![image.png](http://upload-images.jianshu.io/upload_images/2663172-2c7ca45c10b72913.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
这时候问题又出现了
我们如果在每个类文件中一个一个去定义很麻烦, 那么我们需要写个公共获取配置文件的类
![image.png](http://upload-images.jianshu.io/upload_images/2663172-a33cfe0ad81e16dd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
component和ConfigurationProperties注解很关键 component是在类中使用需要
![image.png](http://upload-images.jianshu.io/upload_images/2663172-98f4180271eb8838.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
打开浏览器查看效果
![image.png](http://upload-images.jianshu.io/upload_images/2663172-262271770f2fdfd1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

