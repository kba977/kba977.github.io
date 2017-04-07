---
title: python反射和在web开发方面的应用
tags: [python]
categories: [Web开发]
---

　　有时候我们会碰到这样的需求，需要执行对象的某个方法，或是需要对对象的某个字段赋值，而方法名或是字段名在编码代码时并不能确定，需要通过参数传递字符串的形式输入。举个具体的例子：当我们需要实现一个通用的DBM框架时，可能需要对数据对象的字段赋值，但我们无法预知用到这个框架的数据对象都有些什么字段，换言之，我们在写框架的时候需要通过某种机制访问未知的属性。

　　这个机制被称为反射(反过来让对象告诉我们他是什么)，或是自省(让对象自己告诉我们他是什么)，用于实现在运行时获取未知对象的信息。

## 一. 代码示例
``` python a.py
def a(a):
    return [1,2,3,4]
```

``` python b.py
def b():
    return 1
```

``` python rest.py
from a import *
from b import *
```

<!-- more -->

``` python views.py
import json
import traceback
import rest

def resthandler(body):
    retdata = {}
    retdata['error'] = None;
    retdata['result'] = None;
    try:
        c = json.loads(body)
        method = getattr(rest,c['method'])
        if c['params']:
            ret = method(**c['params'])
        else:
            ret = method()
        retdata['result'] = ret
    except Exception,e:
        if 1:
            retdata['error'] = traceback.format_exc()
            print traceback.format_exc()
        else:
            retdata['error'] = 'error'
    return json.dumps(retdata)
```

``` python main.py
# -*- coding: utf-8 -*-
import os
import json
from flask import Flask, render_template, request
from views import resthandler

app = Flask(__name__)

@app.route('/')
def index():
    return render_template("index.html")
    
@app.route('/rest',methods=['POST'])
def upload():
    return resthandler(request.data)

if __name__ == '__main__':
    app.run(debug=True, port=81)
```

## 二. 结果演示

### 1. 未知函数

当传入的方法名为 `page`, 参数为 `{"node_id":1, "title":"xxxxx", "keyword":"aaaaaa"}`时, 返回错误。

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/python%E5%8F%8D%E5%B0%84%E5%92%8C%E5%9C%A8web%E5%BC%80%E5%8F%91%E6%96%B9%E9%9D%A2%E7%9A%84%E5%BA%94%E7%94%A8/1.png?)

### 2. 已知函数, 并带有参数

当传入的方法名为 `a`, 参数为`{"a":"a"}`, 结果返回了之前`a`函数中的return值`([1,2,3,4])`。

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/python%E5%8F%8D%E5%B0%84%E5%92%8C%E5%9C%A8web%E5%BC%80%E5%8F%91%E6%96%B9%E9%9D%A2%E7%9A%84%E5%BA%94%E7%94%A8/2.png?)

### 3. 已知函数, 不带参数

当传入的方法名为 `b`, 参数为`{}`(空), 结果返回了之前`b`函数中的return值`1`。

![](http://7xrahm.com1.z0.glb.clouddn.com/blog/python%E5%8F%8D%E5%B0%84%E5%92%8C%E5%9C%A8web%E5%BC%80%E5%8F%91%E6%96%B9%E9%9D%A2%E7%9A%84%E5%BA%94%E7%94%A8/3.png?)