---
title: NetCat学习笔记
tags: [工具]
categories: [工具]
date: 2016-07-14 09:45:51
---

<blockquote class="blockquote-center">
NetCat，在网络工具中有“瑞士军刀”美誉，其有Windows和Linux的版本。因为它短小精悍（1.84版本也不过25k，旧版本或缩减版甚至更小）、功能实用，被设计为一个简单、可靠的网络工具，可通过TCP或UDP协议传输读写数据。同时，它还是一个网络应用Debug分析器，因为它可以根据需要创建各种不同类型的网络连接。
</blockquote>

## 版本参数简介

    语 法: nc [-hlnruz][-g<网关...>][-G<指向器数目>][-i<延迟秒数>][-o<输出文件>][-p<通信端口>][-s<来源地址>][-v...][-w<超时秒数>][主机名称][通信端口...]

补充说明：执行本指令可设置路由器的相关参数。

<!-- more -->

参 数:  

    -g<网关> 设置路由器跃程通信网关，最多可设置8个。
    -G<指向器数目> 设置来源路由指向器，其数值为4的倍数。
    -h 在线帮助。
    -i<延迟秒数> 设置时间间隔，以便传送信息及扫描通信端口。
    -l 使用监听模式，管控传入的资料。
    -n 直接使用IP地址，而不通过域名服务器。
    -o<输出文件> 指定文件名称，把往来传输的数据以16进制字码倾倒成该文件保存。
    -p<通信端口> 设置本地主机使用的通信端口。
    -r 乱数指定本地与远端主机的通信端口。
    -s<来源地址> 设置本地主机送出数据包的IP地址。
    -u 使用UDP传输协议。
    -v 显示指令执行过程, -vv 显示更加详细的过程。
    -w<超时秒数> 设置等待连线的时间。
    -z 使用0输入/输出模式，只在扫描通信端口时使用。

## 常用功能

### 1. 建立Socket

首先在server1 中监听自己本地的 1234 端口

    [root@server1 ~]# nc -l 1234   

然后在server2 上执行下面命令连接server1 的 1234 的端口

    [root@server2 ~]# nc server1的ip 1234


### 2. 数据传送

假如我们想要在 serverA 和 serverB 两台主机之间传文件, 这里以A主机向B主机传送`data.txt`文件为例:   

首先在 serverB 主机上执行命令:

    [root@serverB ~]# nc -l 1000(任意未使用端口) > data.txt 

即监听1000端口, 并将数据流重定向到`data.txt` 文件中

然后在 serverserverA 主机上执行命令: 

    [root@serverA ~]# nc B主机ip 1000(任意未使用端口) < data.txt

### 3. 端口扫描

我们还可以使用 nc 的端口扫描功能, 来探测某一主机的端口开放情况, 如下面命令的功能为扫描 `192.168.200.29` 主机的 20 到 30 端口, `-v` 表示显示执行结果, `-w 1` 表示超过1秒后重连, `-z` 指定端口。
 
    [root@backup ~]# nc -v -w 1 192.168.200.29 -z 20-30
---

    nc: connect to 192.168.200.29 port 20 (tcp) failed: Connection refused
    nc: connect to 192.168.200.29 port 21 (tcp) failed: Connection refused
    Connection to 192.168.200.29 22 port [tcp/ssh] succeeded!
    nc: connect to 192.168.200.29 port 23 (tcp) failed: Connection refused
    nc: connect to 192.168.200.29 port 24 (tcp) failed: Connection refused
    nc: connect to 192.168.200.29 port 25 (tcp) failed: Connection refused
    nc: connect to 192.168.200.29 port 26 (tcp) failed: Connection refused
    nc: connect to 192.168.200.29 port 27 (tcp) failed: Connection refused
    nc: connect to 192.168.200.29 port 28 (tcp) failed: Connection refused
    nc: connect to 192.168.200.29 port 29 (tcp) failed: Connection refused
    nc: connect to 192.168.200.29 port 30 (tcp) failed: Connection refused

未完待续...
