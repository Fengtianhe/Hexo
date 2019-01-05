---
title: 快速入门SpringBoot(三)----controller的使用
date: 2018-03-06 19:04:50
tags:
- Java
- SpringBoot
categories: rd
---
controller层是现在框架必不可少的一层,在springBoot中controller的使用需要三个很重要的注解

|注解|描述|
|--|--|
|@controller|处理http请求|
|@RestController|返回json数据 等同于@Controller 和 @ResponseBody同时使用|
|@RequestMapping|映射url|

我们先写一个控制器,在控制器中返回一个模版名

![controller](http://upload-images.jianshu.io/upload_images/2663172-d62632eaca0a7bf3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这时候我们使用spring官方的模版 , 在pom.xml中添加依赖
```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```
重新加载maven库 右键pom.xml->maven->reimport

这时我们在src/main/resources/templates/下新建一个index.html文件
在里面随便写点东西
![image.png](http://upload-images.jianshu.io/upload_images/2663172-2ba549d7be59935b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

启动项目看下效果
![image.png](http://upload-images.jianshu.io/upload_images/2663172-0a3e3ecb7e226059.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

***
`@RequestMapping(value = {"/hello","/hi"}, method = RequestMethod.GET)`
如果想多个路径都映射到这个方法可以用这个方式

而在有些做接口的时候我们需要同一个controller有同一个路由的前缀, 那么我们就在类的地方加上注解@RequestMapping(value="/demo")

![image.png](http://upload-images.jianshu.io/upload_images/2663172-20f53d281afe724e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这时候我们再访问http://localhost:8080/hello就报404了

![image.png](http://upload-images.jianshu.io/upload_images/2663172-5fcef2ea951db0da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这时,我们访问http://localhost:8080/hello/say试试

![image.png](http://upload-images.jianshu.io/upload_images/2663172-81a0f4bc25e316df.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以正常使用了
***

在请求controller的时候, 我们会用到一些注解

|注解|描述|
|--|--|
|@PathVeriable|获取url中数据|
|@RequestParams|获取请求参数的值|
|@GetMapping|组合注解 等同于@RequesMapping(method=RequesMethod.GET), 当然还有其他的PostMapping,PutMapping 等等|

说多了都是泪, 让我们先写一个小例子🌰看看@PathVeriable 和 @RequestParams的作用

![image.png](http://upload-images.jianshu.io/upload_images/2663172-ce4a0a23c9f6e08b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](http://upload-images.jianshu.io/upload_images/2663172-a0100d9f78cb13d5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

