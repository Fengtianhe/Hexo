---
title: '快速开发基于AndroidWebView的WebApp[1]----初始化项目'
date: 2018-03-08 17:15:46
tags:
- Android
categories: rd
---

本文章仅献给一点毫无Android基础的开发人员快速开发webview项目



## 1.准备工作
### 1.1 安装环境

下载java 并配置环境变量  因为操作系统不同 请自找度娘求教
这是我在mac上的配置

![JAVA相关环境变量](/images/20180308-1.jpg)

![ANDROID必须的环境变量](/images/20180308-2.jpg)

### 1.2 安装开发环境

[android studio 官网](http://www.android-studio.org/)

由于我本地已经搭建好开发环境，我已经忘了当时出什么坑爹的bug了， 自行搜索吧

## 2. 创建项目
![打开android studio](/images/20180308-2.jpg)

打开android studio 点击 `start a new Android Studio project`

![](/images/20180308-4.jpg)
![](/images/20180308-5.jpg)

填写公司名和项目名， 对应关系见两个图， 这些保证软件的唯一性，比如腾讯公司的软件一般都是com.tencent.**

![](/images/20180308-6.jpg)

第二步，选择手机api，这个以目前大多数手机为准，现在（2018年03月）大多手机都是android7.0+ 所以我选择API24

![](/images/20180308-7.jpg)

第三步，也是最后一步，因为我们用的是webview，header和footer都可以写在页面中，所以我们不需要activity， 点击finish

***

下一章[快速开发基于AndroidWebView的WebApp[2]----显示一个baidu](/快速开发基于AndroidWebView的WebApp-2-显示一个baidu)