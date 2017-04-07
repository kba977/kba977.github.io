---
title: Scrapy爬虫系列之极客学院视频
date: 2016-01-30 18:55:36
tags: [爬虫]
categories: [Scrapy爬虫系列]
---

# 1. item.py(定义爬去的内容) 
---
``` python
from scrapy import Item, Field

class JikexueyuanItem(Item):
    course_id = Field()
    course_name = Field()
    course_url = Field()
    course_path = Field()
```

<!-- more -->

# 2. spider的编写
---
``` python
import re
from scrapy import Spider
from scrapy.http import Request
from scrapy.selector import Selector
from scrapy.spiders import CrawlSpider
from jikexueyuan.items import JikexueyuanItem

import sys
reload(sys)
sys.setdefaultencoding("utf-8")

class CourseSpider(Spider):
    name = "course"
    baseurl = "http://www.jikexueyuan.com/course/"
    allowed_domains = ["http://www.jikexueyuan.com/", "search.jikexueyuan.com", "jikexueyuan.com"]
    start_urls = [
        # 'http://www.jikexueyuan.com/course/?pageNum=%d' % i for i in xrange(1, 86)
        'http://www.jikexueyuan.com/course/?pageNum=1'
    ]

    def __init__(self):
        self.cookies = {your_cookies}
        
    def parse(self, response):   
        s_total = Selector(text=response.body).xpath("//ul[@class='cf']/li/div[@class='lessonimg-box']/a/@href").extract()
        
        if len(s_total) > 0:
            for page in s_total:
                yield Request(page, callback=self.get_course_page, cookies=self.cookies)
        else:
            pass

    def get_course_page(self, response):
        x_course = Selector(text=response.body).xpath("//ul/li/div[@class='text-box']/h2/a")
        for x in x_course:
            try:
                href = x.xpath('@href').extract()[0]
                title = x.xpath('text()').extract()[0]

                meta = {}
                meta['href'] = href
                meta['title'] = title
                yield Request(href, callback=self.get_down_urls, meta={'meta': meta},  cookies=self.cookies)
            except:
                pass

    def get_down_urls(self, response):
        meta = response.meta['meta']
        path = Selector(text=response.body).xpath("//div[@class='crumbs']/div[@class='w-1000']/a/text()").extract()
        course_down = re.findall(r'source src="(.*?)"', response.body, re.S)
        item = JikexueyuanItem()
        if course_down:
            item['course_id'] = meta['href']
            item['course_name'] = meta['title']
            item['course_url'] = course_down[0]
            item['course_path'] = path
            yield item
```

# 3. 结果
---
写好后保存然后在目录下运行 `scrapy crawl course -o data.json` 等待一会, 即可在目录下看到 `data.json` 文件如下：
![](http://ww1.sinaimg.cn/large/5e515a93gw1f0nbxi69b5j20qi08kwlu.jpg)

项目代码, [点我](https://github.com/kba977/Scrapy_Projects)下载。

这样所有视频(8111个)的名字、下载地址就被我们拿到啦。 赶快试试吧