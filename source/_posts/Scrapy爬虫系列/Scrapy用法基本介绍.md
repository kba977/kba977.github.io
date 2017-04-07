---
title: Scrapy用法基本介绍
date: 2016-01-27 19:01:13
tags: [爬虫]
categories: [Scrapy爬虫系列]
---

# 一. 基本用法

## 1. 用以下命令开始一个Scrapy项目

    $ scrapy startproject Tutorial

## 2. 在项目根目录下, 查看可用的爬虫模板

    $ scrapy gensipder --list

    Available templates:
    basic 
    crawl
    csvfeed
    xmlfeed

如上图所示, 基本可用的爬虫模板有basic, crawl, csvfeed, xmlfeed, 分别对应基本的模板, 基于CrawlSpider类的爬虫模板, 和用于特定处理 csv 和 xml 的爬虫模板

<!-- more -->

## 3. 在项目跟目录下, 用下面的命令生成爬虫

    $ scrapy gensipder -t 模板(basic, crawl, ...) 爬虫名字 要爬取的主站url

其中默认 -t 为 basic。

例如, 以下命令生成一个基本的爬虫模板
    
    $ scrapy gensipder example example.com
    或者
    $ scrapy gensipder -t basic example example.com

``` python
# -*- coding: utf-8 -*-
import scrapy

class Myspider2Spider(scrapy.Spider):
    name = "example"
    allowed_domains = ["example.com"]
    start_urls = (
        'http://www.example.com/',
    )

    def parse(self, response):
        pass
```

# 二. 其他技巧

## 1. 不同页面之间 item 的传递
    
一般来说, 这样的情况非常常见, 在 A 页面爬取时, 有你感兴趣的一部分数据, 在 A 页面的链接中的下一个页面中, 有你感兴趣的另外一部分数据, 这时候你在 A 页面提取数据时创建的 item 实例需要传递到 B 页面中, 一般的方法如下: 

``` python
def parseA(self, response):
    item = SomeItem()
    item['A'] = ...
    item['B'] = ...
    B_url = ...

    yield scrapy.Request(
        url = B_url,
        callback=self.parseB,
        meta = {'item': item}
    )

def parseB(self, response):
    item = response.meta['item']

    item['C'] = ...
    yield item
```

## 2. 将爬取的item结果存入到mongoDB数据库中

``` python pipelines.py
import pymongo
from scrapy.exceptions import DropItem
from scrapy.conf import settings

class MongoDBPipeline(object):

    def __init__(self):
        connection = pymongo.MongoClient(
            settings['MONGODB_SERVER'],
            settings['MONGODB_PORT']
        )
        db = connection[settings['MONGODB_DB']]
        self.collection = db[settings['MONGODB_COLLECTION']]

    def process_item(self, item, spider):
        vaild = True

        for data in item:
            if not data:
                vaild = False
                raise DropItem("Missing {0}!".format(data))
        if vaild:
            self.collection.insert(dict(item))
        return item
```

之后在 settings.py 中定义以下变量, 并设置 `ITEM_PIPELINES` 参数

``` python settings.py
MONGODB_SERVER = "localhost"
MONGODB_PORT = 27017
MONGODB_DB = "数据库名"
MONGODB_COLLECTION = "数据库表名"

ITEM_PIPELINES = {
   'YourProject.pipelines.MongoDBPipeline': 300,
}
```
