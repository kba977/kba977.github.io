---
title: SpringBoot学习笔记
tags:
  - Java
  - Spring
categories:
  - Web开发
date: 2018-01-06 21:08:24
---


<blockquote class="blockquote-center">
学习了[慕课网](http://www.imooc.com) 上有关 springboot 的知识, 为了达到不让自己忘记, 且总结知识的目的, 遂写了此篇博客总结。
下面废话不多说, 让我们开始吧。
</blockquote>

## Spring Boot

### 一、启动

#### 第一种方式

  ``` bash
  mvn spring-boot:run clean
  ```

#### 第二种方式

  ``` bash
  mvn install
  java -jar target/girl-0.0.1-SNAPSHOT.jar
  ```

<!-- more -->

### 二、配置

#### 第一种方式
  在配置文件 `application.yml` 中添加变量 `cupSize: B`
  java 中通过 `@Value` 注解获取自定义变量的值, 例子如下：

  -  `application.yml`

      ``` yaml
      cupSize: B
      age: 18
      content: "cupSize: ${cupSize}, age: ${age}"      # 配置中使用当前配置量
      ```

  -  `HelloController.java`

      ``` java
      @Value("${cupSize}")
      private String cupSize;

      @Value("${age}")
      private Integer age;

      @Value("${content}")
      private String content;
      ```

#### 第二种方式

  ​ 当变量很多的时候，可以安置一个前缀，具体如下

  - `application.yml`

    ``` yaml
    girl:
      cupSize: B
      age: 18
    ```

  - `GirlProperties.java`

    通过 `@Component` 和 `@ConfigurationProperties` 两个注解完成

    ``` java
    @Component
    @ConfigurationProperties(prefix = "girl")
    public class GirlProperties {
        private String cupSize;
        private Integer age;

        // getter and setter
    }
    ```

  - `HelloController.java` 

    通过 `@Autowired` 注解来注入 `GirlProperties` 属性值 

    ``` java
    @Autowired
    private GirlProperties girlProperties;

    @GetMapping(value = "/hello")
    public String hello() {
      return girlProperties.getCupSize();
    }
    ```

#### 多环境配置

  `application.yml`,  `application-dev.yml`,  `application-prod.yml` 分别是主配置文件, 开发配置文件和生产配置文件, 通过 `主配置文件` 可以觉得程序运行时使用哪个配置文件

  指定配置启动

  ``` bash
  java -jar target/girl-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
  ```

  - `application.yml`

    ``` yaml
    spring:
      profiles:
        active: dev
    ```

  - `application-dev.yml`

    ``` yaml
    server:
      port: 8081
      context-path: /girl
      
    girl:
      cupSize: F
      age: 18
    ```

  - `application-prod.yml`

    ``` yaml
    server:
      port: 8080
      context-path: /girl

    girl:
      cupSize: B
      age: 18
    ```


### 三、Controller 的使用

ps: 在做 `put` 操作时，RequstBody 格式必须为 `x-www-form-urlencoded` 而不能为 `form-data` 或者其他。    

| **@PathVariable** | **获取Url中的数据**  |
| ----------------- | -------------------|
| **@RequestParam** | **获取请求参数的值**  |
| **@GetMapping**   | **组合注解**         |

- PathVariable

  ``` java
  // Url: eg: http://localhost:8080/girl/say/17
  @GetMapping(value = "/say/{id}")
  public String say(@PathVariable("id") Integer Id) {
      return girlProperties.getCupSize() + " Id:" + Id;
  }
  ```

- RequestParam

  ``` java
  // Url: eg: http://localhost:8080/girl/say?id=17
  @GetMapping(value = "/say")
  public String say(@RequestParam(value = "id", required = false, defaultValue = "0") Integer id) {
      return girlProperties.getCupSize() + " Id:" + id;
  }
  ```

### 四、事务

使用 `@Transactional` 可以为数据库操作加上事务， 示例如下：

``` java
import org.springframework.transaction.annotation.Transactional;

@Transactional
public void insertTwo() {
    Girl girlA = new Girl();
    girlA.setCupSize("A");
    girlA.setAge(18);
    girlRepository.save(girlA);

    Girl girlB = new Girl();
    girlB.setCupSize("B");
    girlB.setAge(19);
    girlRepository.save(girlB);
}
```

### 五、表单验证

1. 首先在对象属性上加上注解，例如：最小值

   ``` java
   @Min(value = 18, message = "未成年少女禁止入内")
   private Integer age;
   ```

2. 在控制层函数参数中加入 `@Valid` 注解。如果表单验证未通过，那么错误信息会在 `bindingResult` 这个对象中，示例如下：

   ``` java
   @PostMapping("/girls")
   public Girl girlAdd(@Valid Girl girl, BindingResult bindingResult) {

       if (bindingResult.hasErrors()) {
           System.out.println(bindingResult.getFieldError().getDefaultMessage());
           return null;
       }

       girl.setCupSize(girl.getCupSize());
       girl.setAge(girl.getAge());

       return girlRepository.save(girl);
   }
   ```

   当新增少女年龄在18岁以下时，在控制台会输出 `未成年少女禁止入内`， 并创建失败。

### 六、使用 AOP 统一处理请求日志

- 添加依赖 `pom.xml`

   ``` xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-aop</artifactId>
   </dependency>
   ```

- `@Before` 

  方法到来前拦截，其中`"execution(public * com.kba977.girl.controller.GirlController.*(..))"` 的 `.*(..)` 表示 `GirlController` 类下不论什么方法，不论什么参数，全都拦截

  ```java
  package com.kba977.girl.aspect;

  import org.aspectj.lang.annotation.Aspect;
  import org.aspectj.lang.annotation.Before;
  import org.springframework.stereotype.Component;

  @Aspect
  @Component
  public class HttpAspect {

      @Before("execution(public * com.kba977.girl.controller.GirlController.*(..))")
      public void log() {
          System.out.println(1111111);
      }
  }
  ```

- `@After`

  和 `@Before`正好相反，在方法执行之后，开始执行。

- `@Pointcut` 

  通过该注解，可以减少重复代码，如下：

  ```java
  @Aspect
  @Component
  @Slf4j
  public class HttpAspect {

      @Pointcut("execution(public * com.kba977.girl.controller.GirlController.*(..))")
      public void log() {
      }

      @Before("log()")
      public void doBefore(JoinPoint joinPoint) {
          log.info("222222222222");
      }

      @After("log()")
      public void doAfter() {
          log.info("222222222222");
      }
  }
  ```

- `@AfterReturning`

  获取请求之后返回的信息

  ``` java
  @AfterReturning(returning = "object", pointcut = "log()")
  public void doAfterReturning(Object object) {
      log.info("response = {}", object);
  }
  ```

- 获取请求信息

  ``` java
  @Before("log()")
  public void doBefore(JoinPoint joinPoint) {

      ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
      HttpServletRequest request = attributes.getRequest();

      // url
      log.info("url = {}", request.getRequestURL());

      // method
      log.info("method = {}", request.getMethod());

      // ip
      log.info("ip = {}", request.getRemoteAddr());

      // 类方法
      log.info("class_method = {}", joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName());

      // 参数
      log.info("args = {}", joinPoint.getArgs());
  }
  ```

### 七、统一异常处理

​  例如： 获取某女生的年龄并判断
​  小于10，返回 “应该还在上小学”
​  大于10且小于16，返回 “可能在上初中”

​  返回格式的统一
``` json
// 请求失败时
{
    "code": 1,
    "msg": "金额必传",
    "data": null
}

// 请求成功时
{
    "code": 0,
    "msg": "成功", 
    "data": {
        "id": 20, 
        "cupSize": "B",
        "age": 25,
        "money": 1.2
    }
}
```

Result 类

``` java
/**
 * http 请求返回的最外层对象
 */

@Data
public class Result<T> {
    /** 错误码 **/
    private Integer code;

    /** 提示信息 **/
    private String msg;

    /** 具体内容 **/
    private T data;
}
```

```java
@PostMapping("/girls")
public Result<Girl> girlAdd(@Valid Girl girl, BindingResult bindingResult) {

    if (bindingResult.hasErrors()) {

        Result result = new Result();
        result.setCode(1);
        result.setMsg(bindingResult.getFieldError().getDefaultMessage());
        return result;
    }

    girl.setCupSize(girl.getCupSize());
    girl.setAge(girl.getAge());


    Result result = new Result();
    result.setCode(0);
    result.setMsg("成功");
    result.setData(girlRepository.save(girl));
    return result;
}
```

或者 

```java
@PostMapping("/girls")
public Result<Girl> girlAdd(@Valid Girl girl, BindingResult bindingResult) {

    if (bindingResult.hasErrors()) {
        return ResultUtil.error(1, bindingResult.getFieldError().getDefaultMessage())
    }

    girl.setCupSize(girl.getCupSize());
    girl.setAge(girl.getAge());
    return ResultUtil.success(girlRepository.save(girl));
}
```

#### 捕获异常

  ``` java 
  @ControllerAdvice
  public class ExceptionHandle {

      @ExceptionHandler(value = Exception.class)
      @ResponseBody
      public Result handle(Exception e) {
          return ResultUtil.error(100, e.getMessage());
      }
  }
  ```

#### 自定义异常

  解决啦上述捕获异常时，code 单一的问题

  ``` java
  @Getter
  public enum ResultEnum {

      UNKNOWN_ERROR(-1, "未知错误"),
      SUCCESS(0, "成功"),
      PRIMARY_SCHOOL(100, "你可能还在上小学吧"),
      MIDDLE_SCHOOL(101, "你可能还在上初中吧"),
      ;

      private Integer code;

      private String msg;

      ResultEnum(Integer code, String msg) {
          this.code = code;
          this.msg = msg;
      }
  }
  ```

  ``` java
  @Data
  public class GirlException extends RuntimeException {

      private Integer code;

      public GirlException(ResultEnum resultEnum) {
          super(resultEnum.getMsg());
          this.code = resultEnum.getCode();
      }
  }
  ```

  ``` java
  @Slf4j
  @ControllerAdvice
  public class ExceptionHandle {

      @ExceptionHandler(value = Exception.class)
      @ResponseBody
      public Result handle(Exception e) {
          if (e instanceof GirlException) {
              GirlException girlException = (GirlException) e;
              return ResultUtil.error(girlException.getCode(), girlException.getMessage());
          } else {
              log.error("【系统异常】{}", e);
              return ResultUtil.error(-1, "未知错误");
          }
      }
  }
  ```

  ```java
  public void getAge(Integer id) throws Exception {
      Girl girl = girlRepository.findOne(id);
      Integer age = girl.getAge();
      if (age < 8) {
          // 返回 "你可能还在上小学吧" code = 100
          throw new GirlException(ResultEnum.PRIMARY_SCHOOL);
      } else if (age > 8 && age < 18) {
          // 返回 "你可能还在上初中吧" code = 101
          throw new GirlException(ResultEnum.MIDDLE_SCHOOL);
      }

      // 加钱
  }
  ```

### 八、单元测试

#### 测试 Service

  ```Java
  @RunWith(SpringRunner.class)
  @SpringBootTest
  public class GirlServiceTest {

      @Autowired
      private GirlService girlService;

      @Test
      public void findOne() throws Exception {
          Girl girl = girlService.findOne(1);
  //        assertNotNull(girl);
          assertEquals(girl.getAge(), new Integer(18));
      }
  }
  ```

#### 测试 API

  ```java
  @RunWith(SpringRunner.class)
  @SpringBootTest
  @AutoConfigureMockMvc
  public class GirlControllerTest {

      @Autowired
      private MockMvc mvc;

      @Test
      public void girlList() throws Exception {
          mvc.perform(MockMvcRequestBuilders.get("/girls"))
                  .andExpect(MockMvcResultMatchers.status().isOk());
  //                .andExpect(MockMvcResultMatchers.content().string("abc"));
      }
  }
  ```

#### 其他

  `mvn clean package -Dmaven.test.skip=true` maven 打包的时候跳过单元测试

### XXX、其他工具类

#### ResultUtil

  ``` java
  public class ResultUtil {

      public static Result success(Object object) {
          Result result = new Result();
          result.setCode(0);
          result.setMsg("成功");
          result.setData(object);
          return result;
      }

      public static Result success() {
          return success(null);
      }

      public static Result error(Integer code, String msg) {
          Result result = new Result();
          result.setCode(code);
          result.setMsg(msg);
          return result;
      }
  }
  ```