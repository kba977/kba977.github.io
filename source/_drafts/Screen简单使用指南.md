---
title: Screen简单使用指南
tags:
---



`screen -S sessionName`

创建 Screen 会话并指定名字



`screen -ls`

用来查看当前有哪些窗口被开启



`screen -r no/name`

 恢复处于`Detached`  状态的一个会话(通过序列号或者名字)





#### 2. 状态

`Attached`

`Detached`

`Removed`



#### 3. 操作

`Ctrl a` + ` d`  : 从当前会话中分离