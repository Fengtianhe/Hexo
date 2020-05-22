---
title: JS工具函数-Array工具.md
date: 2020-03-30 15:00:00
tags:
  - JS
  - 工具类
  - Array函数    
categories: fe
---

```javascript
    export default {
      /***
      * 将原始数组转换成树结构
      * @param {list}  [
                        { id: 1, name: '部门A', parentId: 0 },
                        { id: 2, name: '部门B', parentId: 0 },
                        { id: 3, name: '部门C', parentId: 1 },
                        { id: 4, name: '部门D', parentId: 1 },
                        { id: 5, name: '部门E', parentId: 2 },
                        { id: 6, name: '部门F', parentId: 3 },
                        { id: 7, name: '部门G', parentId: 2 },
                        { id: 8, name: '部门H', parentId: 4 }
                      ]
      */
      toTree(list){
        const res = []
        const map = list.reduce((res, v) => (res[v.id] = v, res), {})
        
        for (const item of list) {
          if (item.parentId === 0) {
            res.push(item)
            continue
          }
          if (item.parentId in map) {
            const parent = map[item.parentId]
            parent.children = parent.children || []
            parent.children.push(item)
          }
          console.log(JSON.parse(JSON.stringify(res)))
        }
      }
    };
```
