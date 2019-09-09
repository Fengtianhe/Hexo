---
title: ReactNative-组件react-native-camera
date: 2019-09-09 11:28:27
tags:
   - ReactNative
   - node_modules
categories: fe
---
### ReactNative版本 < 0.60.0
#### 1.1、安装  `react-native-camera@2.9.0` 版本
将 `missingDimensionStrategy 'react-native-camera', 'general'` 加入到 android/app/build.gradle 中
```
android {
    ...
    defaultConfig {
        ...
        missingDimensionStrategy 'react-native-camera', 'mlkit'
    }
    ...
}
```

#### 1.2、修改 `android/build.gradle` 中的 classpath
```
buildscript {
    ext {
        buildToolsVersion = "28.0.3"
        minSdkVersion = 16
        compileSdkVersion = 28
        targetSdkVersion = 28
        supportLibVersion = "28.0.0"
    }
    repositories {
        google()
        jcenter()
    }
    dependencies {
        // 注意这里的版本
        classpath('com.android.tools.build:gradle:3.3.0')

        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        mavenLocal()
        google()
        jcenter()
        maven {
            // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
            url "$rootDir/../node_modules/react-native/android"
        }
    }
}

```
#### 1.3、修改 android/gradle/wrapper/gradle-wrapper.properties 中的 gradle version
```
distributionUrl=https\://services.gradle.org/distributions/gradle-4.10.1-all.zip
```

#### 1.4、修改打包配置 `app/build.gradle`
```
android {
    ...
    packagingOptions {
        exclude 'META-INF/proguard/androidx-annotations.pro'
    }
}
```