---
title: NodeJS-NodeSass安装下载binding.node过慢
date: 2020-01-04 23:01:38
tags:
  - JS
  - NodeJS
  - node_modules
  - node-sass 
categories: fe
---
在项目根目录下用这行命令：
```
node -p "[process.platform, process.arch, process.versions.modules].join('-')"
```

复制输出的结果，去 Release 列表 找到对应的版本，Ctrl+F 粘贴，找到那个文件，下载（必要的时候挂代理，浏览器下载通常都比 node 下载更快更稳定），然后文件存到一个稳定的路径，并复制路径

设置sass路径
Windows:
```
set SASS_BINARY_PATH=D:/nodejs/.nodes/xxxxxxx_binding.node
```
MacOS:
```
export SASS_BINARY_PATH=/Users/xxxx/xxxxxxx_binding.node
```
然后安装node-sass模块

npm i node-sass -D --verbose
之后重新install就可以了