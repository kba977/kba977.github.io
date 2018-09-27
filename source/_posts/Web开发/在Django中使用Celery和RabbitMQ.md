---
title: 在Django中使用Celery和RabbitMQ
tags:
  - Django
categories:
  - Web开发
date: 2017-10-13 16:44:57
---


原文链接: [How to Use Celery and RabbitMQ with Django](https://simpleisbetterthancomplex.com/tutorial/2017/08/20/how-to-use-celery-with-django.html#celery-basic-setup)

![0.png](https://ws1.sinaimg.cn/large/006tNc79gy1fvo7nev1m9j30xc0hin1x.jpg)

<!-- more -->

Celery 是一个基于第三方消息服务的分布式任务调度模块. 本文将介绍如何安装并使用 Celery + RabbitMQ 在 Django 应用中执行异步任务.

使用 Celery, 我们还需要安装 RabbitMQ, 因为 Celery 需要一个解决方案来传递任务. 该解决方案称为**消息代理(message brokers)**. 如今, Celery 支持 RabbitMQ, Redis, 和 Amazon SQS 作为消息代理.

----------------------------------------------

# 我们为什么要使用 Celery ?
Web 应用都是请求/响应模型. 当用户在浏览器中输入一个特定的URL, 发送到服务器一个 **请求(request)**. Django 应用收到该请求并做一些响应. 通常, 该响应是执行一段SQL, 从数据库取出数据. 当 Django 在处理该请求的时候, 用户必须等待. 当 Django 处理完成后, 它出发出一个**响应**给用户, 这样用户就能看到最终的执行结果.

理想情况下, 请求和响应都应该特别快, 否则可能为因为用户等待太长时间而失去用户. 甚至更糟的是, 我们的 Web 服务仅仅能同时服务一部分人. 所以, 如果该过程很慢的话, 那将对我们有很大的损失.

在过去, 我们的解决方案可能是使用缓存, 优化数据库查询等. 但是, 仍然有一些问题没有得到解决: 这些耗时的工作还必须去做. 一个报告的页面, 大数据展现, 视频/图片 等进程都是我们使用 Celery 很好的场景.

我们将不会在整个项目中使用 Celery, 而仅仅是一些特定的耗时任务. 主要的思路是尽可能快的响应用户的请求, 而把耗时的任务放到后台去执行, 且一直保持服务器做好迎接新请求的准备.

------------------------------


# 安装
最简单的安装 Celery 的方法是使用 pip:

``` bash
pip install Celery
```

## 在 Mac 上安装 RabbitMQ
然后我们需要安装 RabbitMQ (Mac, 其他平台类似)

``` bash
brew instal rabbitmq
```

RabbitMQ 的脚本默认安装在 `/usr/local/sbin`. 我们可以在 `.bash_profile` 或者 `.profile` 中添加:

``` bash
vim ~/.bash_profile
```

然后在文件的底部写入:

``` bash
export PATH=$PATH:/usr/local/sbin
```

重启终端, 以确保更改生效
然后我们可以使用下面的命令启动 RabbitMQ 服务:

``` bash
 rabbitmq-server 
 ```

 ![1.png](https://ws1.sinaimg.cn/large/006tNc79gy1fvo7nfs9ttj30zg0dkgpg.jpg)

 ---------------------------------

# Celery 基本配置
首先, 我们的 Django 目录结构如下, 项目名为 **mysite**, 应用名为 **core**.

``` code
mysite
   ├── core
   │   ├── __init__.py
   │   ├── apps.py
   │   ├── migrations/
   │   ├── models.py
   │   ├── templates/
   │   └── views.py
   ├── mysite
   │   ├── __init__.py
   │   ├── settings.py
   │   ├── urls.py
   │   └── wsgi.py
   ├── manage.py
   └── requirements.txt
```

在 **settings.py** 文件中添加 `CELECY_BROKER_URL` 配置项

``` python settings.py
CELECY_BROKER_URL = 'amqp://localhost'
```
在与 **settings.py** 和 **urls.py** 同级目录下, 创建新的文件, 名称为 **celery.py**.

``` python celery.py
import os
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mysite.settings')

app = Celery('mysite')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
```

然后, 编辑项目根目录下 **__init__.py**.

``` python __init__.py
from .celery import app as celery_app

__all__ = ['celery_app']
```

这将确保 Celery 应用随着Django项目启动被成功导入.
------------------------------------------------

# 创建第一个 Celery 任务

在 Django的 core 应用里, 我们创建一个名为 **tasks.py** 的文件, 我们之前在项目根目录下创建的 Celery 应用会通过 `INSTALLED_APPS` 自动检索所有的 Django 应用以发现任务.

我们创建一个 Celery 任务, 生成批量随机用户.

``` python core/tasks.py
import string

from django.contrib.auth.models import User
from django.utils.crypto import get_random_string

from celery import shared_task

@shared_task
def create_random_user_accounts(total):
    for i in range(total):
        username = 'user_{}'.format(get_random_string(10, string.ascii_letters))
        email = '{}@example.com'.format(username)
        password = get_random_string(50)
        User.objects.create_user(username=username, email=email, password=password)
    return '{} random users created success!'.format(total)
```

其中最重要的部分如下:

``` python 
from celery import shared_task

@shared_task
def name_of_your_function(optional_param):
    pass   # do something heavy
```

然后, 创建一个表单和一个视图来处理我们的 Celery 任务.

``` python forms.py
from django import forms
from django.core.validators import MinValueValidator, MaxValueValidator

class GenerateRandomUserForm(forms.Form):
    total = forms.IntegerField(
        validators=[
            MinValueValidator(50),
            MaxValueValidator(500)
        ]
    )
```

该表单要求输入一个 50 到 500 的数字, 如下图显示:

![2.png](https://ws4.sinaimg.cn/large/006tNc79gy1fvo7ngsmn9j31kw0lnq75.jpg)

然后我们的视图如下:

``` python views.py
from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib import messages
from django.views.generic.edit import FormView

from .forms import GenerateRandomUserForm
from .tasks import create_random_user_accounts


class GenerateRandomUserView(FormView):
    template_name = 'core/generate_random_users.html'
    form_class = GenerateRandomUserForm

    def form_valid(self, form):
        total = form.cleaned_data.get('total')
        create_random_user_accounts.delay(total)
        messages.success(self.request, 'We are generating your random user! Wait a moment and refresh this page.')
        return redirect('users_list')
```

其中最重要的部分如下:

``` python
creat_random_user_accounts.delay(total)
```

我们并没有直接调用 `creat_random_user_accounts`方法, 而是调用 `creat_random_user_accounts.delay()`. 
这样, 该方法就会被 Celery 调到后台去运行.

Django 将会接着处理 `GenerateRandomUserView` 这个视图, 并立即返回响应给用户.
----------------------------------------

# 开启工作进程
新开一个终端窗口, 运行下面的命令:

``` bash
celery -A mysite worker -l info
```

其中 **mysite** 为你的项目名称. 结果如下图所示:

![3.png](https://ws3.sinaimg.cn/large/006tNc79gy1fvo7nhqkavj30zi0xwgte.jpg)

现在, 我们测试一下, 提交 500 在表单中去创建 500 个随机的用户.

可以看到, 该请求立刻得到响应:

![4.png](https://ws1.sinaimg.cn/large/006tNc79gy1fvo7nins8jj31kw0l1aek.jpg)

同时, 我们可以看到 Celery 的工作进程:

![5.png](https://ws3.sinaimg.cn/large/006tNc79gy1fvo7njo9bsj30zg056ae1.jpg)

然后稍等几秒钟, 我们刷新一下页面, 可以看到用户已经生成:

![6.png](https://ws3.sinaimg.cn/large/006tNc79gy1fvo7nkuva8j31kw0xcao9.jpg)

--------------------------------

照例: 该案例的[代码](https://github.com/kba977/django-celery-example)可在Github上下载

感谢阅读.


