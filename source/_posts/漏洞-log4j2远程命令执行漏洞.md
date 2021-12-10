---
title: log4j2漏洞安全修复方案
date: 2021-12-10 10:10:00
tags: 
- Java
- 安全
- 漏洞
categories: rd
author: 冯天鹤
---
## 漏洞说明
12.05日，log4j在PR中修复了一个远程命令执行漏洞，TEG-安全平台部对修复代码进行了分析和测试，得出结论：

1、攻击者利用该漏洞可获得服务器权限；

2、漏洞攻击代码可以造成业务拒绝服务甚至宕机；

3、漏洞利用方法极其简单；

4、log4j依赖包在java工程大量使用，该漏洞影响广泛；

## 影响范围
组: org.apache.logging.log4j

名称: log4j-core

漏洞版本: <= 2.14.1

## 修复方案
#### JDK7+ 修复方案
###### 说明
截至发文时(2021-12-09)官方最新版本2.14.1尚未修复该问题

待log4j官方后续发布2.15-rc的正式版本后，业务可自行升级使用>=2.15的安全版本。

###### 修复方式
禁用Lookups配置(仅适用于log4j-core版本>=2.10)
步骤1，检查项目log4j-core版本，确保大于等于2.10 (不包含2.10-rc1 );

步骤2，将formatMsgNoLookups设置为true，可通过properties配置或者jvm启动参数来设置:

项目resources目录的log4j2.component.properties文件里添加log4j2.formatMsgNoLookups=true;

![修复方式](/images/20211210-1.png)

jvm启动参数里添加 -Dlog4j2.formatMsgNoLookups=true

![修复方式](/images/20211210-2.png)

#### JDK6 修复方案
###### 说明
由于log4j在2.3以后不支持JDK6，使用JDK6的工程无法升级到最新版本的log4j。

###### 修复方式
方式1: 项目升级JDK版本到1.7以上，然后再升级log4j-core(同JDK7+修复方案)。
方式2: 停止使用log4j，改用slf4j日志门面的其他实现包(例如logback 1.2.7及以上版本等 )。
