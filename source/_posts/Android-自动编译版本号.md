---
title: Android-自动编译版本号
date: 2019-07-25 15:28:48
tags:
    - 项目发布
    - ReactNative
    - Android
categories: fe
author: 冯天鹤
---
> 又开始总结搬砖经验了:
> 在使用ReactNative开发App的时候，在编译时总忘记修改版本号，懒惰的我又开始考虑使用脚本解决我的问题😈

首先我们要看下版本号在哪？
ReactNative在编译的时候会读取`{项目目录}/android/app/build.gradle`下的defaultConfig
```
android {
    ...
    defaultConfig {
        applicationId "com.xxxx"
        minSdkVersion rootProject.ext.minSdkVersion
        targetSdkVersion rootProject.ext.targetSdkVersion
        versionCode 1
        versionName '1.0'
    }
    ...
}
```
我们在每次编译的时候 都要修改`versionCode`和`versionName`
懒惰得我找了度娘，大家一致认为使用git tag 和 git commit count来自动化版本号

***
# 步骤
### 定义获取版本号方法
在`{项目目录}/android/app/build.gradle`中android上方定义方法(前提是当前项目有git tag)
```
def getSelfDefinedVersion(type) {
    def cmd = 'git describe --tags'
    def gitTag = cmd.execute().text.trim()

    Process process = "git rev-list --count HEAD".execute()
    process.waitFor()
    int commitCount = process.getText().toInteger()

    if ("code".equals(type)) {
        return commitCount
    } else if ("name".equals(type)) {
        String today = new Date().format("yyMMdd")
        process = "git describe --always".execute()
        process.waitFor()
        String sha1 = process.getText().trim()
        return "$gitTag.$commitCount.$today.$sha1"
    }
}
```

### 使用函数获取版本号
```
android {
    ...
    defaultConfig {
        applicationId "com.xxxx"
        minSdkVersion rootProject.ext.minSdkVersion
        targetSdkVersion rootProject.ext.targetSdkVersion
        versionCode getSelfDefinedVersion('code') // 改这里
        versionName getSelfDefinedVersion('name') // 改这里
    }
    ...
}
```

### 修改输出文件名
```
android.applicationVariants.all { variant ->
    variant.outputs.all { output ->
        def outputFile = output.outputFile
        if (outputFile != null && outputFile.name.endsWith('.apk')) {
            //这里修改apk文件名
            def fileName = "xxxxx-${defaultConfig.versionCode}-${defaultConfig.versionName}.apk"
            outputFileName = fileName
        }
    }
}
```

### 编译结果
在`android/app/build/generated/source/buildConfig/release/com/xxx/BuildConfig.java`
```
public final class BuildConfig {
  public static final boolean DEBUG = false;
  public static final String APPLICATION_ID = "com.cnmanager";
  public static final String BUILD_TYPE = "release";
  public static final String FLAVOR = "";
  public static final int VERSION_CODE = 15;
  public static final String VERSION_NAME = "v1.0.15.190725.5487385";
}
```
***
在有大版本更新的时候需要改git tag所以我又写了个shell脚本来确认修改git tag
```
#!/usr/bin/env bash

currGitTag=$(git describe --tags `git rev-list --tags --max-count=1` | xargs)
echo "当前tag $currGitTag"

echo '是否有大版本变更？(y/n)(默认：n):'
read USER_CONFIRM_VERSION
if [[ "$USER_CONFIRM_VERSION" = "y" ]] || [[ "$USER_CONFIRM_VERSION" = "Y" ]] || [[ -z "$USER_CONFIRM_VERSION" ]];then
    echo "请输入git tag版本"
    read USER_INPUT_TAG

    git tag ${USER_INPUT_TAG}
    git push --tags
fi

commitCount=`git rev-list --count HEAD`
latestTag=$(git describe --tags `git rev-list --tags --max-count=1` | xargs)
currDate=`date +%y%m%d`
#gitShort=`git describe --always`
versionName="$latestTag.$commitCount.$currDate"
echo "编译版本为：$versionName"
read CONFIRM


cd android && ./gradlew assembleRelease
```