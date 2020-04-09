---
title: SpringCloud源码--SpringCloudConfig工作流程
date: 2020-04-09 18:25:22
tags:
    - SpringCloud
categories: rd
author: 冯天鹤
---

>  首先，我是前端 转 PHP 转 JAVA 的以为小白，文中讲的不对的地方请提出来，也欢迎来喷

>  起因是我司使用Eureka注册中心和 Configserver配置中心来达到多服务共享配置的问题，我好奇是如何从配置中心获取配置后，将配置写入消费方的。
这便引发了我4个小时追代码的过程

---
### Eureka
废话不多说，首先说说Eureka是个什么东西，其实我也不知道是啥！
首先先上一张看不懂的图片，好吧我承认，这是我看过理解最快的一张图片了
![image.png](https://upload-images.jianshu.io/upload_images/2663172-412e93107d771ded.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
[Eureka](https://github.com/Netflix/Eureka) 是 [Netflix](https://github.com/Netflix) 开发的，一个基于 REST 服务的，服务注册与发现的组件

它主要包括两个组件：Eureka Server 和 Eureka Client

*   Eureka Client：一个Java客户端，用于简化与 Eureka Server 的交互（通常就是微服务中的客户端和服务端）
*   Eureka Server：提供服务注册和发现的能力（通常就是微服务中的注册中心）

各个微服务启动时，会通过 Eureka Client 向 Eureka Server 注册自己，Eureka Server 会存储该服务的信息

也就是说，每个微服务的客户端和服务端，都会注册到 Eureka Server，这就衍生出了微服务相互识别的话题

*   同步：每个 Eureka Server 同时也是 Eureka Client（逻辑上的）
    　　　多个 Eureka Server 之间通过复制的方式完成服务注册表的同步，形成 Eureka 的高可用
*   识别：Eureka Client 会缓存 Eureka Server 中的信息
    　　　即使所有 Eureka Server 节点都宕掉，服务消费者仍可使用缓存中的信息找到服务提供者**（笔者已亲测）**
*   续约：微服务会周期性（默认30s）地向 Eureka Server 发送心跳以Renew（续约）信息（类似于heartbeat）
*   续期：Eureka Server 会定期（默认60s）执行一次失效服务检测功能
    　　　它会检查超过一定时间（默认90s）没有Renew的微服务，发现则会注销该微服务节点

Spring Cloud 已经把 Eureka 集成在其子项目 Spring Cloud Netflix 里面

>  以上都是拷贝的，说白了，Eureka做的就是接口转发的概念
---

### SpringCloudConfig
Spring Cloud Config 的官方介绍文档地址如下：
https://cloud.spring.io/spring-cloud-static/Finchley.RELEASE/single/spring-cloud.html#_spring_cloud_config

英语好的自己读吧，我是懒得看

大致意思是，Spring Cloud Config 提供一种基于客户端与服务端（C/S）模式的分布式的配置管理。我们可以把我们的配置管理在我们的应用之外（config server 端），并且可以在外部对配置进行不同环境的管理，比如开发/测试/生产环境隔离，并且还能够做到实时更新配置。

---
现在要看是追源码了！！！

首先，配置文件中找到了Eureka的配置项
```
spring.application.name=quickstart-sample
eureka.client.serviceUrl.defaultZone=${QUICKSTART_EUREKAS:http://${QUICKSTART_USERNAME:admin}:${QUICKSTART_PASSWORD:123123}@localhost:20000/eureka/}
spring.cloud.config.profile=framework,test
spring.cloud.config.label=development-wayne
spring.cloud.config.discovery.enabled=true
spring.cloud.config.discovery.serviceId=configserver
spring.cloud.config.username=${QUICKSTART_USERNAME:admin}
spring.cloud.config.password=${QUICKSTART_PASSWORD:123123}
```

找到这些，我依旧是一头雾水，好吧，我自闭了~~~我想放弃了~~
开了15分钟小差，我决定从Maven包下手

在项目中找到`spring-cloud-config-client-2.1.0.RELEASE.jar`这个JAR包，并随便打开一个文件下载源码（听起来好高大上，我大PHP直接看vendor什么时候还要下载源码，哼~~）

全局搜索`serviceId`
![image.png](https://upload-images.jianshu.io/upload_images/2663172-f6f68daaa8500575.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
看，这里有用到诶！！
那既然有 `set` 那就一定有 `get`，我继续找下去，找到`getServiceId()`的调用方出现了
![image.png](https://upload-images.jianshu.io/upload_images/2663172-ce4b8b273fa45c46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

无意间看了眼上面，嗯~~   我猜这应该是心跳吧，他是定时的从配置中心获取配置。

继续走~
![](https://upload-images.jianshu.io/upload_images/2663172-d5e4b98307275086.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
在源码的127行我发现了`this.config.setUri(uri)`字眼，无奈的看了下下面只剩下catch了，算了，就研究这个config吧！
![image.png](https://upload-images.jianshu.io/upload_images/2663172-3a0e41e3c848ffd1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
一样的思维，有`set` 就一定有 `get`
![image.png](https://upload-images.jianshu.io/upload_images/2663172-e49383266cce477a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
在这里我找到了最终获取数据的地方
```
response = restTemplate.exchange(uri + path, HttpMethod.GET, entity,
						Environment.class, args);
```
接下来就涉及到返回数据的地方了，转眼到`spring-cloud-config-server-2.1.0.RELEASE.jar`这个包中，我们可以看到SpringCloudConfig定义了一个名为`EnvironmentController`这样的控制器。

在控制器中我们找到了根据上面`uri + path`的方式请求的入口，
```
@RequestMapping("/{name}/{profiles}/{label:.*}")
	public Environment labelled(@PathVariable String name, @PathVariable String profiles,
			@PathVariable String label) {
		if (name != null && name.contains("(_)")) {
			// "(_)" is uncommon in a git repo name, but "/" cannot be matched
			// by Spring MVC
			name = name.replace("(_)", "/");
		}
		if (label != null && label.contains("(_)")) {
			// "(_)" is uncommon in a git branch name, but "/" cannot be matched
			// by Spring MVC
			label = label.replace("(_)", "/");
		}
		Environment environment = this.repository.findOne(name, profiles, label);
		if(!acceptEmpty && (environment == null || environment.getPropertySources().isEmpty())){
			 throw new EnvironmentNotFoundException("Profile Not found");
		}
		return environment;
	}
```
我这里在配置文件中设置了`spring.cloud.config.server.jdbc=true`所以我这里是走的数据库，还有其他的读取配置方式，可自行查阅
根绝我设置的jdbc方式
上面的`findOne`使用了`JdbcEnvironmentRepository`中的实现方式
最后在第95行找到了
```
Map<String, String> next = (Map<String, String>) jdbc.query(this.sql,
						new Object[] { app, env, label }, this.extractor);
```
这里的sql可通过配置`spring.cloud.config.server.jdbc.sql`进行复写
如果没有复写，那么就使用`JdbcEnvironmentProperties`中默认的SQL语句`SELECT KEY, VALUE from PROPERTIES where APPLICATION=? and PROFILE=? and LABEL=?`

好了，configserver完成了他的任务(东西好少啊，感觉很容易就找到了)。回过头，我们又要看消费方拿到了返回值做了些什么！！

在`ConfigServicePropertySourceLocator`文件中我们看到，其实configserver做了一个拦截，在启动的时候把配置写了进去

在同文件104行终于找到了最后的方法，通过`CompositePropertySource`将配置加载到程序中
```
for (PropertySource source : result.getPropertySources()) {
	@SuppressWarnings("unchecked")
	Map<String, Object> map = (Map<String, Object>) source
							.getSource();
	composite.addPropertySource(new MapPropertySource(source.getName(), map));
}
```


> 其实我想追一下`CompositePropertySource`的源码，但是我饿~~~~~~了,
 第一次写看源码的笔记，可能有些地方我自己懂了就跳过了，如果哪里没写出来，欢迎提出来
