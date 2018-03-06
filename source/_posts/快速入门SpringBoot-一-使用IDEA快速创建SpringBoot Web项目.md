---
title: 快速入门SpringBoot(一)----使用IDEA快速创建SpringBoot Web项目
date: 2018-03-02 14:50:47
tags:
  - Java
  - SpringBoot
categories: 快速入门SpringBoot
---
这里推荐使用 ***IntelliJ IDEA***  编译器, 有人会问为什么不是使用Eclipse, 答案是IDEA可以快速的创建SpringBoot项目,不需要繁琐的创建过程

言归正传,首先我们需要有个IDEA编译器

下载地址 https://www.jetbrains.com/idea/
下载旗舰版,因为只有旗舰版才能创建SpringBoot项目功能
![image.png](http://upload-images.jianshu.io/upload_images/2663172-11918155e105ba92.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
下载下来的是30免费使用期的,所以破解就用这个吧 http://idea.lanyus.com/

下一步就是创建项目了
![image.png](http://upload-images.jianshu.io/upload_images/2663172-c672f991e3ddd9a5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
第二个界面确认项目名和包名下一步继续
![image.png](http://upload-images.jianshu.io/upload_images/2663172-b62d179863618427.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
第三个界面,由于是web项目,所以选择web就可以下一步了
![image.png](http://upload-images.jianshu.io/upload_images/2663172-0c3b56f347255b5f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
最后确定项目名和项目目录完成创建项目
![image.png](http://upload-images.jianshu.io/upload_images/2663172-f43139e20f7845e8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
#启动项目
启动src/main/java目录下的主文件, 右键`run ‘XXXApplication’ `访问浏览器http://localhost:8080显示如下
![localhost:8080](http://upload-images.jianshu.io/upload_images/2663172-120fb21c1f06a5fc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这是因为我们没写任何东西, 按照国际惯例, 我们来写一个hello world

我们新建一个HelloController的类然后搞一些事情(注解是spring框架至关重要的,一个都别丢哈!)
![image.png](http://upload-images.jianshu.io/upload_images/2663172-ebdf4842444903b7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![HelloController](http://upload-images.jianshu.io/upload_images/2663172-49022e9a111e5565.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
访问浏览器localhost:8080/hello瞅瞅我们最亲近的 hello world 大叔吧!!
![image.png](http://upload-images.jianshu.io/upload_images/2663172-67a8a3c678e4a55d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


