---
title: SpringBoot + GraphQL + Mysql 实现 CRUD
tags:
  - Java
  - Spring
  - GraphQL
categories:
  - Web开发
date: 2020-04-25 19:03:25
---


![spring-boot-graphql-mysql-crud-apis-feature-image](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/SpringBoot_GraphQL_MySQL实现CRUD/封面图.png)



GraphQL是一种查询语言用来设计 APIs，可替代 REST，SOAP 或 gRPC，详细的可以查看官网解释: [GraphQL](https://graphql.org/)

本教程中，我们将构建一个 Spring Boot GraphQL 例子并提供 CRUD APIs 来从 mysql 数据库中创建，查询，更新，删除对象。

<!-- more -->

## Sring Boot CRUD GraphQL APIs 概览

### 目标

我们有两个数据模型：`作者(Author)` 和 `课程(Tutorial)`。

```
Author {
  id: Long
  name: String
  age: Integer
}

Tutorial {
  id: Long
  title: String
  description: String
  author: Author
}
```

一个作者可能有多个课程 , 所以他们是一对多的关系



### CRUD GraphQL APIs

- 创建作者:

  - GraphQL

    ```java
    mutation {
      createAuthor(
        name: "bezkoder",
        age: 27) {
          id 
          name
      }
    }
    ```

  - 响应

    ```json
    {
      "data": {
        "createAuthor": {
          "id": "1",
          "name": "bezkoder"
        }
      }
    }
    ```

    

- 查询所有作者

  - GraphQL

    ```java
    query {
      findAllAuthors{
        id
        name
        age
      }
    }
    ```

  - 响应

    ```json
    {
      "data": {
        "findAllAuthors": [
          {
            "id": 1,
            "name": "张三",
            "age": 25
          },
          {
            "id": 2,
            "name": "李四"
            "age": 43
          }
        ]
      }
    }
    ```

  等等，这里先不一一列举了

如果查看数据库，你会发现有两张表: `author` 和 `tutorial`

内容如下

```
mysql> select * from author;
+----+-----+--------+
| id | age | name   |
+----+-----+--------+
|  1 |  25 | 张三   |
|  2 |  43 | 李四   |
+----+-----+--------+

mysql> select * from tutorial;
+----+-------------------------------------+----------------+-----------+
| id | description                         | title          | author_id |
+----+-------------------------------------+----------------+-----------+
|  1 | 该教程可以帮助你学习 Java              | 学习 Java       | 1         |
|  2 | 很棒的 GraphQL 教程                  | 学习 GraphQL    | 2         |
+----+-------------------------------------+----------------+-----------+
```



## 开始构建APIs

### 用到的依赖

我们的应用将用到下面这些:

- Java8 或者 java11
- Spring Boot 2.2.1.RELEASE (with Spring Web)
- Graphql-spring-boot-starter 7.0.1
- Graphiql-spring-boot-starter 7.0.1
- Gradle 6.3
- MySQL 5.7

### 项目结构

![image-20200426170523001](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/SpringBoot_GraphQL_MySQL实现CRUD/工程目录结构.png)

- resources/graphql 中所有的 `.graphqls` 定义了 GraphQL schemas
- model: 存放 Author 和 Tutorial 实体类
- mapper: 存放 Mapper 接口来和 MySQL 交互
- resolver: 通过实现一些 `Resolver`接口来处理查询和修改的请求，该类可以理解成 SpringMVC 中的 Controller 层
- application.yml: 配置文件
- build.gradle: gradle 的构建文件

### 项目准备

首先创建 Spring Boot 项目，然后添加依赖

```groovy
dependencies {
  // SpringBoot
  implementation 'org.springframework.boot:spring-boot-starter-web'
  developmentOnly 'org.springframework.boot:spring-boot-devtools'
  testImplementation('org.springframework.boot:spring-boot-starter-test') {
    exclude group: 'org.junit.vintage', module: 'junit-vintage-engine'
  }

  // Graphql
  implementation 'com.graphql-java-kickstart:graphql-spring-boot-starter:7.0.1'
  implementation 'com.graphql-java-kickstart:graphiql-spring-boot-starter:7.0.1'

  // Mybatis-Plus
  implementation 'com.baomidou:mybatis-plus-boot-starter:3.1.2'

  // Mysql
  implementation 'mysql:mysql-connector-java:5.1.6'

  // Flyway
  implementation 'org.flywaydb:flyway-core:6.3.3'

  // Lombok
  compileOnly 'org.projectlombok:lombok'
  annotationProcessor 'org.projectlombok:lombok'

  // Spock
  testImplementation 'org.spockframework:spock-core:2.0-M1-groovy-2.5'
  testImplementation 'org.spockframework:spock-spring:2.0-M1-groovy-2.5'
}
```

### 相关配置文件

打开 application.yml 并添加下面的配置

```yml
server:
  port: 8083

spring:
  flyway:
    locations: classpath:db/migration
    out-of-order: true
    url: ${spring.datasource.url}
    user: ${spring.datasource.username}
    password: ${spring.datasource.password}
  datasource:
    url: jdbc:mysql://localhost:3306/learn_graphql
    username: root
    password:
    driver-class-name: com.mysql.jdbc.Driver

mybatis-plus:
  type-aliases-package: com.kba977.learngraphql.mapper
```

### 创建 GraphQL Schema

我们为了将schema拆分到不同的文件里，以分类管理，Spring Boot GraphQL 会自动扫描所有 schema 文件

首先我们创建 Schemas

`author.graphqls`

```
type Author {
    id: ID!
    name: String!
    age: Int
}

input CreateAuthorInput {
    name: String!
    age: Int!
}
```

`tutorial.graphqls`

```
type Tutorial {
    id: ID!
    title: String!
    description: String
    author: Author
}

input CreateTutorialInput {
    title: String!
    description: String!
    authorId: ID!
}

input UpdateTutorialInput {
    title: String
    description: String
}
```

`query.graphqls`

```
# Root
type Query {
    # Author
    findAllAuthors: [Author]!
    findAuthorById(id: ID!): Author
    countAuthors: Int!

    # Tutorial
    findAllTutorials: [Tutorial]!
    findTutorialById(id: ID!): Tutorial
    countTutorials: Int!
}
```

`mutation.graphqls`

```
# Root
type Mutation {
    # Author
    createAuthor(createAuthorInput: CreateAuthorInput!): Author!

    # Tutorial
    createTutorial(createTutorialInput: CreateTutorialInput!): Tutorial!
    updateTutorial(id: ID!, updateTutorialInput: UpdateTutorialInput): Tutorial!
    deleteTutorial(id: ID!): Boolean
}
```

在 GraphQL 中分为两个大类，所有的查询入口在 `Query`, 所有的变更入口都在 `Mutation`

上面文件中 `!` 的意思该字段不能为 `null`，如果加 `!` ，那么在返回值的时候 GraphQL允许返回 null



### 定义实体类，Mapper接口，Service实现

这些我们比较熟悉，直接跳过大家可以查看源码



### 实现GraphQL Root 解析器

如下面文件 `TutorialMutationResolver` 实现了对 `Tutorial` 的变更请求处理

```java
package com.kba977.learngraphql.graphql.resolver.mutation;

import com.kba977.learngraphql.graphql.type.tutorial.CreateTutorialInput;
import com.kba977.learngraphql.graphql.type.tutorial.UpdateTutorialInput;
import com.kba977.learngraphql.model.Tutorial;
import com.kba977.learngraphql.service.TutorialService;
import graphql.kickstart.tools.GraphQLMutationResolver;
import org.apache.ibatis.javassist.NotFoundException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class TutorialMutationResolver implements GraphQLMutationResolver {

    @Autowired
    private TutorialService tutorialService;

    public Tutorial createTutorial(CreateTutorialInput input) {
        Tutorial tutorial = new Tutorial(input.getTitle(), input.getDescription(), input.getAuthorId());
        tutorialService.save(tutorial);
        return tutorial;
    }

    public Tutorial updateTutorial(Integer id, UpdateTutorialInput input) throws NotFoundException {
        Optional<Tutorial> optTutorial = Optional.ofNullable(tutorialService.getById(id));

        if (optTutorial.isPresent()) {
            Tutorial tutorial = optTutorial.get();
            BeanUtils.copyProperties(input, tutorial);
            tutorialService.updateById(tutorial);

            return tutorialService.getById(id);
        }
        throw new NotFoundException("Not found Tutorial to update!");
     }

    public boolean deleteTutorial(Integer id) {
        return tutorialService.removeById(id);
    }
}
```

### 实现 GraphQL 字段解析器

对于 Tutorial 中的复杂类型 author，我们需要字段解析器去解析它的值，`TutorialResolver` 实现了 `GraphQLResolver` 接口并实现 `getAuthor()` 方法

`resolver/TutorialResolver.java`

```java
package com.kba977.learngraphql.graphql.resolver;

import com.kba977.learngraphql.model.Author;
import com.kba977.learngraphql.model.Tutorial;
import com.kba977.learngraphql.service.AuthorService;
import graphql.kickstart.tools.GraphQLResolver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class TutorialResolver implements GraphQLResolver<Tutorial> {

    @Autowired
    private AuthorService authorService;

    public Author getAuthor(Tutorial tutorial) {
        return authorService.getById(tutorial.getAuthorId());
    }
}
```

如果客户端请求 `Tutorial` 没有带上 `author` 字段，那么 GraphQL Server 将不会调用该方法去解析字段

### 运行应用并检查结果

应用启动后，打开浏览器访问 `localhost:8083/graphiql`

```
fragment author on Author {
  id
  name
  age
}

query findAllAuthors {
  findAllAuthors {
    ...author
  }
}

query findAuthorById {
  findAuthorById(id: 3) {
    ...author
  }
}

query countAuthors {
  countAuthors 
}

fragment tutorial on Tutorial {
  id
  title
  description
  author {
    ...author
  }
}

query findAllTutorials {
  findAllTutorials {
    ...tutorial
  }
}

query countTutorials {
  countTutorials 
}

mutation createAuthor {
  createAuthor(createAuthorInput: {
    name: "kba999"
    age: 20 }) 
  {
    ...author
  }
}

mutation createTutorial {
  createTutorial(createTutorialInput: {
    title: "新概念英语"
    description: "学习英语的好资料"
    authorId: 2
  }) {
    ...tutorial
  }
}

mutation updateTutorial {
  updateTutorial(id: 4, updateTutorialInput: {
    title: "我们的世界"
  }) {
    ...tutorial
  }
}

mutation deleteTutorial {
  deleteTutorial(id: 1)
}
```

![image-20200426185338528](https://blog-1256977701.cos.ap-chengdu.myqcloud.com/SpringBoot_GraphQL_MySQL实现CRUD/运行结果.png)



### 进一步学习资源

- [GraphQL documentation](https://graphql.org/learn/)
- https://www.graphql-java.com/tutorials/getting-started-with-spring-boot/
- [graphql-java Github](https://github.com/graphql-java/graphql-java)

### 源代码

你可以从github上找到完整的代码：https://github.com/kba977/learn-graphql
