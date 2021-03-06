---
title: Android 发布部署限制
date: 2019-02-25 17:11:30
tags:
    - 项目发布
    - ReactNative
    - Android
categories: fe
author: 冯天鹤
---

> 由于进入创业公司，没有一套完整的开发流程，每个人都有不同的开发方式，导致线上出线bug
  Bug原因：由于android项目，发布部署的分支没有被限制导致用户使用了开发分支的版本。
  解决：在编译脚本中添加限制

脚本中使用git 的 tag 和appVersionName 限制了编译版本，以供参考，具体业务具体修改

```bash
echo "编译正式版本！编译过程中会出现很多信息，请确认："

curr_branch=`git symbolic-ref --short -q HEAD`
echo "当前分支：$curr_branch"
build_branch='master'

if [[ "$curr_branch" != "$build_branch" ]];then
    echo "当前不是master分支，不编译"
    exit
fi

#xargs 实现 trim 功能
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1` | xargs)
#读取AndroidManifest文件第6行versionName配置
app_version=`sed -n "6p" ./CainiaoCRM/src/main/AndroidManifest.xml | sed -e 's/android:versionName=\"\(.*\)\">/\1/' | xargs`
echo "最新tag：$latest_tag"
echo "当前app编译版本：$app_version"

if [[ "$latest_tag" != "$app_version" ]];then
    #确认版本号
    echo "当前App编译版本和Tag版本不同，是否继续编译(y/n)："
    read USER_CONFIRM_VERSION

    if [[ "$USER_CONFIRM_VERSION" = "n" ]] || [[ "$USER_CONFIRM_VERSION" = "N" ]] || [[ -z "$USER_CONFIRM_VERSION" ]];then
        echo "结束编译"
        exit
    fi

    #创建Tag
    echo "当前App编译版本和Tag版本不同，是否创建新版本Tag(y/n)："
    read USER_CONFIRM_CREATE_TAG

    if [[ "$USER_CONFIRM_CREATE_TAG" = "n" ]] || [[ "$USER_CONFIRM_CREATE_TAG" = "N" ]] || [[ -z "$USER_CONFIRM_CREATE_TAG" ]];then
        echo "结束编译"
        exit
    else
        git push origin ${app_version}
    fi
fi


echo "开始编译...."
```