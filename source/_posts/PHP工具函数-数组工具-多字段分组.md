---
title: PHP工具函数-数组工具-多字段分组
date: 2019-03-29 18:08:35
tags:
  - PHP
  - 工具函数
  - 时间函数
categories: rd
---

```php
function array_group_by($arr, $key)
    {
        if (empty($arr)) {
            return [];
        }
        $grouped = [];
        foreach ($arr as $value) {
            $grouped[$value[$key]][] = $value;
        }
        // Recursively build a nested grouping if more parameters are supplied
        // Each grouped array value is grouped according to the next sequential key
        if (func_num_args() > 2) {
            $args = func_get_args();
            foreach ($grouped as $key => $value) {
                $parms = array_merge([$value], array_slice($args, 2, func_num_args()));
                $grouped[$key] = call_user_func_array('array_group_by', $parms);
                // 上面是当前方法作为全局方法使用，下面是吧方法写在类中的使用 详见 call_user_func_array()
                // $grouped[$key] = call_user_func_array([$this, 'array_group_by'], $parms);
            }
        }
        return $grouped;
    }
```