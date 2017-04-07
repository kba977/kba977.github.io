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

![启动mongo 服务器](http://ww2.sinaimg.cn/large/5e515a93jw1f13ma56xpsj20m00a0782.jpg)

<!-- more -->

## 客户端
---
### 一.基本用法
#### 1.  进入 mongo 数据库

    mongo

![进入 mongo 数据库](http://ww2.sinaimg.cn/large/5e515a93jw1f13mae0203j20i2020t8p.jpg)

#### 2. 显示所有的数据库

    show dbs (或者 show database)

![显示所有的数据库](http://ww2.sinaimg.cn/large/5e515a93jw1f13mamheetj20gr02x74a.jpg)

#### 3. 使用其中的数据表 `(eg. dbmeizi)`

    use dbmeizi

![使用其中的数据表](http://ww3.sinaimg.cn/large/5e515a93jw1f13mav5q8lj20f701lwed.jpg)

#### 4. 查看该表中有哪些 collections

    show collections

![查看该表中有哪些 collections](http://ww3.sinaimg.cn/large/5e515a93jw1f13mb3nm8wj20go01za9y.jpg)

#### 5. 查看该 collections 下有什么数据

    db.meizi.find()

![查看该 collections 下有什么数据](http://ww4.sinaimg.cn/large/5e515a93jw1f13mbfyywqj20ia096q6m.jpg)

#### 6. 导出数据
    例如若要导出 `douban`数据库中的 `movies` 中的 `title` 和 `url` 字段, 则命令如下:

    mongoexport --db douban --collection movies --type=csv --fields title,url --out /Users/apple/Desktop/data.csv

    导出json格式并且去除自带的`_id`字段
    
    mongo douban --quiet --eval "db.movies.find({},{_id:0}).forEach(printjson);" > ~/Desktop/data.json

#### 7. 删除一个数据库

    db.dropDatabase()

![删除一个数据库](http://ww1.sinaimg.cn/large/5e515a93jw1f13mbpqf8uj20i901lq2w.jpg)

### 二.数据检索

#### 1. - count() 用来查看collections中数据总数

    > db.COLLECTION_NAME.count()

![查看collections中数据总数](http://ww4.sinaimg.cn/large/5e515a93jw1f13mbx93i1j20e601jjr8.jpg)

#### 2. - sort() 用来对数据进行排序, 指定排序字段, 并用 1 或 -1 来指定升降序

    > db.COLLECTION_NAME.find().sort({KEY:1})

![数据按照"datasrc"升序排列](http://ww4.sinaimg.cn/large/5e515a93jw1f13mc7pq4jj20ly08jwi9.jpg)

#### 3. - skip() 用来跳过指定数量的数据, 即从指定数量后开始显示

    > db.COLLECTION_NAME.find().skip(NUMBER)

![原始数据为5条, 现在只显示3条, 即跳过5条](http://ww4.sinaimg.cn/large/5e515a93jw1f13mckj7tqj20lz03xmyk.jpg)

#### 4. - limit() 用来读取指定数据的数据

    > db.COLLECTION_NAME.find().limit(NUMBER)

![原数据为8条, 现在只显示前4条](http://ww3.sinaimg.cn/large/5e515a93jw1f13mctaataj20m204v0um.jpg)

### 三. Mongo 语句与 SQL 的对照关系表

``` js
//equivalent of MySQL SELECT COUNT(*) AS cnt, fieldName FROM someTable GROUP BY fieldName;
db.someCollection.aggregate([{"$group" : {_id:"$fieldName", cnt:{$sum:1}}}]);

//as above but ordered by the count descending
//eg: SELECT COUNT(*) AS cnt, fieldName FROM someTable GROUP BY fieldName ORDER BY cnt DESC;
db.someCollection.aggregate([{"$group" : {_id:"$fieldName", cnt:{$sum:1}}}, {$sort:{'cnt':-1}}]);
```