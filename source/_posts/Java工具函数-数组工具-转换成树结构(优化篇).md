---
title: Java工具函数-数组工具-转换成树结构(优化篇).md
date: 2019-03-15 19:25:21
tags:
  - Java
  - 工具函数
  - 数组函数
categories: rd
---
在之前的文章提到利用红黑树将列表转为树结构，后来，我又利用反射机制将方法公共化

### Java将原始List转为Tree

```java
    public class TreeHelper {
        private String primaryKey;
    
        private String parentKey;
    
        private String childrenKey;
    
        private String superFlag;
    
        public TreeHelper(String primaryKey, String parentKey, String childrenKey, String superFlag) {
            this.primaryKey = primaryKey;
            this.parentKey = parentKey;
            this.childrenKey = childrenKey;
            this.superFlag = superFlag;
        }
    
        public <T> List<T> covert(List<T> lists) throws NoSuchFieldException, IllegalAccessException {
            Class clazz = lists.get(0).getClass();
            // 获取到对应字段
            Field field = clazz.getDeclaredField(this.primaryKey);
            Field parentField = clazz.getDeclaredField(this.parentKey);
            Field childListField = clazz.getDeclaredField(this.childrenKey);
            // 使对应字段可操作
            field.setAccessible(true);
            parentField.setAccessible(true);
            childListField.setAccessible(true);
            // 转成map
            Map<String, T> map = new HashMap<>();
            for (T t : lists) {
                map.put((String.valueOf(field.get(t))), t);
            }
    
            // 利用红黑树组装树结构
            List<T> res = new ArrayList<>();
            for (T item : lists) {
                if ((String.valueOf(parentField.get(item)).equals(this.superFlag))) {
                    res.add(item);
                    continue;
                }
                Object parent = map.get(String.valueOf(parentField.get(item)));
                if (parent != null) {
                    List children =(List) childListField.get(parent);
                    if(CollectionUtils.isEmpty(children)){
                        children = new ArrayList();
                    }
                    childListField.set(parent, children);
                    children.add(item);
                }
            }
            return res;
        }
    }
```


### 测试
```java
    public static void main(String[] args) throws NoSuchFieldException, IllegalAccessException {
        List<TreeItem> items = new ArrayList<>();
        items.add(new TreeItem(1, 0, "1"));
        items.add(new TreeItem(2, 1, "2"));
        items.add(new TreeItem(3, 0, "3"));
        items.add(new TreeItem(4, 2, "4"));
        items.add(new TreeItem(5, 1, "5"));
        items.add(new TreeItem(6, 3, "6"));

        TreeHelper treeHelper = new TreeHelper("id", "pid", "children", "0");
        List<TreeItem> c = treeHelper.covert(items);
        System.out.println(c);
    }

    public static class TreeItem {
        private Integer id;
        private Integer pid;
        private String name;
        private List<TreeItem> children;

        public TreeItem(Integer id, Integer pid, String name) {
            this.id = id;
            this.pid = pid;
            this.name = name;
        }

        public Integer getId() {
            return id;
        }

        public void setId(Integer id) {
            this.id = id;
        }

        public Integer getPid() {
            return pid;
        }

        public void setPid(Integer pid) {
            this.pid = pid;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public List<TreeItem> getChildren() {
            return children;
        }

        public void setChildren(List<TreeItem> children) {
            this.children = children;
        }

        @Override
        public String toString() {
            return "TreeItem{" +
                    "id=" + id +
                    ", pid=" + pid +
                    ", name='" + name + '\'' +
                    ", children=" + children +
                    '}';
        }
    }
```
