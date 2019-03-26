---
title: Vue 项目部署
date: 2019-03-26 18:55:36
tags:
    - vue
    - 项目发布
category: fe
---
首先要配置服务器ssh免密登录

deploy.sh
```
#!/bin/sh
#获取环境名
env=''

if [ x$1 != x ];then
    env=$1
else
    env='prod'
fi

#获取当前分支名
curr_branch=`git symbolic-ref --short -q HEAD`
echo '当前工作分支 => '${curr_branch}'\n'

echo '读取配置文件:'
deploy_branch=`sed '/^'${env}_branch'=/!d;s/.*=//' deploy.conf`
deploy_host=`sed '/^'${env}_host'=/!d;s/.*=//' deploy.conf`
deploy_port=`sed '/^'${env}_port'=/!d;s/.*=//' deploy.conf`
deploy_user=`sed '/^'${env}_user'=/!d;s/.*=//' deploy.conf`
deploy_path=`sed '/^'${env}_path'=/!d;s/.*=//' deploy.conf`
deploy_bak_path=`sed '/^'${env}_bak_path'=/!d;s/.*=//' deploy.conf`
deploy_script=`sed '/^'${env}_script'=/!d;s/.*=//' deploy.conf`
echo '分支 => '${deploy_branch}
echo '地址 => '${deploy_host}
echo '端口 => '${deploy_port}
echo '用户 => '${deploy_user}
echo '路径 => '${deploy_path}
echo '备份路径 => '${deploy_bak_path}
echo '脚本 => '${deploy_script}
echo '\n'

echo '储存当前修改'
git stash
echo '\n'

echo '切换到需发布的分支 => '${deploy_branch}
git checkout $deploy_branch
echo '\n'

echo '编译项目'
npm run ${deploy_script}
echo '\n'

echo '备份老版本'
curr_datetime=`date +%Y%m%d%H%M%S`
ssh ${deploy_user}@${deploy_host} -p ${deploy_port} "mv $deploy_path $deploy_bak_path/bak_$curr_datetime"
echo '上传新版本'
scp -P ${deploy_port} -r ./dist/ ${deploy_user}@${deploy_host}:${deploy_path}
echo '\n'

echo '切回工作分支 => '${curr_branch}
git checkout $curr_branch
echo '\n'

echo '释放修改'
git stash pop
echo '\n'

echo '部署成功'
```

deploy.conf
```
alpha_branch=alpha
alpha_host=xxxx
alpha_port=xxxx
alpha_user=xxxx
alpha_path=xxxxx
alpha_bak_path=xxxxx
alpha_script=build_alpha

test_branch=测试环境分支名
test_host=测试环境机器ip
test_user=测试环境机器用户
test_path=测试环境项目路径

preview_branch=preview
preview_host=xxxx
preview_port=xxxx
preview_user=xxxx
preview_path=xxxx
preview_bak_path=xxxx
preview_script=build_preview

prod_branch=master
prod_host=xxxx
prod_port=xxxx
prod_user=xxxx
prod_path=xxxx
prod_bak_path=xxxx
prod_script=build

```

使用 `sh deploy.sh [prefix]`

xxx_script 是在webpack中用不同的build 配置文件打包的