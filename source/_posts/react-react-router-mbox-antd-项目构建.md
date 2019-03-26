---
title: react + react-router + mbox + antd 项目构建
date: 2019-03-26 15:54:00
tags: React
category: fe
---
## 1.初始化项目
### 1.1 安装脚手架
```
npm install -g create-react-app
```
### 1.2 初始化项目
```
npm init react-app project
```
### 1.3 进入项目`src`目录规划目录结构
```
|--- src
    |--- components                 # 放公共组件
        |--- Auth.js                # 权限拦截及校验
    |--- constants                  # 放常量
    |--- helper                     # 放Util // 文件夹名随意，我只是受后端影响，改不过来了
        |--- asyncCompontent.js     # 处理页面按需加载
    |--- images                     # 放图片
    |--- pages                      # 放页面
        |--- index.js               # 入口文件，配置路由
    |--- stores                     # 放react-mobx 的数据文件，如果使用redux 那对应的文件夹就是reducer和action
    |--- styles                     # 放页面样式文件
    |--- index.js                   # 入口文件
    |--- serviceWorker.js           # 服务配置文件
```
---
## 2.安装并配置react-router-dom

>   中文文档：http://react-guide.github.io/react-router-cn/index.html

### 2.1 安装react-router组件
```
npm install react-router-dom --save-dev
```
### 2.2 写两个简单的页面
#### 2.2.1 Login.js
```
import React, {Component} from "react";

export default class Dashboard extends Component {
  render () {
    return (
      <div>
        Login
        <a href="/dashboard">Dashboard</a>
      </div>
    )
  }
}
```
#### 2.2.2 Dashboard.js
```
import React, {Component} from "react";

export default class Dashboard extends Component {
  render () {
    return (
      <div>
        Dashboard
        <a href="/login">Login</a>
      </div>
    )
  }
}
```
#### 2.2.3 page/index.js
```
import React from 'react'
import {Switch, Route, Redirect, withRouter} from 'react-router-dom'
import asyncComponent from "../helper/asyncCompontent";
import Auth from "../components/Auth";

const dashboard = withRouter(asyncComponent(() => import('./admin/Dashboard')))
const login = withRouter(asyncComponent(() => import('./admin/Login')))

export default () => (
  <React.Fragment>
    <Auth/>
    <Switch>
      <Route exact path="/" render={() => <Redirect to="/dashboard"/>}/>
      <Route path="/dashboard" component={dashboard}/>
      <Route path="/login" component={login}/>
    </Switch>
  </React.Fragment>
)
```
#### 2.2.4  asyncCompontent.js
```
import React from 'react'

export default function asyncComponent (importComponent) {
  class AsyncComponent extends React.Component {
    constructor (props) {
      super(props);
      this.state = {
        component: null
      };
    }

    async componentDidMount () {
      const {default: component} = await importComponent();
      this.setState({component});
    }

    render () {
      const C = this.state.component;
      return C ? <C {...this.props}/> : null;
    }
  }

  return AsyncComponent;
}
```
#### 2.2.5 src/index.js
```
/*eslint-disable*/
import React from 'react'
import ReactDOM from 'react-dom'
import {BrowserRouter} from 'react-router-dom'
import App from './pages'
import * as serviceWorker from './serviceWorker'

const render = Component => (
  ReactDOM.render((
    <BrowserRouter>
      <Component/>
    </BrowserRouter>
  ), document.getElementById('root'))
)

render(App)

serviceWorker.unregister();

```
`npm start` 运行简单的页面跳转效果就有了