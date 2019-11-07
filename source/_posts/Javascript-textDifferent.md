---
title: Javascript Text Different
date: 2019-11-07 10:18:37
tags: 
  - Javascript
---
> 实现工商信息变更样式

效果图：
![](/images/js_text_diff.png)

```
    function diff(){
		let oldStr = '技术开发、技术推广、技术咨询、技术服务；软件开发；组织文化艺术交流活动（不含演出）；承办展览展示；销售新鲜蔬菜、新鲜水果、文化用品、工艺品、日用品、厨房用具；零售电子产品。依法须经批准的项目，经相关部门批准后依批准的内容开展经营活动。'
		let newStr = '销售食品。技术开发、技术推广、技术咨询、技术服务；软件开发；组织文化艺术交流活动（不含演出）；承办展览展示；销售文化用品、工艺品、日用品、厨房用具、销售食品以及依法须经批准的项目，经相关部门批准后依批准的内容开展经营活动。'
        // 通过符号分割成数组
		let oldStrArr = oldStr.split(/[、；，。]/)
		let diffNewStr = newStr
        // 将完全相同的部分替换掉
		for(let key of oldStrArr){
			diffNewStr = diffNewStr.replace(key, '')
		}
        // 去除新字符串中替换掉的空字符串
		let diffNewArr = diffNewStr.split(/[、；，。]/).filter(item => {return !!item})
		let strWithDiff = ''
        // 将新的字符串中不同的部分标红
		for(let addStr of diffNewArr){
			strWithDiff = newStr.replace(addStr, `<span style="color:red">${addStr}</span>`)
		}
		return strWithDiff
	}
```
