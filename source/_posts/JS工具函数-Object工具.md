---
title: JS工具函数-Object工具.md
date: 2020-03-30 15:00:00
tags:
  - JS
  - 工具类
  - Object函数    
categories: fe
---

```javascript
    export default {
      clone: function(object) {
        return JSON.parse(JSON.stringify(object));
      },
      /**
       * 返回对象的类型
       * @param obj
       * @returns {string}
       */
      toType: function(obj) {
        return {}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
      },
      /**
       * param 将要转为URL参数字符串的对象
       * key URL参数字符串的前缀
       * encode true/false 是否进行URL编码,默认为true
       *
       * return URL参数字符串
       */
      parseParam(param, key, encode) {
        if (param == null) return "";
        var paramStr = "";
        var t = typeof (param);
        if (t === "string" || t === "number" || t === "boolean") {
          paramStr += "&" + key + "=" + ((encode == null || encode) ? encodeURIComponent(param) : param);
        } else {
          for (var i in param) {
            var k = key == null ? i : key + (param instanceof Array ? "[" + i + "]" : "." + i);
            paramStr += this.parseParam(param[i], k, encode);
          }
        }
        return paramStr;
      },
      /**
       * @author 冯天鹤
       * @description 对象通过属性路径获取属性值
       * @param obj example: {user: {name: '王二'}}
       * @param path example: user.name
       * @param strict
       * @returns {*}
       */
      getPropByPath(obj, path, strict) {
        let tempObj = obj;
        path = path.replace(/\[(\w+)\]/g, ".$1");
        path = path.replace(/^\./, "");
        let keyArr = path.split(".");
        let pathLen = keyArr.length;
        for (let i = 0; i < pathLen; ++i) {
          if (!tempObj && !strict) break;
          let pathKey = keyArr[i];
          if (tempObj[pathKey]) {
            tempObj = tempObj[pathKey];
          } else {
            if (strict) {
              throw new Error("please transfer a valid prop path to form item!");
            }
            break;
          }
        }
        return tempObj;
      }
    };
```
