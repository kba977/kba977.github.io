---
title: dvwa笔记
tags: [Web漏洞]
categories: [网络安全]
date: 2016-02-04 22:05:18
---


## 存储型XSS
### 1. 基本的xss

``` html
<script>alert("hello")</script>
```

危害: 攻击者可以轻松的以中间人身份捕获 cookie/session。 

![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/dvwa笔记/1_基本的xss.gif)

<!-- more -->

### 2. iframe xss

``` html
<iframe src="http://www.baidu.com></iframe>
```

危害：攻击者可以在其中嵌入自己的恶意网页

![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/dvwa笔记/2_iframe_xss.jpg)



### 3. cookie xss

``` html
<script>alert(document.cookie);</script>
```

危害：获取cookie等重要信息
![Paste_Image.png](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/dvwa笔记/3_cookie_xss.jpg)