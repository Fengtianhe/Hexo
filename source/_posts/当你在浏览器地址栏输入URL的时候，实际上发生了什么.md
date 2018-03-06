---
title: 当你在浏览器地址栏输入URL的时候，实际上发生了什么
date: 2018-03-02 15:08:31
tags:
---

作为一个软件开发，你一定十分了解web应用程序如何工作并且有什么技术涉及其中：浏览器，HTTP，HTML，web服务器，请求处理等等。

在这篇文章中，我们将会深入的了解一下，当你在浏览器地址栏输入URL的时候，实际上发生了什么

## 你在地址栏输入了一个URL地址

![Alt text](/images/20180302-1.png)

## 浏览器查询域名对应的IP地址

![Alt text](/images/20180302-2.png)

首先浏览器先去寻找访问过的域名的IP地址，DNS查询的过程如下：

* Browser cache 
浏览器缓存DNS记录。有趣的是，操作系统没有告诉浏览器每一个DNS记录存活时长，因此浏览器缓存记录是一个固定的时长。(根据浏览器的不同而不同，一般是2-30分钟)
* OS cache
如果浏览器没有查询到用户查询的记录。那么会查询操作系统是否存在这条记录
* Router cache
如果用户的操作系统也没有查询到，那么会继续查询路由(router)，一般可以查询到DNS缓存
* ISP DNS cache
如果没有在router 中查询到，下一个查询的的地方是ISP的DNS 的服务器。
* Recursive search
你的ISP的DNS服务器开始递归搜索，从根域名服务器开始，经过.com顶级域名服务器，一直到脸谱网的域名服务器。通常情况下，DNS服务器可以查询到COM域名服务器的缓存，所以向根域名服务器查询一般不必要的。


  如下是DNS查询递归示意图
  ![Alt text](/images/20180302-3.png)

## 浏览器向web服务器发送HTTP

![Alt text](/images/20180302-4.png)

可以很确定的是一个网站的页面是不会缓存在浏览器中的，因为一个动态页面很快就会过期
因此浏览器将要向服务器发送请求

![Alt text](/images/20180302-5.png)
以上是指向http://facebook.com/ 发起了GET请求。浏览器通过(user agent)标示自己，通过(Accept and Accept-Encoding headers)告诉服务器希望接受的字符串编码和数据类型。(Connection header)会告诉服务器在未来的一段时间内保持TCP链接

该请求还包含浏览器对该域的cookie。正如您可能已经知道的，cookie是键值值对，它们跟踪不同页面请求之间的Web站点的状态。因此，cookie存储登录用户的名称、服务器分配给用户的密钥、用户的一些设置等。cookie将存储在客户机的文本文件中，并随每个请求发送到服务器。

## 服务器永久重定向响应

对于浏览器的请求，服务器发送如下响应
![Alt text](/images/20180302-6.png)

服务器响应301(永久重定向)，告诉浏览器去 http://www.facebook.com/ 请求 而不是“http://facebook.com/”

## 浏览器遵循重定向

![Alt text](/images/20180302-7.png)
浏览器知道了 http://www.facebook.com/ 是正确的URL地址，重新发送一个请求
![Alt text](/images/20180302-8.png)

## 服务器处理请求

服务器接受get请求，处理它然后发送响应
他看上去是一个简单的任务，实际上有很多有趣的东西发生
* web server software
web服务器软件(例如IIS或则apache)接受http请求并且决定哪一个请求处理器去执行并处理这个请求。一个请求处理器就是一段代码（ASP，NET，PHP...),这段代码用于分析请求并且生成HTML代码作为响应。
* request handler 
请求处理器处理请求参数，cookies等。他将会处理并更新一些保存在服务器上的数据。然后生成HTML响应代码

## 服务器返回html响应

![Alt text](/images/20180302-9.png)

如下是服务器生成并发送回来的响应

![Alt text](/images/20180302-10.png)

这个（Content-encoding）告诉浏览器这个响应的内容是经过gzip算法压缩过的，解压后将看到html结构
![Alt text](/images/20180302-11.png)

除了压缩以外，headers还标示了是否缓存页面，cookies信息和一些隐私信息等。

## 浏览器渲染HTML

当浏览器接受到整个HTML文档之前，就开始渲染页面

## 浏览器对嵌入在html中的资源发送请求

![Alt text](/images/20180302-12.png)

当浏览器渲染HTML的时候，他会注意到包含其它地址的标签。浏览器将会发送请求去获取这些文件

![Alt text](/images/20180302-13.png)
每一个URL所要经历的过程是和HTMl页面经历过程一样的。因此，浏览器也会经历：查询DNS，发送请求，重定向等。

对于静态资源（不像动态的页面）浏览器是可以去缓存他的。一些文件资源可以不请求服务器获取，而直接从缓存获取。浏览器知道缓存一个资源多久因为服务器响应包含一个过期头信息(Expires header)。除此之外，每一个响应也包含ETag（一个版本号）--如果浏览器发现一个已经存在的文件有Etag，他将立即停止请求。

## 浏览器发送异步请求(AJAX)
![Alt text](/images/20180302-14.png)

在web2.0时代，即使在页面呈现后，客户机仍继续与服务器通信。

例如，facebook聊天将继续更新你的登录朋友的名单.为了更新登录好友的列表，浏览器中执行的JavaScript必须向服务器发送异步请求。异步请求是一个以编程方式构建的GET或POST请求，该请求指向一个特殊URL。在facebook的例子中，客户端发送一个POST请求到 'http://www.facebook.com/ajax/chat/buddy_list.php' 去取名单您的在线的朋友。

这种模式有时被称为“Ajax”，它代表“异步JavaScript和XML”，没有特定要求服务器必须将响应格式化为XML。例如，facebook响应异步请求返回JavaScript代码片段。

[原文链接](http://igoro.com/archive/what-really-happens-when-you-navigate-to-a-url/)











