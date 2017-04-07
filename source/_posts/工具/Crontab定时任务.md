---
title: Crontab定时任务
tags: [工具]
categories: [工具]
date: 2016-07-15 14:47:24
---

<blockquote class="blockquote-center">
通过crontab 命令，我们可以在固定的间隔时间执行指定的系统指令或 shell script脚本。时间间隔的单位可以是分钟、小时、日、月、周及以上的任意组合。这个命令非常适合周期性的日志分析或数据备份等工作。
</blockquote>


## 1. crontab的文件格式

    分 时 日 月 星期 要运行的命令


第1列分钟1～59
第2列小时1～23（0表示子夜）
第3列日1～31
第4列月1～12
第5列星期0～6（0表示星期天）
第6列要运行的命令

例如, 表示每过三小时执行一次 `sh /tmp/command.sh` 命令:

    0 */3 * * * sh /tmp/command.sh

<!-- more -->

## 2. 列出crontab文件

使用-l参数列出crontab文件:

    $ crontab -l
    0,15,30,45,18-06 * * * /bin/echo `date` > dev/tty1


## 3. 使用实例

### 实例1：每1分钟执行一次myCommand
    
    * * * * * myCommand
### 实例2：每小时的第3和第15分钟执行
    
    3,15 * * * * myCommand
### 实例3：在上午8点到11点的第3和第15分钟执行
    
    3,15 8-11 * * * myCommand
### 实例4：每隔两天的上午8点到11点的第3和第15分钟执行
    
    3,15 8-11 */2  *  * myCommand
### 实例5：每周一上午8点到11点的第3和第15分钟执行
    
    3,15 8-11 * * 1 myCommand
### 实例6：每晚的21:30重启smb
    
    30 21 * * * /etc/init.d/smb restart
### 实例7：每月1、10、22日的4 : 45重启smb
    
    45 4 1,10,22 * * /etc/init.d/smb restart
### 实例8：每周六、周日的1 : 10重启smb
    
    10 1 * * 6,0 /etc/init.d/smb restart
### 实例9：每天18 : 00至23 : 00之间每隔30分钟重启smb
    
    0,30 18-23 * * * /etc/init.d/smb restart
### 实例10：每星期六的晚上11 : 00 pm重启smb
    
    0 23 * * 6 /etc/init.d/smb restart
### 实例11：每一小时重启smb
    
    * */1 * * * /etc/init.d/smb restart
### 实例12：晚上11点到早上7点之间，每隔一小时重启smb
    
    * 23-7/1 * * * /etc/init.d/smb restart