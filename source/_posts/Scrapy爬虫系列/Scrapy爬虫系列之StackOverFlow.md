---
title: Scrapy爬虫系列之StackOverFlow
date: 2016-01-28 15:15:45
tags: [爬虫]
categories: [Scrapy爬虫系列]
---

本篇作为Scrapy爬虫的第一篇, 引用的是Scrapy官方的例子, 目标读者是听说过Scrapy这个爬虫框架, 但是还没有自己使用过, 主要介绍Scrapy最基本的知识, 没有其他新颖的东西, 看过官方文档的人可以选择略过 : )

首先默认大家都已经安装过了Scrapy了, 没有安装的人请执行`pip install scrapy`进行安装, 若遇到问题, 请自行谷歌(百度)解决。

## 1. 新建一个Scrapy工程
在终端下(Windows下叫命令行)
``` bash
scrapy startproject stack
```
这样一个工程便建成功了, 这时, 你会在当前目录下发现一个叫做`stack`的文件夹, 这便是Scrapy为我们生产的工程目录。
其结构如下图所示
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Scrapy爬虫系列之StackOverFlow/1_新建工程.jpg)

<!-- more -->

其中比较重要的几个文件是`items.py`, `pipelines.py`, `settings.py`, `自定义的爬虫文件`
下面分别介绍这四个文件:
- **items.py** : 该文件中存储我们将要提取的数据(类似于MVC架构中的Model)。
- **pipelines.py** : 该文件俗称”管道“, 顾名思义, 用来处理我们提取到的数据(去重, 验证, 存储到数据库)。
- **settings.py** : 配置文件, 该文件定义一些常见的配置参数。
- **自定义的爬虫文件** : 主要的爬虫逻辑在该文件实现, 默认没有生成, 需手动自己创建。

## 2. 定义我们的Item
``` python
from scrapy import Item, Field

class StackItem(Item):
    title = Field()     # 标题
    url = Field()       # URL
```
即: 我们感兴趣的数据是标题和标题的URL地址

## 3. 编写我们的爬虫文件
在spiders文件夹下新建`stack_spider`(名字随意, 不过不能叫`stack`会让程序混淆工程根目录和爬虫文件)
``` python stack_spider
from scrapy import Spider
from scrapy.selector import Selector

from stack.items import StackItem

class StackSpider(Spider):
    name = "stack"
    allowed_domains = ["stackoverflow.com"]
    start_urls = [
        "http://stackoverflow.com/questions?pagesize=50&sort=newest",
    ]

    def parse(self, response):
        questions = Selector(response).xpath('//div[@class="summary"]/h3')

        for question in questions:
            item = StackItem()
            item['title'] = question.xpath('a[@class="question-hyperlink"]/text()').extract()[0]
            item['url'] = question.xpath('a[@class="question-hyperlink"]/@href').extract()[0]
            yield item
```

在我们的`StackSpider`爬虫类中主要有`name`, `allowed_domains`, `start_urls`这三个重要的属性
- **name** : 爬虫名字, 后面启动爬虫时要用到
- **allowed_domains** : 指定爬虫爬取的域名
- **start_urls** : 一个列表属性, 爬虫程序开始时候循环遍历其中的url进行处理

最后因为我们这个`StackSpider`继承了`Spider`类, 所以其中要实现`parse`方法, 默认程序启动后每遍历一个url便将响应结果交给`parse`方法来处理, 所以我们必须要在`parse`中实现自己的抓取逻辑

这里要介绍**Scrapy**里两个重要的概念`Selector(选择器)`和`XPath`
- `Selector`是**Scrapy**中提取数据的一套机制, 通常配合`XPath`和`CSS`来“选择”HTML文件中的某个部分。
- `XPath`是一门用来在XML文件中选择节点的语言, 也可以用在HTML上。
- `CSS`是一门将HTML文档样式化的语言。选择器由它定义, 并与特定的HTML元素的样式相关联。

## 4. 编写通道(pipelines.py)文件
``` python pipelines.py
import pymongo

from scrapy.conf import settings
from scrapy.exceptions import DropItem
from scrapy import log

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
            log.msg("Question added to MongoDB database!",
                    level=log.DEBUG, spider=spider)
        return item
```
如上所示, 这个`MongoDBPipeline`主要的工作就是讲采集到的数据保存到**mongo**数据库中, 在`__init__`中负责连接`mongo`, 其中的配置见一下个小标题, 而`process_item`是每个**Pipeline**都默认必须要实现的方法, 用来对数据具体处理。

## 5. 编写配置文件(settings.py)
``` python settings.py
BOT_NAME = 'stack'

SPIDER_MODULES = ['stack.spiders']
NEWSPIDER_MODULE = 'stack.spiders'

ITEM_PIPELINES = {
   'stack.pipelines.MongoDBPipeline'': 10,
}

MONGODB_SERVER = "localhost"
MONGODB_PORT = 27017
MONGODB_DB = "stackoverflow"
MONGODB_COLLECTION = "questions"
```
配置文件主要是配置各个Pipeline的优先级, 数字越小, 优先级越高。 并配置mongo的一些参数`server`, `port`, `db`, `collection`。

## 6. 结果
编写完成后, 回到工程根目录下执行以下命令
``` bash
scrapy crawl stack -o data.json 
```
之后便可在**mongodb**数据库和**data.json**文件中看到抓取下来的数据。

**mongo**
![mongo](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Scrapy爬虫系列之StackOverFlow/2_mongo.jpg)
mongodb的简单使用方法可以参考我的另外一篇笔记{% post_link mongoDB简单用法 %}。


**data.json**
![data.json](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Scrapy爬虫系列之StackOverFlow/3_data.jpg)

(完)
