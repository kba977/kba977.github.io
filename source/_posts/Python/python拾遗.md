---
title: python拾遗
date: 2017-12-03 15:00:47
tags: [Python]
categories: [Python]
---

<blockquote class="blockquote-center">
    用来记录一些经常使用的 python 实现方法
</blockquote>

### 优先队列

``` python
import heapq

class PriorityQueue(object):
    def __init__(self):
        self._queue = []
        self._index = 0
    
    def push(self, item, priority):
        heapq.heappush(self._queue, (-priority, self._index, item))
        self._index += 1
    
    def pop(self):
        return heapq.heappop(self._queue)[-1]
    
class Item(object):
    def __init__(self, name):
        self.name = name
    
    def __repr__(self):
        return 'Item(!r)'.format(self.name)
```

<!-- more -->

### 读取文件

``` python
CHUNK_SIZE = 1024

with open('test.json') as f:
    chunk = f.read(CHUNK_SIZE)
    while chunk:
        if chunk:
            print(chunk)
        chunk = f.read(CHUNK_SIZE)

from functools import partial

# Pythonic
with open('test.json') as f:
    for piece in iter(partial(f.read, CHUNK_SIZE), ''):
        print(piece)

# Lambda
with open('test.json') as f:
    for piece in iter(lambda: f.read(CHUNK_SIZE), ''):
        print(piece)
```

### 月度列表生成
   知道历史上某个时间, 比如: 2008-08, 得到目前 2011-06 之间的年号和月份的列表

![1.png](https://ws2.sinaimg.cn/large/006tNc79gy1fvo7iz5iwtj30z20a4n1v.jpg)

### python列表以相同的数字为一组
   例如 [0,0,0,1,1,2,2,2,3,0,4,4] --> [[0,0,0],[1,1],[2,2,2],[3],[0],[4,4]]

![2.png](https://ws2.sinaimg.cn/large/006tNc79gy1fvo7izipjbj3100050jsi.jpg)

### 生成随机字符串

``` python
import random, string

# 方法 1
''.join(random.choice(string.ascii_letters + string.digits) for _ in range(15))

# 方法 2
s = ''
for _ in range(15):
    s += random.choice(string.ascii_letters + string.digits)
    
# 方法 3
''.join(random.choices(string.ascii_letters + string.digits, k=15))
```

写了一段代码来测试速度，生成一个100W长的随机字符串，最后发现速度: method 3>method 1>method 2。

### Group by

![3.png](https://ws3.sinaimg.cn/large/006tNc79gy1fvo7j0gz3oj31h60dgmzk.jpg)

### 生成并校验密码
``` python
from werkzeug.security import generate_password_hash, check_password_hash

class User(object):

    def __init__(self):
        self.password_hash = None

    @property
    def password(self):
        raise AttributeError("password is not a readable attribute.")

    @password.setter
    def password(self, password):
        self.password_hash = generate_password_hash(password)

    def verify_password(self, password):
        return check_password_hash(self.password_hash, password)
```

效果如下图所示
![4.png](https://ws1.sinaimg.cn/large/006tNc79gy1fvo7j0ywapj31jq0i20w6.jpg)

### 生成分数对应的成绩
``` python
def grade(score, breakpoints=[60, 70, 80, 90], grades='FDCBA'):
    i = bisect.bisect_left(breakpoints, score)
    return grades[i]

In [1]: [grade(score) for score in [33, 99, 77, 70, 89, 90, 100]]
Out[1]: ['F', 'A', 'C', 'D', 'B', 'B', 'A']
```


### 未完待续...
