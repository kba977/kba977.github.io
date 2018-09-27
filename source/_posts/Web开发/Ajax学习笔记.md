---
title: Ajax学习笔记
date: 2016-02-24 12:42:12
tags: [Ajax]
categories: [Web开发]
---

<blockquote class="blockquote-center">
昨天学习了[慕课网](http://www.imooc.com/video/5644)关于Ajax的知识, 为了达到不让自己忘记, 且总结知识的目的, 遂写了此篇博客总结。
下面废话不多说, 让我们开始吧。
</blockquote>
    
# 1. Ajax概念介绍
## 什么是 AJAX ？
- AJAX =  Asynchronous JavaScript and XML 即: 异步 JavaScript 和 XML(Json是事实上的标准)。
- AJAX 是一种用于创建快速动态网页的技术。
- 通过在后台与服务器进行少量数据交换，AJAX 可以使网页实现异步更新。这意味着可以在`不重新加载整个网页`的情况下，对网页的`某部分`进行更新。
- 传统的网页（不使用 AJAX）如果需要更新内容，必需`重载整个网页面`。
- 有很多使用 AJAX 的应用程序案例：新浪微博、Google 地图、开心网等等。   

<!-- more -->

## 1.1 同步和异步
场景：
　　在网页上填写简历，页面中有几十项信息需要填写，填写过程中有若干项填写错误。
没有AJAX(同步)：
　　填写完成后，点击提交，上传所有信息，等待服务器的检查，再通知某一项填写错误。
使用AJAX(异步)：
　　写过程中，每填写完一项，立刻发送到服务器检查，实时提示某一项是否填写正确。

## 1.2 XMLHttpRequest对象
### XMLHttpRequest 对象
　　所有现代浏览器均支持 XMLHttpRequest 对象（IE5 和 IE6 使用 ActiveXObject）。
　　XMLHttpRequest 用于在后台与服务器交换数据。这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。

### 创建 XMLHttpRequest 对象
　　为了应对所有的现代浏览器，包括 IE5 和 IE6，请检查浏览器是否支持 XMLHttpRequest 对象。如果支持，则创建 XMLHttpRequest 对象。如果不支持，则创建 ActiveXObject:
``` javascript
var xmlhttp;
if (window.XMLHttpRequest) {   
    // code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp = new XMLHttpRequest();
} else {   
    // code for IE6, IE5
    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
}
```

## 1.3 HTTP请求
HTTP是一种无状态协议, 即不保留客户端和服务器的连接, 一旦请求完成就关闭连接。
一个`完整`的Http请求包含以下`7`个步骤:
1. 建立TCP连接
2. Web浏览器向Web服务器发送请求命令
3. Web浏览器发送请求头信息
4. Web服务器应答
5. Web服务器发送应答头信息
6. Web服务器向浏览器发送数据
7. Web服务器关闭TCP连接

下面, 我们分别介绍HTTP请求和HTTP响应

**一个HTTP请求包含以下`4`个部分**:
1. Http请求的`方法`或`动作`, 比如是GET还是POST请求
2. 正在请求的`URL`, 总得知道请求的地址是什么吧
3. `请求头`, 包含一些客户端环境信息, 身份验证信息等
4. `请求体`, 也就是请求正文, 请求正文中可以包含客户提交的查询字符串信息, 表单信息等

其中`GET`和`POST`的区别如下:
- GET: 一般用于信息获取, 使用URL传递参数, 对所发送信息的数量也有限制, 一般在2000个字符
- POST: 一般用于修改服务器上的资源, 对所发送信息的数量无限制

以下是一个典型的HTTP请求
![HTTP请求](https://ws3.sinaimg.cn/large/006tNc79gy1fvo6xw6o0oj30li09o753.jpg)
如上图所示: 第一行是请求方法和正在请求的URL, 第二行到倒数第二行为请求头部, 最后一行是请求体

**一个HTTP响应包含以下`3`部分**: 
1. 一个`数字`和`文字`组成的`状态码`, 用来显示请求是成功还是失败
2. `响应头`, 响应头也和请求头一样包含许多有用的信息, 例如服务器类型、日期时间、内容类型和长度等
3. `响应体`, 也就是响应正文

以下是一个典型的HTTP应答
![HTTP应答](https://ws1.sinaimg.cn/large/006tNc79gy1fvo6xww7qij30j808h0t4.jpg)

其中, 应该记住以下常用的状态码:
- 1XX: `信息类`, 表示收到Web浏览器的请求, 正在进一步的处理中
- 2XX: `成功`, 表示用户请求被正确接收, 理解和处理, 例如: 200 OK
- 3XX: `重定向`, 表示请求没有成功, 客户必须采取进一步的动作
- 4XX: `客户端错误`, 表示客户端提交的请求有错误, 例如: 404 NOT Found, 意味着请求中所引用的文档不存在
- 5XX: `服务器错误`, 表示服务器不能完成对请求的处理, 例如: 500

## 1.4 XMLHttpRequest发送请求
    规定请求的类型、URL以及是否异步处理请求。
    open(method, url, async)
    参数：
        method： 发送请求的方法(GET, POST)
        url: 请求地址(相对、绝对)
        async: 请求同步、异步(默认 True, 即异步)       

    发送请求到服务器
    send(string)   GET无参数, POST有参数

### 1.4.1 GET 请求示例

- 一个简单的 GET 请求
``` javascript
request.open("GET", "service.asp", true)
request.send()
```

- 上面的例子中, 得到的可能是缓存的结果。 为了避免这种情况, 可以向URL添加一个唯一的ID:
``` javascript
request.open("GET", "service.asp?t=" + Math.random(), true);
request.send();
```

- 如果需要在GET方法中传递参数，需要在URL中添加信息：
``` javascript
request.open("GET", "service.asp?fname=Bill&lname=Gates", true);
request.send();
```

### 1.4.2 POST 请求示例

- 使用POST请求传递参数，一定要记得在`open`和`send`方法之间使用`setRequestHeader`方法设置`Content-Type`为`“application/x-www-form-urlencoded”`:
``` javascript
request.open("POST","service.asp",true);
request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
request.send("fname=Bill&lname=Gates");
```

## 1.5 XMLHttpRequest取得响应
XMLHttpRequest 对象中有以下几个重要的属性:
- responseText: 获得字符串形式的响应数据
- responseXML: 获得XML形式的响应数据
- status和statusText: 以数字和文本形式返回HTTP状态码
- getAllResponseHeader(): 获取所有的响应报头
- getResponseHeader(): 查询响应中的某个字段的值

其中还有`2`个十分重要的属性: `readyState` 和 `onreadystatechange`
`readyState` 存有 XMLHttpRequest 的状态, 从 0 到 4 发生变化, 其值含义如下:
- 0: 请求未初始化, open还没有调用
- 1: 服务器连接已建立, open已经调用了
- 2: 请求已接收, 也就是接收到头信息了
- 3: 请求处理中, 也就是接收到响应主体了
- 4: 请求已完成, 且响应已就绪, 也就是响应完成了

`onreadystatechange` 存储函数（或函数名），每当 readyState 属性改变时，就会调用该函数。
　　在onreadystatechange事件中，我们规定当服务器响应已做好被处理的准备时所执行的任务。
当readyState等于4且状态为200时，表示响应已就绪。 

示例代码如下所示:
``` javascript service.php
var request = new XMLHttpRequest();
request.open("GET", "service.php", true);
request.send();
request.onreadystatechange = function() {
    if (request.readyState === 4 && request.status === 200) {
        // 做一些事情 request.responseText
    }
}
```

# 2. Ajax的简单例子(Ajax+PHP)
## 2.1 例子简介
## 2.2 服务器端实现
``` php service.php
<?php
//设置页面内容是html编码格式是utf-8
//header("Content-Type: text/plain;charset=utf-8"); 
header("Content-Type: application/json;charset=utf-8"); 
//header("Content-Type: text/xml;charset=utf-8"); 
//header("Content-Type: text/html;charset=utf-8"); 
//header("Content-Type: application/javascript;charset=utf-8"); 

//定义一个多维数组，包含员工的信息，每条员工信息为一个数组
$staff = array
    (
        array("name" => "洪七", "number" => "101", "sex" => "男", "job" => "总经理"),
        array("name" => "郭靖", "number" => "102", "sex" => "男", "job" => "开发工程师"),
        array("name" => "黄蓉", "number" => "103", "sex" => "女", "job" => "产品经理")
    );

//判断如果是get请求，则进行搜索；如果是POST请求，则进行新建
//$_SERVER是一个超全局变量，在一个脚本的全部作用域中都可用，不用使用global关键字
//$_SERVER["REQUEST_METHOD"]返回访问页面使用的请求方法
if ($_SERVER["REQUEST_METHOD"] == "GET") {
    search();
} elseif ($_SERVER["REQUEST_METHOD"] == "POST"){
    create();
}

//通过员工编号搜索员工
function search(){
    //检查是否有员工编号的参数
    //isset检测变量是否设置；empty判断值为否为空
    //超全局变量 $_GET 和 $_POST 用于收集表单数据
    if (!isset($_GET["number"]) || empty($_GET["number"])) {
        echo "参数错误";
        return;
    }
    //函数之外声明的变量拥有 Global 作用域，只能在函数以外进行访问。
    //global 关键词用于访问函数内的全局变量
    global $staff;
    //获取number参数
    $number = $_GET["number"];
    $result = "没有找到员工。";
    
    //遍历$staff多维数组，查找key值为number的员工是否存在，如果存在，则修改返回结果
    foreach ($staff as $value) {
        if ($value["number"] == $number) {
            $result = "找到员工：员工编号：" . $value["number"] . "，员工姓名：" . $value["name"] . 
                              "，员工性别：" . $value["sex"] . "，员工职位：" . $value["job"];
            break;
        }
    }
    echo $result;
}

//创建员工
function create(){
    //判断信息是否填写完全
    if (!isset($_POST["name"]) || empty($_POST["name"])
        || !isset($_POST["number"]) || empty($_POST["number"])
        || !isset($_POST["sex"]) || empty($_POST["sex"])
        || !isset($_POST["job"]) || empty($_POST["job"])) {
        echo "参数错误，员工信息填写不全";
        return;
    }
    //TODO: 获取POST表单数据并保存到数据库
    
    //提示保存成功
    echo "员工：" . $_POST["name"] . " 信息保存成功！";
}
```

## 2.3 PHP服务端代码测试

## 2.4 客户端实现
``` html demo.html
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>Demo</title>
    <style type="text/css">
    body, input, button, select, h1 {
        font-size: 20px;
        line-height: 1.8;
    }
    </style>
</head>

<body>
    <h1>搜索员工</h1>
    <label>请输入员工编号</label>
    <input type="text" id="keyword">
    <button id="search">搜索</button>
    <p id="searchResult"></p>
    <h1>创建员工</h1>
    <label>请输入员工姓名</label>
    <input type="text" id="staffName"> <br>
    <label>请输入员工编号</label>
    <input type="text" id="staffNumber"> <br>
    <label>请选择员工性别</label>
    <select id="staffSex"> <br>
        <option>男</option>
        <option>女</option>
    </select> <br>
    <label>请输入员工职业</label>
    <input type="text" id=staffJob> <br>
    <button id="save">保存</button>
    <p id="createResult"></p> 
    <script type="text/javascript">
    document.getElementById("search").onclick = function(){
        // 发送Ajax查询请求并处理
        var request = new XMLHttpRequest();
        request.open("GET", "service.php?number=" + document.getElementById("keyword").value);
        request.send();
        request.onreadystatechange = function() {
            if (request.readyState === 4) {
                if (request.status === 200) {
                    var data = JSON.parse(request.responseText);
                    if (data.success) {
                        document.getElementById("searchResult").innerHTML = data.msg;
                    } else {
                        document.getElementById("searchResult").innerHTML = "出现错误：" + data.msg;
                    }
                    
                } else {
                    alert("发生错误"+request.status);
                }
            }
        }
    }

    document.getElementById("save").onclick = function(){
        // 发送Ajax查询请求并处理
        var request = new XMLHttpRequest();
        request.open("POST", "service.php");
        var data = "name=" + document.getElementById("staffName").value
                    + "&number=" + document.getElementById("staffNumber").value
                    + "&sex=" + document.getElementById("staffSex").value
                    + "&job=" +document.getElementById("staffJob").value; 
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        request.send(data);
        request.onreadystatechange = function() {
            if (request.readyState === 4) {
                if (request.status === 200) {
                    var data = JSON.parse(request.responseText);
                    if (data.success) {
                        document.getElementById("createResult").innerHTML = data.msg;
                    } else {
                        document.getElementById("createResult").innerHTML = "出现错误：" + data.msg;
                    }
                } else {
                    alert("发生错误"+request.status);
                }
            }
        }
    }
    </script> 

</body>
</html>
```

# 3. Json格式
## 3.1 Json基本概念
`JSON`：JavaScript对象表示法（JavaScript Object Notation）。
JSON是存储和交换文本信息的语法，类似XML。它采用键值对的方式来组织，易于人们阅读和编写，同时也易于机器解析和生成。
JSON是独立于语言的，也就是说不管什么语言，都可以解析JSON，只需要按照JSON的规则来就行。

**与XML比较**
- JSON的长度和XML格式比起来很短小。
- JSON读写的速度比XML快。
- JSON可以使用JavaScript内建的方法直接进行解析，转换成JavaScript对象，非常方便。

**与AJAX的关系**
　　在AJAX中，使用JSON传递数据已成为事实上的标准，很少使用XML。

## 3.2 json解析、格式化和校验工具
JSON 的定义如下:
1. 并列的数据之间用逗号`,`分隔
2. 映射用冒号`:`表示
3. 并列数据的集合（数组）用方括号`[]`表示
4. 映射的集合（对象）用大括号`{}`表示

用图例表示如下:
![JSON1](https://ws2.sinaimg.cn/large/006tNc79gy1fvo6xyqum5g30gm035jr9.gif)

![JSON2](https://ws1.sinaimg.cn/large/006tNc79gy1fvo6xz7l5ig30gm035glg.gif)

其中 Value 格式定义如下: 
![Value](https://ws2.sinaimg.cn/large/006tNc79gy1fvo6xzosdfg30gm07qq2x.gif)

**JSON解析**
- `eval`和`JSON.parse`
- 在代码中使用eval是很危险的! 特别是用它执行第三方的JSON数据(其中可能包含恶意代码)时, 尽可能使用JSON.parse()方法解析字符串本身, 该方法还可以捕捉JSON中的语法错误。

**JSON校验工具**
[JSONLint在线JSON校验工具](http://jsonlint.com/)
使用截图:
{% img http://ww2.sinaimg.cn/large/5e515a93gw1f1avj0ay60j21he0wiwie.jpg error %}

{% img http://ww4.sinaimg.cn/large/5e515a93gw1f1avk620ifj21gy0tcwgp.jpg success %}

<!-- ![error](https://ws3.sinaimg.cn/large/006tNc79gy1fvo6y08e7yj31he0wiwie.jpg)
![success](https://ws3.sinaimg.cn/large/006tNc79gy1fvo6y0oxxlj31gy0tcwgp.jpg) -->

# 4. jQuery中的Ajax
## 4.1 jQuery中的Ajax
将上述`service.php`文件中的`script`标签换成以下: 
``` javascript demo.html
<script src="http://apps.bdimg.com/libs/jquery/1.11.1/jquery.min.js"></script>
<script>
    $(document).ready(function(){
        $("#search").click(function(){
            $.ajax({
                type: "GET",
                url: "http://localhost/service.php?number=" + $("#keyword").val(),
                dataType: "json",
                success: function(data){
                    if(data.success) {
                        $("#searchResult").html(data.msg);
                    } else {
                        $("#searchResult").html("出现错误：" + data.msg);
                    }
                },
                error: function(jqXHR){
                    alert("发生错误: "+ jqXHR.status)
                }
            });
        });

        $("#save").click(function(){
            $.ajax({
                type: "POST",
                url: "service.php",
                dataType: "json",
                data: {
                    name: $("#staffName").val(),
                    number: $("#staffNumber").val(),
                    job: $("#staffJob").val(),
                    sex: $("#staffSex").val(),
                },
                success: function(data){
                    if(data.success) {
                        $("#createResult").html(data.msg);
                    } else {
                        $("#createResult").html("出现错误：" + data.msg);
                    }
                },
                error: function(jqXHR){
                    alert("发生错误: "+ jqXHR.status)
                }
            });
        });
    });
</script>
```

# 5. 跨域
一个域名地址的组成:
例如: `http://www.abc.com:8080/scripts/jquery.js`
其中: 
- `协议` : http://
- `子域名` : www
- `主域名` : abc.com
- `端口号` : 8080
- `请求资源地址` : scripts/jquery.js
当协议、子域名、主域名、端口号中任意一个不相同时, 都算作不同域
不同域之间相互请求资源, 就算作 "跨域"
比如: http://www.abc.com/index.html 请求 http://www.efg.com/service.php

## 5.1 处理跨域的方式--代理
- 通过在同域名的web服务器端创建一个代理:
- 北京服务器(域名: www.beijing.com)
  上海服务区(域名: www.shanghai.com)
- 比如在北京的web服务器的后台
  (www.beijing.com/proxy-shanghaiservice.php)来调用上海服务器(www.shanghai.com/service.php)的服务, 然后再把响应的结果返回给前端, 这样前端调用北京同域名的服务就和调用上海的服务效果相同了

## 5.2 处理跨域的方式--JSONP
**客户端**
以jquery为例:
将Jquery Ajax中的dataType字段修改为`jsonp`:

    dataType: "json"
然后添加`jsonp`字段:

    jsonp: "callback"

**服务器端**
在`search()`函数中首先获取到jsonp变量

    $jsonp = $_GET["callback"];
然后将所有返回值改造成以下样式:

改造前:

    $result = '{"success":false, "msg": "没有找到员工"}'
改造后:

    $result = jsonp . '({"success":false, "msg": "没有找到员工"})'
以上即可

**注意**: Jsonp 这种跨域方式仅仅对GET请求起作用, 对POST无效。

## 5.3 处理跨域的方式--XHR2
- HTML5提供的`XMLHttpRequest Level 2`已经实现了跨域访问以及其他的一些新功能
- IE10 以下的版本都不支持
- 在服务器端做一些小小的改造即可:     


    header('Access-Control-Allow-Origin:*');
    header('Access-Control-Allow-Methods:POST,GET');

# 6. 总结
　　Ajax的概念和使用都非常简单, 但是想要熟练掌握, 我们还需要在实践中理解, 这仅仅是一个开始, 让我们共勉吧。 :P

(完)
