---
title: django_restful_framework_指北
tags:
---

## 第一步: 序列化
最常用的就是: `ModelSerializer`

参考代码如下:
```Python
class SnippetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Snippet
        fields = ('id', 'title', 'code', 'linenos', 'language', 'style')
```

其中只要指定对应的`model`和`fields`就好

## 第二步: 视图函数
最常用的就是: `generics`, 其中实现的类有 `ListCreateAPIView`, `RetrieveUpdateDestroyAPIView`  
- `ListCreateAPIView`: 对应于 `GET`和 `POST`请求, 即常用来列出资源列表或者新添一条资源
- `RetrieveUpdateDestroyAPIView`: 对应于 `GET`, `PUT` 和 `DELETE`方法, 主要用来对某一个具体的资源进行操作(查改删)
