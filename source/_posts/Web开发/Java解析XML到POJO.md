---
title: Java解析XML到POJO
tags:
  - Java
  - Spring
categories:
  - Web开发
date: 2018-03-14 20:49:49
---


首先是我们的 XML 文件
``` xml
<?xml version="1.0" encoding="UTF-8" ?>
<c c1="0">
    <d d1="101280101" d2="广州" d3="guangzhou" d4="广东"/>
    <d d1="101280102" d2="番禺" d3="panyu" d4="广东"/>
    <d d1="101280103" d2="从化" d3="conghua" d4="广东"/>
    <d d1="101280104" d2="增城" d3="zengcheng" d4="广东"/>
    <d d1="101280105" d2="花都" d3="huadu" d4="广东"/>
    <d d1="101280201" d2="韶关" d3="shaoguan" d4="广东"/>
    <d d1="101280202" d2="乳源" d3="ruyuan" d4="广东"/>
    <d d1="101280203" d2="始兴" d3="shixing" d4="广东"/>
    <d d1="101280204" d2="翁源" d3="wengyuan" d4="广东"/>
    <d d1="101280205" d2="乐昌" d3="lechang" d4="广东"/>
    <d d1="101280206" d2="仁化" d3="renhua" d4="广东"/>
    <d d1="101280207" d2="南雄" d3="nanxiong" d4="广东"/>
    <d d1="101280208" d2="新丰" d3="xinfeng" d4="广东"/>
    <d d1="101280209" d2="曲江" d3="qujiang" d4="广东"/>
    <d d1="101280210" d2="浈江" d3="chengjiang" d4="广东"/>
    <d d1="101280211" d2="武江" d3="wujiang" d4="广东"/>
    <d d1="101280301" d2="惠州" d3="huizhou" d4="广东"/>
    <d d1="101280302" d2="博罗" d3="boluo" d4="广东"/>
    <d d1="101280303" d2="惠阳" d3="huiyang" d4="广东"/>
    <d d1="101280304" d2="惠东" d3="huidong" d4="广东"/>
    <d d1="101280305" d2="龙门" d3="longmen" d4="广东"/>
</c>
```

<!-- more -->

定义 VO 对象

``` java City.java
@Data
@XmlRootElement(name = "d")
@XmlAccessorType(XmlAccessType.FIELD)
public class City {

    @XmlAttribute(name = "d1")
    private String cityId;

    @XmlAttribute(name = "d2")
    private String cityName;

    @XmlAttribute(name = "d3")
    private String cityCode;

    @XmlAttribute(name = "d4")
    private String province;
}
```

``` java CityList.java
@Data
@XmlRootElement(name = "c")
@XmlAccessorType(XmlAccessType.FIELD)
public class CityList {

    @XmlElement(name = "d")
    private List<City> cityList;
}
```

XML 转 POJO 的工具类
``` java XmlBuilder.java
public class XmlBuilder {

    /**
     * 将 XML 转为指定的 POJO
     * @param clazz
     * @param xmlStr
     * @return
     * @throws Exception
     */
    public static Object xmlStrToObject(Class<?> clazz, String xmlStr) throws Exception {
        Object xmlObject = null;
        Reader reader = null;
        JAXBContext context = JAXBContext.newInstance(clazz);

        // XML 转为对象的接口
        Unmarshaller unmarshaller = context.createUnmarshaller();

        reader = new StringReader(xmlStr);
        xmlObject = unmarshaller.unmarshal(reader);

        if (reader != null) {
            reader.close();
        }

        return xmlObject;
    }
}
```

Service 接口与实现
``` java CityDataService.java
public interface CityDataService {

    /**
     * 获取城市列表
     * @return
     * @throws Exception
     */
    List<City> listCity() throws Exception;
}
```

``` java CityDataServiceImpl.java
public class CityDataServiceImpl implements CityDataService {

    public List<City> listCity() throws Exception {

        // 读取 XML 文件
        Resource resource = new ClassPathResource("citylist.xml");
        BufferedReader br = new BufferedReader(new InputStreamReader(resource.getInputStream(), "utf-8"));
        StringBuffer buffer = new StringBuffer();
        String line = "";

        while ((line = br.readLine()) != null) {
            buffer.append(line);
        }

        br.close();

        // XML 转为 Java 对象
        CityList cityList = (CityList) XmlBuilder.xmlStrToObject(CityList.class, buffer.toString());
        return cityList.getCityList();
    }
}

```
