---
title: 部署Django应用
date: 2017-10-12 17:43:48
tags: [Django]
categories: [Web开发]
---

原文链接: [How to Deploy a Django Application to Digital Ocean](https://simpleisbetterthancomplex.com/tutorial/2016/10/14/how-to-deploy-to-digital-ocean.html)

默认你已经拥有自己的云主机, 本文系统为 Ubuntu 16.04, 其他类Unix系统操作类似

# 安装服务环境依赖
首先我们更新源
    
``` bash
sudo apt-get update
sudo apt-get -y upgrade
```

<!-- more -->

## NGINX
安装 NGINX, NGINX被用来托管静态资源(样式, 脚本, 图片)和运行我们的Django应用

``` bash
sudo apt-get -y install nginx
```

## Supervisor
Supervisor 将启动并管理我们的Django应用以防止其宕机和重启

``` bash
sudo apt-get -y install supervisor
```

使启用并启动 Supervisor:

``` bash
sudo systemctl enable supervisor
sudo systemctl start supervisor
```

## Python Virtualenv
为了更好的管理python环境依赖, 我们将 Django 应用部署在 Python 的虚拟环境里

``` bash
sudo apt-get -y install python-virtualenv
```

--------------------

# 配置应用用户(Application User)
用下面的命令创建一个新的用户

``` bash
adduser test
```

你会看到类似下面的输出:

``` bash
Adding user `test' ...
Adding new group `test' (1001) ...
Adding new user `test' (1001) with group `test' ...
Creating home directory `/home/test' ...
Copying files from `/etc/skel' ...
Enter new UNIX password: 
Retype new UNIX password: 
passwd: password updated successfully
Changing the user information for test
Enter the new value, or press ENTER for the default
    Full Name []: 
    Room Number []: 
    Work Phone []: 
    Home Phone []: 
    Other []: 
Is the information correct? [Y/n] y
```

添加该用户到超级用户列表

``` bash
gpasswd -a test sudo
```

切换到上步创建的用户

``` bash
su - test
```

-----------------------------------------

# 配置 Python 虚拟环境
这时我们登录到了 **test** 用户, 安装 Django 应用到该用户的家目录下 `/home/test`:

``` bash
virtualenv .
```

激活它并安装 Django:

``` bash
source bin/activate
pip install django
```

创建我们的 Django 项目

``` bash
django-admin startproject myTest
```

此时我们的家目录结构应该是下面这样的:

``` bash
/home/test
    ├── bin/
    ├── include/
    ├── lib/
    ├── local/
    ├── myTest/    <-- Django 应用
    ├── pip-selfcheck.json
    └── share/
```

首先打开 **myTest** 目录:

``` bash
cd myTest
```

迁移数据库文件:
``` bash
python manage.py migrate
```

测试一下是否一切正常:

``` bash
python manage.py runserver 0.0.0.0:8000
```

![1.png](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/部署Django应用/1.jpg)

这只是一个测试, 我们将不会使用 `runserver` 来跑起我们的应用, 而是使用另外一个更加适合的工具

按下 `CONTROL-C` 退出进程

---------------------------------

# 配置 Gunicorn
首先在虚拟环境中安装 **Gunicorn**

``` bash
pip install gunicorn
```

创建一个名为 **gunicon_start** 的文件,并放在 **bin/** 目录下

``` bash
vim bin/gunicorn_start
```

添加下面的信息并保存:

``` code /home/test/bingunicorn_start
#!/bin/bash

NAME='myTest'
DIR=/home/test/myTest
USER=test
GROUP=test
WORKERS=3
BIND=unix:/home/test/run/gunicorn.sock
DJANGO_SETTINGS_MODULE=myTest.settings
DJANGO_WSGI_MODULE=myTest.wsgi
LOG_LEVEL=error

cd $DIR
source ../bin/activate

export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DIR:$PYTHONPATH

exec ../bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $WORKERS \
  --user=$USER \
  --group=$GROUP \
  --bind=$BIND \
  --log-level=$LOG_LEVEL \
  --log-file=-
```

赋予 **gunicorn_start** 文件可执行权限:

``` bash
chmod u+x bin/gunicorn_start
```

创建名为 **run** 的文件夹, 以供后续配置使用:

``` bash
mkdir run
```

-----------------------------------

# 配置 Supervisor
现在我们需要配置 Supervisor 去管控 gunicorn服务

首先, 在虚拟环境中创建 **logs** 目录

``` bash
mkdir logs
```

创建一个用来输出应用错误日志的文件:

``` bash
touch logs/gunicorn-error.log
```

创建一个新的 Supervisor 配置文件:

``` bash
sudo vim /etc/supervisor/conf.d/myTest.conf
```

``` code /etc/supervisor/conf.d/myTest.conf
[program:myTest]
command=/home/test/bin/gunicorn_start
user=test
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/home/test/logs/gunicorn-error.log
```

刷新 Supervisor 配置文件, 并且使得上步配置生效

``` bash
sudo supervisorctl reread
sudo supervisorctl update
```

检查服务状态:

``` bash 
sudo supervisorctl status myTest
myTest                           RUNNING   pid 84573, uptime 00:00:15
```

现在, 你可以使用 Supervisor 来控制你的应用. 如果你想要更新源代码, 只需将最新代码从仓库拉取下来后, 重启进程即可:

``` bash
sudo supervisorctl restart myTest
```

-------------------------

# 配置 NGINX

在 **/etc/nginx/sites-available/** 目录下创建一个新的名叫 myTest 的配置文件

``` bash
sudo vim /etc/nginx/sites-available/myTest
```

``` nginx /etc/nginx/sites-available/myTest
upstream app_server {
    server unix:/home/test/run/gunicorn.sock fail_timeout=0;
}

server {
    listen 80;

    # add here the ip address of your server
    # or a domain pointing to that ip (like example.com or www.example.com)
    server_name 107.170.28.172;

    keepalive_timeout 5;
    client_max_body_size 4G;

    access_log /home/test/logs/nginx-access.log;
    error_log /home/test/logs/nginx-error.log;

    location /static/ {
        alias /home/test/static/;
    }

    # checks for static file, if not found proxy to app
    location / {
        try_files $uri @proxy_to_app;
    }

    location @proxy_to_app {
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_redirect off;
      proxy_pass http://app_server;
    }
}
```

创建一个软连接到 **sites-enabled** 目录下:

``` bash
sudo ln -s /etc/nginx/sites-available/myTest /etc/nginx/sites-enabled/myTest
```

删除 NGINX 默认的网站:

``` bash
sudo rm /etc/nginx/site-enabled/default
```

重启 NGINX:

``` bash
sudo service nginx restart
```

-----------------------------------

# 最终测试
这时, 你的应用应该已经跑起, 打开浏览器并查看:

![2.png](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/部署Django应用/2.jpg)

最终测试时, 我习惯重启机器, 并查看应用是否能够自动重启:

``` bash
sudo reboot
```

等待一会, 通过浏览器进入网站. 如果一切加载正常, 说明一切 OK, 所有的进程都已经自动的启动

-------------------

# 更新应用
当你更新 Django 应用时候, 通常要遵循下面的步骤:

``` bash
ssh test@192.168.1.175

source bin/activate
cd myTest
git pull origin master
python manage.py collectstatic
python manage.py migrate
sudo supervisorctl restart myTest
exit
```
------------------------------

忠心的希望该文章对你有用, 如果有任何问题, 欢迎留言讨论.
