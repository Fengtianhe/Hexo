---
title: '快速开发基于AndroidWebView的WebApp[2]----显示一个baidu'
date: 2018-03-08 18:07:17
tags:
- Android
categories: rd
---
在上一节中我们只新建了一个项目， 在这一节中， 我们要显示一个baidu 来达到webview的效果

## 1.允许联网

允许网络权限！允许网络权限！允许网络权限！没网还玩个蛋

在src/main/res下的AndroidManifest.xml中添加

`<uses-permission android:name="android.permission.INTERNET" />`

## 2.创建一个layout显示webview的区域

在src/main/res下有个layout目录(没有则手动创建)加一个activity_main.xml

```
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/activity_main"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    tools:context="com.example.fengtianhe.webviewdemo.MainActivity">
    <!-- 这里的tools:context要和你项目包保持一致 -->

    <WebView
        android:id="@+id/webView1"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:scrollbars="vertical"
        android:layout_below="@+id/action_bar" />

</LinearLayout>
```

## 3.创建Activity类
在你的src/main/java/com.****.****下创建一个继承AppCompatActivity的类
```
package com.example.fengtianhe.webviewdemo;

import android.support.v7.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
}
```

在类中定义一个webview变量，并且复写一个oncreate的类
`WebView mWebview;`
```
package com.example.fengtianhe.webviewdemo;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.webkit.WebView;

public class MainActivity extends AppCompatActivity {
    WebView mWebview;

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mWebview = (WebView) findViewById(R.id.webView1); //获取窗口
        mWebview.loadUrl("http://www.baidu.com/"); //加载网址
    }
}
```

修改AndroidManifest.xml设置主activity
```
<application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme" >
        <activity android:name="com.example.fengtianhe.webviewdemo.MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
```

运行项目提示如下,
![](/images/20180308-8.jpg)

这就很操蛋了， 我们想做一个app，这又让用浏览器打开。 不行，我们得用自己的窗口打开，搞他

```
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends AppCompatActivity {
    WebView mWebview;

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mWebview = (WebView) findViewById(R.id.webView1);

        mWebview.setWebViewClient(new WebViewClient(){
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }
        });

        mWebview.loadUrl("http://www.baidu.com/");
    }
}
```

搞定

![](/images/20180308-9.jpg)

