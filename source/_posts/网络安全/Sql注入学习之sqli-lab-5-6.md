---
title: Sql注入学习之sqli-lab-5-6
tags: [Sql注入]
categories: [网络安全]
date: 2016-03-19 14:31:55
---

## 5. Less-5 GET - 双注入 - 单引号 - 字符型

和之前系列不同的是, 如下图, 当我们id输入合法之后, 不再显示**username**和**password**, 而是直接显示**You are in ......**
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L5-0.png?)
所以我们, 没法用之前的注入技术了。

但是, 当输入测试的**1'**后, 得到的错误信息中关键部分如下:
` '　　1'　　' LIMIT 0,1 `
也即我们能得到服务器回显的地方只有错误信息, 因此要构造语句将我们需要的敏感信息爆出到错误信息中:
如以下语句:

<!-- more -->

首先用 order by 猜测字段:
如下两图所以:
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L5-1.png?)

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L5-2.png?)
可以看到, 当我们输入**4**的时候出错, 输入**3**的时候页面正常, 所以可以得出字段数为**3**(由之前的Less也可以知道字段数为**3** :P )    

下面用联合语句爆出关键信息到错误回显:

    id=1' union select 1, count(*), concat(0x3a,0x3a,(select database(),0x3a,0x3a,floor(rand()*2)a from information_schema.columns group by a --+
如下图, 可以看到错误信息中爆出了我们关心的`database`名
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L5-3.png?)

同理, 错误信息爆出了`数据库版本`和`当前数据库用户`信息

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L5-4.png?)

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L5-5.png?)

之后, 就可以用我们之前学到的技术开心的注入啦~ :)

-----------------------------------------------------------

## 6. Less-6 GET - 双注入 - 双引号 - 字符型

同 Less-5 一样, 二者唯一的区别就是触发错误的方式不同 Less-5 是单引号, 而 Less-6 是双引号 :P