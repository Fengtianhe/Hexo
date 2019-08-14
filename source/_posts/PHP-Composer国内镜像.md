---
title: PHP-Composer国内镜像
date: 2019-08-14 11:31:26
tags:
  - PHP
  - Composer
categories: rd
---
### 加速原理
***
Composer 安装时候会向国外的 Packagist 服务器发送请求，因为众所周知的原因，国内请求国外服务器，有时会出现不稳定甚至不可用的情况。

镜像加速就是把国外的数据缓存到国内的服务器上，Composer 客户端只需配置服务器为国内的服务器，即可从国内服务器上下载，稳定性会有很高的提升。

### 要点一：全量与非全量镜像
***
Composer 安装扩展包的时候，一般会发起两种请求：

JSON 请求 —— 扩展包元信息，包括 zip 包的下载链接；
Zip 包请求 —— 扩展包源码压缩包。
全量镜像指的是以上两种请求都使用国内服务器加速。而非全量服务器一般只缓存 JSON 数据。

### 要点二、更新时间
***
当一个 PHP 扩展包从 GitHub 上发布新版本的时候，Packagist.org 上会接收到回调并记录新版本的信息。与 GitHub 的回调相比，国内镜像只能通过主动请求 Packagist.org 的方式来获取更新的扩展包版本。

更新时间指的是国内镜像服务器更新请求的频率，意味着当你在 GitHub 上发布了新版本，此新版本需要多长时间才能在国内的镜像服务器上出现。

故更新时间越短越好。

### 阿里云 Composer 全量镜像（推荐）
***
镜像类型：全量镜像
更新时间：1 分钟
镜像地址：https://mirrors.aliyun.com/composer/
官方地址：https://developer.aliyun.com/composer
镜像说明：阿里云 CDN 加速，更新速度快，推荐使用

### 安畅网络镜像
***
镜像类型：全量镜像
更新时间：1 分钟
镜像地址：https://php.cnpkg.org
官方地址：https://php.cnpkg.org/
镜像说明：此 Composer 镜像由安畅网络赞助，目前支持元数据、下载包全量代理。

### 交通大学镜像
***
镜像类型：非全量镜像
镜像地址：https://packagist.mirrors.sjtug.sjtu.edu.c...\
官方地址：https://mirrors.sjtug.sjtu.edu.cn/packagis...\
镜像说明：上海交通大学提供的 composer 镜像，稳定、快速、现代的镜像服务，推荐使用。

### Laravel China 镜像（deprecated）
***
镜像类型：全量镜像
更新时间：10 分钟
镜像地址：https://packagist.laravel-china.org
官方地址：镜像详情
镜像说明：Laravel China 社区镜像，将于 2019 年 9 月 4 号停用。详见：博客：Laravel China 镜像完成历史使命，将于两个月后停用