---
title: PHP工具函数-时间工具-判断时间是否在同一周
date: 2019-03-15 19:25:21
tags:
  - PHP
  - 工具函数
  - 时间函数
categories: rd
---

### PHP判断两个时间是否在同一周

> 业务场景：
  公司需要获取上周的汇总数据，由于放到redis中需要判断数据是否过期或者可用

想法：判断第一个时间的时间戳 是否是第二个时间所在周的时间戳的 区间内

> 利用strtotime('monday')方法取到下周一 strtotime('monday -7 day') 则取到本周一
  利用strtotime('sunday')方法取到本周日


存在问题：由于php代码的每周第一天是从周日开始的 所以如果今天是周一的话 `strtotime('monday -7 day')` 获取的就是上周一
Fix: 利用date('w') 判断今天是周一的话，开始时间就加一周


上完整代码

```php
    public function time_in_same_week($preDate, $afterDate) {
        $flag = false;//默认不是同一周
        $preTime = strtotime($preDate);
        $afterTime = strtotime($afterDate);

        $week = date('w', $afterTime);
        //        echo $week . PHP_EOL;
        $mintime = strtotime('monday -7 day', $afterTime) + ($week == 1 ? 7 * 3600 * 24 : 0);//一周开始时间; 解决今天的下周一是今天(如果今天是周一就会出现这个情况)
        //        echo '一周开始时间'.date('Y-m-d', $mintime).PHP_EOL;
        $maxtime = strtotime('sunday', $afterTime);//一周结束时间
        //        echo '一周结束时间'.date('Y-m-d', $maxtime).PHP_EOL;
        if ($preTime >= $mintime && $preTime <= $maxtime) {//同一周
            $flag = true;
        }
        return $flag;
    }
```