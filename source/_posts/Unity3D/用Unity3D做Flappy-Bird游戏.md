---
title: 用Unity3D做Flappy Bird游戏
date: 2016-02-15 11:27:28
tags: [Unity3D]
categories: [Unity3D]
---

效果展示：

![效果展示](http://ww4.sinaimg.cn/large/5e515a93gw1f0zv71h19bg20ma0ad7wh.gif)

<!-- more -->

创建项目用到的文件夹 例如 `images`  `scripts`等，之后将图片素材拖入到`images`中， 如下图所示：

![imags.png](http://ww3.sinaimg.cn/large/5e515a93gw1f0zv7vw25aj20cv02nglq.jpg)

接着创建鸟扇动翅膀的动画 如下图所示
![小鸟挥动翅膀动画的绘制](http://ww3.sinaimg.cn/large/5e515a93gw1f0zv8darwtg20wo0hs4qp.gif)
这样一个 Bird 扇动翅膀的动画就完成了

接下来呢，该为我们的小Bird 加上上下两个顶部， 如下图所示：
![topandbuttom.gif](http://ww2.sinaimg.cn/large/5e515a93gw1f0zv8v8x3mg20wo0hs4qp.gif)

之后我们为上下两个顶部和小鸟加上碰撞检测并给小鸟加上重力，如下图所示：
![加上碰撞检测和小鸟的重力](http://ww4.sinaimg.cn/large/5e515a93gw1f0zva46ihsg20wo0hsb01.gif)

紧接着， 我们需要为小鸟能在按空格键或者鼠标右键的时候，跳一下，为此，在`scripts`文件夹下创建`birds` C# script 文件  
![小鸟的起跳和碰撞检测](http://ww2.sinaimg.cn/large/5e515a93gw1f0zvazi127j20kv0d7mzh.jpg)
*下面解释一下代码*：
首先，C# 的程序入口在unity3d中被封装成了 `Start()` 和 `Update()`两个，其中 `Start()` 是在游戏启动后仅仅执行一次，一般完成一些初始化工作， 而`Update()`则是在游戏启动后逐帧执行，也即每帧执行一次`Update()`函数

**第6行** 定义了小鸟的飞行速度值， 即可以理解成没按一下按键上升多少距离
**第14行** 检测是否触发了键盘的空格键或者是鼠标的右键，其中`GetMouseButtonDown()`的参数中`0`为左键，`1`为中键，`2`为右键，若触发则接着执行第15行的动作， 即将小鸟的y轴上的速度加上刚才设置的瞬时速度。
**第19行** 的代码用来检测小鸟和上下顶的关系，若两者碰到则在终端打印 "Game Over" 并重新加载游戏`ps: 这里要注意将上下两个顶部的名字重命名成为end`

之后将上述写好的代码单击按下不要松开拖到bird上，像如下所示：
![](http://ww3.sinaimg.cn/large/5e515a93gw1f0zvbtxghng20mr0g6t9n.gif)

下一步
先将照相机的投影模式改成正交模式， 因为我们做的是2d游戏，所以选择正交模式更加适合一些

![22_07_15_09_48_16.png](http://ww1.sinaimg.cn/large/5e515a93gw1f0zvc9retgj20b505caac.jpg)

然后为Flappy Bird 添加背景图片 首先和小鸟图片一样将导入的背景图片变成unity可以直接用的2d精灵图片， 之后直接拖到我们的场景中就可以了
如下图所示：

分别调整背景和小鸟的layer
![Paste_Image.png](http://ww4.sinaimg.cn/large/5e515a93gw1f0zvcm64hgj20lb0a7gmh.jpg)

这样一个基本的雏形已经完成了， 下面就该为小鸟添加障碍物

在这之前， 为了界面简洁可以将背景图片和上下顶部放到一个空的GameObject里然后命名这个GameObject为BG， 即如下图所示
![22_07_15_09_47_00.png](http://ww4.sinaimg.cn/large/5e515a93gw1f0zvcxo9gdj205v05t748.jpg)

接着将我们`images`文件夹中的pipe1像之前那样编程unity可用的精灵对象，之后拖到我们的场景列表中放置好位置后，复制一个相同的pipe出来 然后旋转180并拖动位置 像下图所示：

![22_07_15_09_56_01.png](http://ww3.sinaimg.cn/large/5e515a93gw1f0zvd86ouoj209j07d0sy.jpg)

因为这两根柱子必须要对齐才行所以创建一个新的GameObject将两根柱子拖到其中，并命名该GameObject 为pipes

这样我们的柱子的场景就做好了 接下来 我们要做的是让柱子动起来，首先将其移出视线内，然后在`scripts`文件夹中创建`Move` c# script 文件用来控制柱子的移动



![Paste_Image.png](http://ww1.sinaimg.cn/large/5e515a93jw1f0zvdjvw5oj20rr0a4wgx.jpg)

**第6行:** 首先设置柱子移动的距离 这个大家需要自己算一下自己的 我的柱子是从右向左 分别x的坐标为（7）和（-12）所以移动的距离为-19
**第7行：** 设置了柱子移动的速度值
**第8行：** 定义了柱子的终止位置（即一个三维向量）
**第11行：** 在Start() 函数中首先计算出endPos坐标
**第16行：** 在Update() 函数中计算柱子实时坐标
**第17行：** 该行用来检测柱子是否移动到了终止坐标，一旦移动到了，则自我销毁。

到了这一步，我们的鸟儿应该可以穿越柱子啦， 但是这时候小鸟碰到柱子上并不会有什么反应，然么怎么加上小鸟碰到柱子时候结束游戏呢？ 最简单的办法就是修改两个柱子的名字和上下底部一样为 `end` 并给柱子加上碰撞检测组件即如下图所示：

![Paste_Image.png](http://ww4.sinaimg.cn/large/5e515a93jw1f0zve05950j206r05hmx3.jpg)

接下来我们创建更多的柱子， 为了实现这一点，要用到一个叫做预制的技术
首先在`images`, `scripts`等在同一目录创建一个新的文件夹叫做 `prebab`。

然后如下图所示，将场景中的pipes对象拖到prefab文件夹中做成预制件：
![prefab.gif](http://ww4.sinaimg.cn/large/5e515a93jw1f0zvegi5dyg20g80hdt9g.gif)

然后在`scripts`文件夹中创建一个新的名叫 `CreatePipes` 的C# script 文件
先将其拖拽到Main Camera下作为其组件，并写下以下代码：

![Paste_Image.png](http://ww4.sinaimg.cn/large/5e515a93gw1f0zver1arfj20rq09fq4d.jpg)

**第5行：** 首先创建一个pipesPrefab的GameObject 待会用来关联之前的pipesPrefab;
**第8行：** 重复调用 "Create"函数
**第12行：** 实例化pipesPrefab， 即不断的制造柱子

写完后保存回到Unity3D 将`prefab`文件夹中的pipes和Main Camera中的 pipesPrefab 关联（即拖拽到标签为pipesPrefab 的值中）之后就可以将场景中原来的pipes 删除掉。

完成后效果如下图所示：

![prefab2.gif](http://ww2.sinaimg.cn/large/5e515a93gw1f0zvfrz12yg20m40a4x0u.gif)
这样就能源源不断的出现柱子啦！ ：）

很显然，我们不能让柱子一直这么以一个不动的姿态出现，　下面来看看如何让柱子的高度发生些变化：
完成这一步其实非常简单我们只需要自己测量下柱子在屏幕中ｙ轴的上下临界值即可（例如pipes的ｙ轴设置为3则上面的柱子恰好在屏幕上看不到，ｙ轴设置为-3则下面的柱子恰好看不到）

修改`CreatePipes`这个脚本文件的第12行为：以下代码：
![Paste_Image.png](http://ww3.sinaimg.cn/large/5e515a93gw1f0zvg52sxpj20my01f3ys.jpg)
该代码是重载了Instantiate这个函数其中第二个参数就是设置柱子出现的位置，第三个是柱子的旋转角度，这里我们像如上代码设置为恒定值即可。

如此以下 我们的柱子出现的时候位置就是随机的啦，效果如下所示：

![prefab3.gif](http://ww1.sinaimg.cn/large/5e515a93gw1f0zvgjyduvg20m40a41kx.gif)

接下来，我们为小鸟加上分数， 即每通过一个柱子，获得一点分数， 首先在场景中添加一个 Canvas（在场景列表中右键UI中选择Canvas）并在Canvas中添加Text移动到适宜的位置并修改其内容为0

![Paste_Image.png](http://ww2.sinaimg.cn/large/5e515a93gw1f0zvgvrr37j20qi09f755.jpg)

接下来我们要如何知道小鸟通过了一个柱子呢？ 这里用到触发检测， 即一种特殊的碰撞检测（不影响物体的运动，仅仅检测两者有没有碰着）

将pipes从prefab中拖回到场景列表之后在pipes中新建一个Cube并用其填充两个柱子之间的空隙，如下图所示：

![pipes.gif](http://ww1.sinaimg.cn/large/5e515a93gw1f0zvh5upfug20n30ftth6.gif)

接着如下图做一些修改：

![pipes2.gif](http://ww4.sinaimg.cn/large/5e515a93gw1f0zvhogex6g20yg0i6agg.gif)

到这里触发体就设置好了，下面通过一个脚本来测试是否通过柱子并为其加分, 打开 之前创建的 `Bird` C# script 文件

![Paste_Image.png](http://ww3.sinaimg.cn/large/5e515a93gw1f0zvhyt0nlj20u90h1jv0.jpg)
**第2行：** 添加UnityEngine.UI库 以便可以获得Text对象
**第7、8行：** 分别定义scoreText对象和整型score变量
**第30行：** 该函数用于处理触发离开事件（即小鸟飞过柱子后分数+1）

保存退出后，将Canvas中的Text和bird1对象的组件中的ScoreText关联起来

之后修改场景列表中pipes下Cube名称为score之后点即右侧的Apply然后删掉该pipes

![score2.gif](http://ww4.sinaimg.cn/large/5e515a93gw1f0zvieiyofg20yg0hw0za.gif)

最后一步， 得分时，如何加上声音呢，首先我们创建新的文件夹叫做`audio`并且将我们的声音资源文件添加进来， 然后打开 `Bird` 脚本文件 添加以下第6行和第35行代码之后保存退出：

![Paste_Image.png](http://ww4.sinaimg.cn/large/5e515a93gw1f0zvimvz48j20b001uq31.jpg)

![Paste_Image.png](http://ww3.sinaimg.cn/large/5e515a93gw1f0zvjbhb6cj20bk012t8q.jpg)

然后将声音文件 关联到bird下得的coin：

![coin.gif](http://ww4.sinaimg.cn/large/5e515a93gw1f0zvjsalivg20yg0hw77h.gif)

最后点击bird添加AudioSource组件，如下图所示：


![audioSource2.gif](http://ww3.sinaimg.cn/large/5e515a93gw1f0zvk4ux5hg20yg0ho458.gif)

到目前为止，我们的FlappyBird小游戏就告一段落了。。。

感谢各位看到这里。。。