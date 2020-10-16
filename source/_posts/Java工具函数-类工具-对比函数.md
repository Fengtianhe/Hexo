---
title: Java工具函数-类工具-对比函数.md
date: 2020-10-16 16:14:21
tags:
  - Java
  - 工具函数
  - 类函数
categories: rd
---

### Java对比两个实体类字段的值差异

> 记录这个方法的原因：    
> 需求要求记录一条数据的变更日志，但是由于数据的字段过多，而且我也只想到了通过实体类的对比来判断，所以我在网上查了一下类的比较的方法

##### 网上找到的方法
```java
/**
     * 比较两个实体属性值，返回一个map以有差异的属性名为key，value为一个Map分别存oldObject,newObject此属性名的值
     *
     * @param obj1      进行属性比较的对象1
     * @param obj2      进行属性比较的对象2
     * @param ignoreList 需要忽略的字段
     * @return 属性差异比较结果map
     */
    @SuppressWarnings("rawtypes")
    public static Map<String, List<Object>> compareFields(Object obj1, Object obj2, List<String> ignoreList) {
        try {
            Map<String, List<Object>> map = new HashMap<String, List<Object>>();

            // 只有两个对象都是同一类型的才有可比性
            if (obj1.getClass() == obj2.getClass()) {
                Class claz = obj1.getClass();
                // 获取object的属性描述
                PropertyDescriptor[] pds = Introspector.getBeanInfo(claz,
                        Object.class).getPropertyDescriptors();
                // 这里就是所有的属性了
                for (PropertyDescriptor pd : pds) {
                    // 属性名
                    String name = pd.getName();
                    // 如果当前属性选择忽略比较，跳到下一次循环
                    if (ignoreList != null && ignoreList.contains(name)) {
                        continue;
                    }
                    // get方法
                    Method readMethod = pd.getReadMethod();
                    // 在obj1上调用get方法等同于获得obj1的属性值
                    Object o1 = readMethod.invoke(obj1);
                    // 在obj2上调用get方法等同于获得obj2的属性值
                    Object o2 = readMethod.invoke(obj2);
                    if (o1 instanceof Timestamp) {
                        o1 = new Date(((Timestamp) o1).getTime());
                    }
                    if (o2 instanceof Timestamp) {
                        o2 = new Date(((Timestamp) o2).getTime());
                    }
                    if (o1 == null && o2 == null) {
                        continue;
                    } else if (o1 == null && o2 != null) {
                        List<Object> list = new ArrayList<Object>();
                        list.add(o1);
                        list.add(o2);
                        map.put(name, list);
                        continue;
                    }
                    // 比较这两个值是否相等,不等就可以放入map了
                    if (!o1.equals(o2)) {
                        List<Object> list = new ArrayList<Object>();
                        list.add(o1);
                        list.add(o2);
                        map.put(name, list);
                    }
                }
            }
            return map;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
```

使用的一下确实可以，但是实体类中有些数据不需要对比，那我就需要利用传参，传一个好长的List，太繁琐了， 所以我想通过注解去识别忽略的属性

##### 忽略属性的注解
```java
    import java.lang.annotation.*;
    
    /**
     * @author 冯天鹤
     * @version 1.0
     * @date 2020/10/16
     * content: 用于 CommonClassHelper 中 compareFields() 方法忽略字段的比较
     */
    @Target(ElementType.FIELD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    public @interface IgnoreCompare {
        /**
         * 加上注解默认不做比较
         * @return
         */
        boolean ignore() default true;
    }

```

然后在获取ignoreList 的时候只需要在比较的前边 获取一下就可以了

```java
    /**
     * 获取比较的类中 忽略的字段
     *
     * @param objectClass
     * @return
     */
    private static List<String> getCompareIgnoreFields(Class objectClass) {
        // 获取所有的字段
        Field[] fields = objectClass.getDeclaredFields();
        List<String> map = new ArrayList<>();
        for (Field f : fields) {
            // 判断字段注解是否存在
            boolean annotationPresent2 = f.isAnnotationPresent(IgnoreCompare.class);

            if (annotationPresent2) {
                IgnoreCompare ignoreCompare = f.getAnnotation(IgnoreCompare.class);
                // 获取注解值
                boolean ignore = ignoreCompare.ignore();
                if (ignore) {
                    map.add(f.getName());
                }
            }
        }
        return map;
    }    
```

***

附一个完整的比较方法
```java 
    /**
     * 比较两个实体属性值，返回一个map以有差异的属性名为key，value为一个Map分别存oldObject,newObject此属性名的值
     *
     * @param obj1      进行属性比较的对象1
     * @param obj2      进行属性比较的对象2
     * @return 属性差异比较结果map
     */
    @SuppressWarnings("rawtypes")
    public static Map<String, List<Object>> compareFields(Object obj1, Object obj2, Class clazz) {
        try {
            List<String> ignoreList = getCompareIgnoreFields(clazz);

            Map<String, List<Object>> map = new HashMap<String, List<Object>>();

            // 只有两个对象都是同一类型的才有可比性
            if (obj1.getClass() == obj2.getClass()) {
                Class claz = obj1.getClass();
                // 获取object的属性描述
                PropertyDescriptor[] pds = Introspector.getBeanInfo(claz,
                        Object.class).getPropertyDescriptors();
                // 这里就是所有的属性了
                for (PropertyDescriptor pd : pds) {
                    // 属性名
                    String name = pd.getName();
                    // 如果当前属性选择忽略比较，跳到下一次循环
                    if (ignoreList != null && ignoreList.contains(name)) {
                        continue;
                    }
                    // get方法
                    Method readMethod = pd.getReadMethod();
                    // 在obj1上调用get方法等同于获得obj1的属性值
                    Object o1 = readMethod.invoke(obj1);
                    // 在obj2上调用get方法等同于获得obj2的属性值
                    Object o2 = readMethod.invoke(obj2);
                    if (o1 instanceof Timestamp) {
                        o1 = new Date(((Timestamp) o1).getTime());
                    }
                    if (o2 instanceof Timestamp) {
                        o2 = new Date(((Timestamp) o2).getTime());
                    }
                    if (o1 == null && o2 == null) {
                        continue;
                    } else if (o1 == null && o2 != null) {
                        List<Object> list = new ArrayList<Object>();
                        list.add(o1);
                        list.add(o2);
                        map.put(name, list);
                        continue;
                    }
                    // 比较这两个值是否相等,不等就可以放入map了
                    if (!o1.equals(o2)) {
                        List<Object> list = new ArrayList<Object>();
                        list.add(o1);
                        list.add(o2);
                        map.put(name, list);
                    }
                }
            }
            return map;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
```

在最后，记录变更值的时候需要把字段转为对应解释记录起来，我就用了swaager注解来提取的map

```java
    /**
     * 获取实体类字段和 swaager 注解 @ApiModelProperty 对应的值
     *
     * @param clazz
     * @return
     */
    public static Map<String, String> getFieldSwaggerValue(Class clazz) {
        // 获取所有的字段
        Field[] fields = clazz.getDeclaredFields();
        Map<String, String> map = new HashMap<>();
        for (Field f : fields) {
            // 判断字段注解是否存在
            boolean annotationPresent2 = f.isAnnotationPresent(ApiModelProperty.class);

            if (annotationPresent2) {
                ApiModelProperty name = f.getAnnotation(ApiModelProperty.class);
                // 获取注解值
                String nameStr = name.value();
                map.put(f.getName(), nameStr);
            }
        }
        return map;
    }
```
