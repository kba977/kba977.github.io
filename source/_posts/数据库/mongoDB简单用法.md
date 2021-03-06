---
title: mongoDB简单用法
date: 2016-02-18 17:18:13
tags: [mongoDB]
categories: [数据库]
---

## 服务器端
---
### 1. 启动mongo 服务器

    sudo mongod

![启动mongo 服务器](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/1_启动mongo服务器.jpg)

<!-- more -->

## 客户端
---
### 一.基本用法
#### 1.  进入 mongo 数据库

    mongo

![进入 mongo 数据库](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/2_进入mongo数据库.jpg)

#### 2. 显示所有的数据库

    show dbs (或者 show database)

![显示所有的数据库](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/3_显示所有数据库.jpg)

#### 3. 使用其中的数据表 `(eg. dbmeizi)`

    use dbmeizi

![使用其中的数据表](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/4_使用其中的数据库.jpg)

#### 4. 查看该表中有哪些 collections

    show collections

![查看该表中有哪些 collections](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/5_查看该表中有哪些collections.jpg)

#### 5. 查看该 collections 下有什么数据

    db.meizi.find()

![查看该 collections 下有什么数据](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/6_查看表中有哪些数据.jpg)

#### 6. 导出数据
    例如若要导出 `douban`数据库中的 `movies` 中的 `title` 和 `url` 字段, 则命令如下:

    mongoexport --db douban --collection movies --type=csv --fields title,url --out /Users/apple/Desktop/data.csv

    导出json格式并且去除自带的`_id`字段
    
    mongo douban --quiet --eval "db.movies.find({},{_id:0}).forEach(printjson);" > ~/Desktop/data.json

#### 7. 删除一个数据库

    db.dropDatabase()

![删除一个数据库](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/7_删除一个数据库.jpg)

### 二.数据检索

#### 1. - count() 用来查看collections中数据总数

    > db.COLLECTION_NAME.count()

![查看collections中数据总数](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/8_检索collection中数据数量.jpg)

#### 2. - sort() 用来对数据进行排序, 指定排序字段, 并用 1 或 -1 来指定升降序

    > db.COLLECTION_NAME.find().sort({KEY:1})

![数据按照"datasrc"升序排列](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/9_排序.jpg)

#### 3. - skip() 用来跳过指定数量的数据, 即从指定数量后开始显示

    > db.COLLECTION_NAME.find().skip(NUMBER)

![原始数据为5条, 现在只显示3条, 即跳过5条](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/10_跳过.jpg)

#### 4. - limit() 用来读取指定数据的数据

    > db.COLLECTION_NAME.find().limit(NUMBER)

![原数据为8条, 现在只显示前4条](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/mongoDB简单用法/11_limit.jpg)

### 三. Mongo 语句与 SQL 的对照关系表

``` js
//equivalent of MySQL SELECT COUNT(*) AS cnt, fieldName FROM someTable GROUP BY fieldName;
db.someCollection.aggregate([{"$group" : {_id:"$fieldName", cnt:{$sum:1}}}]);

//as above but ordered by the count descending
//eg: SELECT COUNT(*) AS cnt, fieldName FROM someTable GROUP BY fieldName ORDER BY cnt DESC;
db.someCollection.aggregate([{"$group" : {_id:"$fieldName", cnt:{$sum:1}}}, {$sort:{'cnt':-1}}]);
```