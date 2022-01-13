---
title: Java工具函数-Http工具.md
date: 2022-01-13 11:31:21
tags:
- Java
- 工具函数
  categories: rd
---

```java
/**
 * Http Client工具
 *
 * @author 冯天鹤
 * @version 1.0
 */
@Slf4j
public class HttpUtil {

    private static CloseableHttpClient HttpUtil = HttpClients.custom().build();

    private String url;

    private List<NameValuePair> nameValuePairs;

    private HttpUriRequest httpMessage;

    private boolean hasPost;

    private String jsonBody;

    public HttpUtil get(String url) {
        return service(url, new HttpGet(url), false);
    }

    public HttpUtil post(String url) {
        return service(url, new HttpPost(url), true);
    }

    private HttpUtil service(String url, HttpUriRequest httpMessage, boolean hasPost) {
        validateUrl(url);
        initFlag(url, hasPost);
        this.httpMessage = httpMessage;
        return this;
    }

    private void validateUrl(String url) {
        log.info("验证URL[{}]是否为空", url);
        if (StringUtils.isBlank(url)) {
            throw new IllegalArgumentException();
        }
    }

    public String execute() throws IOException {
        setParameter();
        log.info("访问请求地址[{}]获取结果", this.url);
        CloseableHttpResponse response = HttpUtil.execute(httpMessage);
        HttpEntity entity = response.getEntity();
        String result = EntityUtils.toString(entity, "utf-8");
        return result;
    }

    private void setParameter() throws UnsupportedEncodingException {
        log.info("添加请求参数到请求主体上");
        if (httpMessage instanceof HttpGet) {
            if (nameValuePairs != null && !nameValuePairs.isEmpty()) {
                String tmp = URLEncodedUtils.format(nameValuePairs, "utf-8");
                this.url += (this.url.contains("?") ? "&" : "?") + tmp;
            }
            ((HttpGet) httpMessage).setURI(URI.create(this.url));
        } else if (httpMessage instanceof HttpPost) {
            if (StringUtils.isNotEmpty(this.jsonBody)) {
                httpMessage.addHeader("Content-type", "application/json; charset=utf-8");
                httpMessage.setHeader("Accept", "application/json");
                ((HttpPost) httpMessage).setEntity(new StringEntity(this.jsonBody, StandardCharsets.UTF_8));
            } else {
                httpMessage.addHeader("Content-type", "application/x-www-form-urlencoded");
                ((HttpPost) httpMessage).setEntity(new UrlEncodedFormEntity(nameValuePairs, "utf-8"));
            }
        }
    }

    private void initFlag(String url, boolean hasPost) {
        this.url = url;
        this.hasPost = hasPost;
    }

    public HttpUtil addHeader(String key, String value) {
        log.info("校验请求主体是否存在");
        if (this.httpMessage == null)
            throw new NullPointerException("未调用get或post方法");
        log.info("设置请求头");
        this.httpMessage.setHeader(key, value);
        return this;
    }

    public HttpUtil addAllHeader(Map<String, String> headers) {
        log.info("校验请求主体是否存在");
        if (this.httpMessage == null){
            throw new NullPointerException("未调用get或post方法");
        }
        log.info("设置请求头");
        for (String key : headers.keySet()) {
            this.httpMessage.setHeader(key, headers.get(key));
        }
        return this;
    }

    public synchronized HttpUtil addParameter(String key, String value) {
        if (this.nameValuePairs == null) {
            this.nameValuePairs = new ArrayList<>();
        }
        log.info("添加请求参数[{}, {}]到内存", key, value);
        this.nameValuePairs.add(new BasicNameValuePair(key, value));
        return this;
    }

    public synchronized HttpUtil addAllParameter(Map<String, String> params) {
        if (this.nameValuePairs == null) {
            this.nameValuePairs = new ArrayList<>();
        }
        for (String key : params.keySet()) {
            this.nameValuePairs.add(new BasicNameValuePair(key, params.get(key)));
        }
        return this;
    }

    public synchronized HttpUtil addJsonBody(String json) {
        this.jsonBody = json;
        return this;
    }
}
```