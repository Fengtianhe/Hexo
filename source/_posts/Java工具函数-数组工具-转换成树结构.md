---
title: Java工具函数-数组工具-转换成树结构.md
date: 2019-03-15 19:25:21
tags:
  - Java
  - 工具函数
  - 数组函数
categories: rd
---

### Java将原始List转为Tree

```java
    public static void main(String[] args) {
        @Data
        class ListItem {
            private Integer id;
            private String name;
            private Integer pid;
            private List<ListItem> children;

            public ListItem(Integer id, String name, Integer pid) {
                this.id = id;
                this.name = name;
                this.pid = pid;
            }
        }

        List<ListItem> lists = new ArrayList<>();
        lists.add(new ListItem(1, "部门A", 0));
        lists.add(new ListItem(2, "部门b", 0));
        lists.add(new ListItem(3, "部门v", 1));
        lists.add(new ListItem(4, "部门d", 1));
        lists.add(new ListItem(5, "部门e", 2));
        lists.add(new ListItem(6, "部门f", 3));
        lists.add(new ListItem(7, "部门g", 2));
        lists.add(new ListItem(8, "部门h", 4));

        Map<Integer, ListItem> map = lists.stream().collect(Collectors.toMap(ListItem::getId, ListItem -> ListItem));
        List<ListItem> res = new ArrayList<>();
        lists.forEach(item -> {
            if (item.getPid() == 0) {
                res.add(item);
            } else if (map.get(item.getPid()) != null) {
                ListItem parent = map.get(item.getPid());
                parent.setChildren(CollectionUtils.isEmpty(parent.getChildren()) ? new ArrayList<>() : parent.getChildren());
                parent.getChildren().add(item);
            }
        });
        System.out.println(res.toString());
    }
```
