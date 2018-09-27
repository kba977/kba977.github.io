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

![](https://ws4.sinaimg.cn/large/006tNc79gy1fvo6y49op2g30y90ijapt.gif)

<!-- more -->

### 2. iframe xss

``` html
<iframe src="http://www.baidu.com></iframe>
```

危害：攻击者可以在其中嵌入自己的恶意网页

![](https://ws2.sinaimg.cn/large/006tNc79gy1fvo6y4wczyj30e507rwew.jpg)



### 3. cookie xss

``` html
<script>alert(document.cookie);</script>
```

危害：获取cookie等重要信息
![Paste_Image.png](https://ws3.sinaimg.cn/large/006tNc79gy1fvo6y5sttej30dw06rjs0.jpg)