---
title: YK直播-Swift3简单实现
tags: [Swift, iOS开发]
categories: [iOS开发]
date: 2017-01-06 16:05:56
---


<blockquote class="blockquote-center">
    以下内容主要来自于小波说雨燕中的[映课直播](http://www.swiftv.cn/course/itdrunk0)视频, 本人以学习为目的写成这篇实践版本, 最后感谢小波老师的无私奉献。
</blockquote>

![成果展示](https://ws1.sinaimg.cn/large/006tNc79gy1fvo98o2rp1g30yo0jy1l5.gif)

<!-- more -->

## 第零步: 开发前的准备

### 1. 以下是映客直播几个热播的主播的Api请求地址

`http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1
`

### 2. 开发过程中所用到的资源的下载(各种图片和图标资源等)

链接: https://pan.baidu.com/s/1jIoFQSI 密码: mvmf
**pics**: 图片等静态资源
**emmitParticles.zip**: 烟花效果
**HeartFlyView.zip**: 爱心效果
**lib&IJKFW.zip**: 播放视频流的库

### 3. 还有一大神器 **JSONExport**  

用来秒得编程过程中与JSON数据对应的Model  
具体参见项目地址 https://github.com/Ahmed-Ali/JSONExport

### 4. 使用 *Cocoapod* 安装 `Just` 和 `Kingfisher`
**Just**(0.5.7): 主要用于Swift进行网络请求, 例如 Get, Post 等
**Kingfisher**(3.2.0): 主要用于直接从网络上获取图片

## 第一步: Model模型层

首先我们访问热播主播的Api得到其数据
![YK直播JSON数据](https://ws4.sinaimg.cn/large/006tNc79gy1fvo98pyxvxj31kw0wbh8v.jpg)

这时候, 打开我们的的神器`JSONExport`复制JSON到左边栏并在右下角选择**Swift-Struct**, 这时, 我们就会看到它已经将我们需要的`Model`代码生成好了。
![JSONExport神器](https://ws1.sinaimg.cn/large/006tNc79gy1fvo98ry5cuj31kw1304hy.jpg)

之后我们在项目目录下新建一个*Model*文件夹, 然后将生成好的model们保存起来。
![将Model拖入到项目中](https://ws2.sinaimg.cn/large/006tNc79gy1fvo98tg47vj31kw0yn13e.jpg)

根据我们需求, 从上一步JSON中抽取我们的感兴趣的数据自己写一个`YKCell`model, 如下图所示
![我们需要的信息](https://ws3.sinaimg.cn/large/006tNc79gy1fvo98u9xd8j31kw0yndq7.jpg)

## 第二步: View视图层

这一步, 相对来说比较轻松, 我们选择使用Xcode中自带的StoryBoard来完成, 具体过程不表, 一图胜万言
![大体布局](https://ws1.sinaimg.cn/large/006tNc79gy1fvo98vxgl1j31kw0ynaii.jpg)

然后把我们下载的静态资源添加到Assets里, 并在刚才的布局中为图片设置资源
![静态资源](https://ws4.sinaimg.cn/large/006tNc79gy1fvo98x9703j31kw0yntkj.jpg)

![加入静态资源到布局中](https://ws3.sinaimg.cn/large/006tNc79gy1fvo98yk7j0j31kw0ynjzu.jpg)

至此, 我们的视图层就大体搭建好啦。

## 第三步: Controller控制层

首先, 新建一个TableViewController对应我们的TableView, 起名为 YKLiveTableViewController, 并新建一个TableViewCell来对应每一个主播, 起名为YKLiveTableViewCell, 并分别绑定到对应的视图中。

![TableController和TableCell](https://ws2.sinaimg.cn/large/006tNc79gy1fvo990xc2nj31kw0yn494.jpg)

![Api数据请求](https://ws4.sinaimg.cn/large/006tNc79gy1fvo992leq4j31kw0ynh49.jpg)

![请求错误信息](https://ws3.sinaimg.cn/large/006tNc79gy1fvo993i5kzj31ke0daju3.jpg)

我们只要在info.plist里添加一项即可
![HTTP(S)开关](https://ws1.sinaimg.cn/large/006tNc79gy1fvo994peq4j31kw0j6ajx.jpg)

这时, 我们再次运行模拟器, 就能在终端看到我们感兴趣的数据了
![数据请求成功](https://ws1.sinaimg.cn/large/006tNc79gy1fvo996olq2j31kw0xp19q.jpg)

下面我们需要将一个个的数据填充到 **TableView** 的 **Cell** 中, 代码如下:
![列表页代码示图](https://ws4.sinaimg.cn/large/006tNc79gy1fvo998h835j31kw0yl7kg.jpg)

![下拉刷新](https://ws2.sinaimg.cn/large/006tNc79gy1fvo99a0i5dj31kw0ylh81.jpg)

![首页1](https://ws4.sinaimg.cn/large/006tNc79gy1fvo99ewke8j31kw0ylnpd.jpg)

接下来, 我们需要修改一下大图的显示方式和小图片的圆框

![设置1](https://ws2.sinaimg.cn/large/006tNc79gy1fvo99g7g3kj31kw0ylnpd.jpg)

![设置2](https://ws1.sinaimg.cn/large/006tNc79gy1fvo99is34uj31kw0yl7i5.jpg)

经过以上调整, 我们的列表页面就大概完工啦
![首页2](https://ws2.sinaimg.cn/large/006tNc79gy1fvo99l7pnvj31kw0yob29.jpg)

![列表页面传值](https://ws1.sinaimg.cn/large/006tNc79gy1fvo99orys3j31kw0ylavc.jpg)
![播放页面传值](https://ws1.sinaimg.cn/large/006tNc79gy1fvo99rdamej31kw0yl7nn.jpg)

![绑定播放页面3个按钮](https://ws4.sinaimg.cn/large/006tNc79gy1fvo99t31pzj31kw0yl15i.jpg)

![播放页面设置背景并添加模糊效果](https://ws2.sinaimg.cn/large/006tNc79gy1fvo99ulev2j31kw0yltsx.jpg)

![展示模糊效果](https://ws2.sinaimg.cn/large/006tNc79gy1fvo99wzo0jj31kw0ymqr1.jpg)


![播放组件](https://ws2.sinaimg.cn/large/006tNc79gy1fvo99yu0ufj31kw0ylkd5.jpg)
![建立桥接文件](https://ws3.sinaimg.cn/large/006tNc79gy1fvo9a0k51jj31kw0yjk9c.jpg)
![桥接文件内容](https://ws2.sinaimg.cn/large/006tNc79gy1fvo9a235rtj31kw0ylwxg.jpg)

![播放视频的代码1](https://ws2.sinaimg.cn/large/006tNc79gy1fvo9a3iswxj31kw0yl4kg.jpg)
![播放视频的代码2](https://ws3.sinaimg.cn/large/006tNc79gy1fvo9a5ex3lj31kw0yldze.jpg)

![播放效果.gif](https://ws2.sinaimg.cn/large/006tNc79gy1fvo9aab077g30yo0jykjn.gif)

最后, 我们来分别实现三个按钮的效果

* 返回键

* Like按键
![爱心效果头文件](https://ws4.sinaimg.cn/large/006tNc79gy1fvo9ac7qv7g30yo0jykjn.gif)
![爱心效果](https://ws4.sinaimg.cn/large/006tNc79gy1fvo9afe05pg30yo0jyx6p.gif)

* Gift按键
![礼物和烟花效果](https://ws3.sinaimg.cn/large/006tNc79gy1fvo9aho2vhj31kw0ylnl0.jpg)


最后斗胆奉上整个项目的代码, 以供参考:

链接: https://pan.baidu.com/s/1c2DUFNM 密码: kdwv
