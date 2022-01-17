---
title: Java-ABTest对用户按策略分组.md
date: 2022-01-17 9:56:21
tags:
- Java
categories: rd
---

```java
public class Test {
    @Data
    private static class ABTestEntity {
        private long id;
        private int percent;

        public ABTestEntity(long id, int percent) {
            this.id = id;
            this.percent = percent;
        }
    }

    public static void main(String[] args) throws Exception {
        long uid = 4L;
        long strategyId = 123456L;
        List<ABTestEntity> configs = new ArrayList<>();
        configs.add(new ABTestEntity(1, 10));
        configs.add(new ABTestEntity(2, 20));
        configs.add(new ABTestEntity(3, 30));
        configs.add(new ABTestEntity(4, 40));

        System.out.println(executeDiversion(uid, configs, strategyId));
    }

    /**
     * 执行分流请求
     *
     * @param strategyId 策略ID，由于用户分组结果对于某个策略是一定的，所以我们的业务上使用策略ID作为离散因子
     */
    private static Long executeDiversion(long uid, List<ABTestEntity> abTestEntityList, Long strategyId) throws Exception {
        if (abTestEntityList != null) {
            ArrayList<Long> abTestIdArr = new ArrayList<Long>();
            ArrayList<Integer> percentArr = new ArrayList<Integer>();
            int value = 0;
            for (ABTestEntity abTestEntity : abTestEntityList) {
                long abtestId = abTestEntity.getId();
                value += abTestEntity.getPercent();
                abTestIdArr.add(abtestId);
                percentArr.add(value);
            }
            return getDivResultMap(Long.toString(uid), Long.toString(strategyId), abTestIdArr, percentArr, value);
        }
        return -1L;
    }

    /**
     * 返回层分流结果
     *
     * @param uid         eg:4
     * @param shuffle     eg:123456 离散因子
     * @param bucketIdArr eg:[1,2,3,4] 四个分组
     * @param percentArr  eg:[10,30,60,100] 当前分组和前几个分组累加的比例
     * @param value       eg: 100 所有分组共占得比例
     * @return
     */
    private static Long getDivResultMap(String uid, String shuffle, ArrayList<Long> bucketIdArr, ArrayList<Integer> percentArr, int value) throws Exception {
        MessageDigest md5 = MessageDigest.getInstance("MD5");/* 用来生成MD5值 */
        long hashValue = splitBucket(md5, uid, shuffle);
        if (value > 0) {
            int bucket = (int) (hashValue % value) + 1;// 将比例分成value份，看每次请求落在某份上
            // eg: bucket = 83
            for (int i = 0; i < percentArr.size(); i++) {
                if (bucket <= percentArr.get(i)) {
                    return bucketIdArr.get(i);
                }
            }
        }
        return -1L;
    }

    /**
     * 对用户标识进行hash
     *
     * @param md5     加密算法
     * @param val     用户请求标识（uv:uid pv:uid+timestamp）
     * @param shuffle ：离散因子
     * @return
     */
    public static long splitBucket(MessageDigest md5, String val, String shuffle) {
        String key = val + ((shuffle == null) ? "" : shuffle);
        byte[] ret = md5.digest(key.getBytes());
        String s = byteArrayToHex(ret);
        long hash = Long.parseLong(s.substring(s.length() - 16, s.length() - 1), 16);
        if (hash < 0) {
            hash = hash * (-1);
        }
        return hash;
    }

    public static String byteArrayToHex(byte[] byteArray) {
        char[] hexDigits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        char[] resultCharArray = new char[byteArray.length * 2];
        int index = 0;
        for (byte b : byteArray) {
            resultCharArray[index++] = hexDigits[b >>> 4 & 0xf];
            resultCharArray[index++] = hexDigits[b & 0xf];
        }
        return new String(resultCharArray);
    }
}
```