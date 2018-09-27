---
title: Scrapy爬虫系列之豆瓣电影Top250
date: 2016-02-02 00:36:09
tags: [爬虫]
categories: [Scrapy爬虫系列]
---

# 1. item.py(定义爬去的内容) 
---

``` python
import scrapy

class Dbmoviestop250Item(scrapy.Item):
    name = scrapy.Field()  # 电影名字
    year = scrapy.Field()  # 上映年份
    score = scrapy.Field()  # 豆瓣分数
    director = scrapy.Field() # 导演
    classification = scrapy.Field() # 分类
    actor = scrapy.Field() # 演员
    image_urls = scrapy.Field() # 封面图片
```

<!-- more -->

# 2. spider 的编写
---

``` python
from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor
from scrapy.selector import Selector

from dbMoviesTop250.items import Dbmoviestop250Item

class MovieSpider(CrawlSpider):
    name = 'movies'
    allowed_domains = ['movie.douban.com']
    start_urls = ['http://movie.douban.com/top250']

    rules = [Rule(LinkExtractor(allow=(r'http://movie.douban.com/top250\?start=\d+.*'))),
            Rule(LinkExtractor(allow=(r'http://movie.douban.com/subject/\d+')),
                callback='parse_item', follow=False)
    ]

    def parse_item(self, response):

        sel = Selector(response)

        item = Dbmoviestop250Item()
        item['name'] = sel.xpath('//*[@id="content"]/h1/span[1]/text()').extract()[0]
        item['year'] = sel.xpath('//*[@id="content"]/h1/span[2]/text()').extract()[0]
        item['score'] = sel.xpath('//*[@id="interest_sectl"]/div[1]/div[2]/strong/text()').extract()[0]
        item['director'] = sel.xpath('//*[@id="info"]/span[1]/span[2]/a/text()').extract()[0]
        item['classification'] = sel.xpath('//span[@property="v:genre"]/text()').extract()[0]
        item['actor'] = sel.xpath('//*[@id="info"]/span[3]//a/text()').extract()[0]
        item['image_urls'] = sel.xpath('//div[@id="mainpic"]/a[@class="nbgnbg"]/img/@src').extract()

        return item
```

# 3. PipeLine 中处理数据及图片下载
``` python

import scrapy
from scrapy.contrib.pipeline.images import ImagesPipeline

class MyImagesPipeline(ImagesPipeline):

    def get_media_requests(self, item, info):
        for image_url in item['image_urls']:
            yield scrapy.Request(image_url, meta={'item': item})

    def item_completed(self, results, item, info):
        image_paths = [x['path'] for ok, x in results if ok]
        if not image_paths:
            raise DropItem("Item contains no images")
        return item

    def file_path(self, request, response=None, info=None):
        item = request.meta['item']
        name = item['name']
        filename = u'full/{0}.jpg'.format(name)
        return filename
```

# 4. setting 中设置几个变量
``` python

IMAGES_STORE = '.'   # 表示图片文件夹为当前目录

ITEM_PIPELINES = {
   'dbMoviesTop250.pipelines.MyImagesPipeline': 300,
}

```

# 5. 结果
---
写好后保存然后在目录下运行 `scrapy crawl movies -o data.json` 等待一会, 即可在目录下看到 `data.json` 文件如下：
![](https://ws1.sinaimg.cn/large/006tNc79gy1fvo6x3dg08j31ei0pwb29.jpg)

和 封面图片都被下载下来咯
![](https://ws4.sinaimg.cn/large/006tNc79gy1fvo6x41qbpj30xk0ki11k.jpg)

项目代码, [点我](https://github.com/kba977/Scrapy_Projects)下载。

这样Top250电影的相关信息就被我们拿到啦。 赶快试试吧！！！