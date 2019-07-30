---
title: Python数据可视化
tags: [数据可视化]
categories: [Python]
date: 2016-05-25 12:02:33
---

### 基础

用python的matplotlib模块画最简单的折线图, 及在图中添加文字和图例

``` python
import matplotlib.pyplot as plt

plt.plot([1,3,2,4])
plt.ylabel('some number')
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/1_折线图.jpg)

<!-- more -->

其中如果你向`plot()`指令提供了**一维的数组或列表**, 那么matplotlib将**默认**它是一系列的**y**值, 并**自动**为你生成x的值。

plot()一个通用的命令, 可以输入任意多的参数。例如, 画y和x的关系，你可以使用如下指令：

``` python
import matplotlib.pyplot as plt

plt.plot([1,2,3,4], [1,4,9,16])
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/2_X轴和Y轴.jpg)

对于每对x,y参数, 都可以加上一个可选的第三参数, 控制画图中的**颜色**和**线型**。   
控制字符的字母与matlab是统一的，并且颜色控制和线型控制可以叠加。默认的控制字符串是'b-'，是**蓝色实线**。假如，你想画红色圆点，你可以通过以下指令来实现:

``` python
import matplotlib.pyplot as plt

plt.plot([1,2,3,4], [1,4,9,16], 'ro')
plt.axis([0, 6, 0, 20])
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/3_红色圆点.jpg)

上面例子里的axis()命令给定了坐标范围, 格式是[xmin, xmax, ymin, ymax], 上图表示x轴从0-6, y轴从0-20。

实际上，matplotlib不仅可以用于画向量，还可以用于画多维数据数组。下面，我们将演示用一条指令画多条不同格式的线。

``` python
import numpy as np
import matplotlib.pyplot as plt

# 生成一组排列, 从 0.0 到 5.0 间隔 0.2
t = np.arange(0., 5., 0.2)
# t = array([ 0., 0.2, 0.4, ..., 4.6,  4.8])

# 红色虚线, 蓝色方块, 绿色上三角
plt.plot(t, t, 'r--', t, t**2, 'bs', t, t**3, 'g^')
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/4_多维向量.jpg)

我们可以通过`linewidth`来设置线宽
``` python
import matplotlib.pyplot as plt

plt.plot([1,2,3,4], [1,4,9,16],linewidth=2.0)
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/5_设置线宽.jpg)

通过设定`set_antialiased`来确定是否消除锯齿
``` python
import matplotlib.pyplot as plt

line, = plt.plot([1,2,3,4], [1,4,9,16], '-')
line.set_antialiased(False) # 关闭反锯齿
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/6_消除锯齿.jpg)

我们也可以用lines = plot(x1,y1,x2,y2)来画两条线。可以使用`setp()`命令，可以像MATLAB一样设置几条线的性质。 setp可以使用python 关键词，也可用MATLAB格式的字符串。
``` python
import matplotlib.pyplot as plt

lines = plt.plot([1,2,3,4], [1,4,9,16], [1,2,3,4], [16,5,6,2])
# use keyword args
plt.setp(lines, color='r', linewidth=2.0)
# or MATLAB style string value pairs
plt.setp(lines, 'color', 'r', 'linewidth', 2.0)
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/7_setp.jpg)

### 修改坐标范围

默认情况下, 坐标轴的最小值和最大值与输入数据的最小、最大值一致。也就是说, 默认情况下整个图形都能显示在所画图片上  
有时候我们更关注其中的一些点, 这时, 我们可以通过`xlim(xmin, xmax)`和`ylim(ymin, ymax)`来调整 **x**, **y** 坐标范围, 见下图
``` python 
import numpy as np
import matplotlib.pyplot as plt
from pylab import *

x = np.arange(-5.0, 5.0, 0.02)
y1 = np.sin(x)

plt.figure(1)
plt.subplot(211)
plt.plot(x, y1)

plt.subplot(212)
# 设置x轴范围
xlim(-2.5, 2.5)
# 设置y轴范围
ylim(-1, 1)
plt.plot(x, y1)
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/8_修改坐标范围.jpg)

### 创建子图

你可以通过`plt.figure`创建一张新的图，`plt.subplot`来创建子图。`subplot()`指令包含`numrows`(行数), `numcols`(列数), `fignum`(图像编号)，其中图像编号的范围是从1到行数 \* 列数。在行数 \* 列数<10时，数字间的逗号可以省略。

``` python
import numpy as np
import matplotlib.pyplot as plt

def f(t):
    return np.exp(-t) * np.cos(2*np.pi*t)

t1 = np.arange(0.0, 5.0, 0.1)
t2 = np.arange(0.0, 5.0, 0.02)

plt.figure(1)
plt.subplot(211)
plt.plot(t1, f(t1), 'bo', t2, f(t2), 'k')

plt.subplot(212)
plt.plot(t2, np.cos(2*np.pi*t2), 'r--')
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/9_创建子图1.jpg)


你可以多次使用figure命令来产生多个图，其中，图片号按顺序增加。这里，要注意一个概念当前图和当前坐标。所有绘图操作仅对当前图和当前坐标有效。通常，你并不需要考虑这些事，下面的这个例子为大家演示这一细节。

``` python
import matplotlib.pyplot as plt

plt.figure(1)                # 第一张图
plt.subplot(211)             # 第一张图中的第一张子图
plt.plot([1,2,3])
plt.subplot(212)             # 第一张图中的第二张子图
plt.plot([4,5,6])


plt.figure(2)                # 第二张图
plt.plot([4,5,6])            # 默认创建子图subplot(111)

plt.figure(1)                # 切换到figure 1 ; 子图subplot(212)仍旧是当前图
plt.subplot(211)             # 令子图subplot(211)成为figure1的当前图
plt.title('Easy as 1,2,3')   # 添加subplot 211 的标题
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/10_创建子图2.jpg)
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/11_创建子图3.jpg)

### 使用text添加文字

- `text()`可以在图中的任意位置添加文字，并支持LaTex语法
- `xlable()`, `ylable()`用于添加x轴和y轴标签
- `title()`用于添加图的题目

``` python 
import numpy as np
import matplotlib.pyplot as plt

mu, sigma = 100, 15
x = mu + sigma * np.random.randn(10000)

# 数据的直方图
n, bins, patches = plt.hist(x, 50, normed=1, facecolor='g', alpha=0.75)

plt.xlabel('Smarts')
plt.ylabel('Probability')
#添加标题
plt.title('Histogram of IQ')
#添加文字
plt.text(60, .025, r'$\mu=100,\ \sigma=15$')
plt.axis([40, 160, 0, 0.03])
plt.grid(True)
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/12_使用text添加文字1.jpg)

和前面的lines的用法一样，你可以通过在`text()`输入参数或使用`setp()`来改变文字样式

``` python
t0 = plt.text(0.35,0.5,'my text')
plt.setp(t0, color='b',fontsize=24)
t = plt.xlabel('my data', fontsize=14, color='red')
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/13_使用text添加文字2.jpg)

### 注释文本

在数据可视化的过程中，图片中的文字经常被用来注释图中的一些特征。使用`annotate()`方法可以很方便地添加此类注释。在使用annotate时，要考虑两个点的坐标：被注释的地方`xy(x, y)`和插入文本的地方`xytext(x, y)`。

``` python
import numpy as np
import matplotlib.pyplot as plt

ax = plt.subplot(111)

t = np.arange(0.0, 5.0, 0.01)
s = np.cos(2*np.pi*t)
line, = plt.plot(t, s, lw=2)

plt.annotate('local max', xy=(2, 1), xytext=(3, 1.5),
            arrowprops=dict(facecolor='black', shrink=0.05),
            )

plt.ylim(-2,2)
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/14_注释文本1.jpg)

### 添加图例   
本教程将描述几种添加图例的方法。在编程开始前，我们先简单介绍一下在图例中几个需要用到的概念   
#### 图例项   
一个图例包含多个图例项，每个图例项由图例说明和图例标签构成   
#### 图例标签   
由彩色的图案构成，位于图例说明的左侧   
#### 图例说明   
图例标签的说明文字   
使用legend()函数可以自动添加图例   

``` python
line_up, = plt.plot([1,2,3], label='Line 2')
line_down, = plt.plot([3,2,1], label='Line 1')
plt.legend()
plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/15_注释文本2.jpg)

添加图例的位置可以用关键词loc来指定

``` python
import matplotlib.pyplot as plt

plt.subplot(211)
plt.plot([1,2,3], label="test1")
plt.plot([3,2,1], label="test2")
# Place a legend above this legend, expanding itself to
# fully use the given bounding box.
plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3,
           ncol=2, mode="expand", borderaxespad=0.)

plt.subplot(223)
plt.plot([1,2,3], label="test1")
plt.plot([3,2,1], label="test2")
# Place a legend to the right of this smaller figure.
plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)

plt.show()
```
![](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/Python数据可视化/16_注释文本3.jpg)