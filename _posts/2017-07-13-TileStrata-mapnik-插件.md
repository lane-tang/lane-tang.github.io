---
layout: post
title:  "TileStrata Mapnik 插件"
date:   2017-07-13 20:51:00 +0800
categories:
- GIS
- TileStrata
comments: true
---
TileStrata-mapnik 插件使用 [maonik](http://mapnik.org/) 呈递切片，该插件使用最新版的 [node-mapnik](https://github.com/mapnik/node-mapnik)。

# 使用示例
```javascript
var mapnik = require('tilestrata-mapnik');

server.layer('mylayer')
    .route('tile.png').use(mapnik({
        pathname: '/path/to/map.xml',
        scale: 1,
        tileSize: 256
    });
```
TileStrata 的切片数据源以 `.xml` 格式文件定义。该文件同时配置了数据源的空间参考坐标系，输出的空间参考坐标系，以及图层的显示方式等相关信息。与 `.xml`文件路径一同传入的还有诸如切片放大级数、切片大小等配置信息。
```xml
<Map background-color="transparent"
  srs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs">
  <Style name="My Style">
    <Rule>
      <PolygonSymbolizer fill="#f2eff9" />
      <LineSymbolizer stroke="rgb(50%,50%,50%)" stroke-width="0.1" />
    </Rule>
  </Style>
  <Layer name="world" srs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs">
    <StyleName>My Style</StyleName>
    <Datasource>
      <Parameter name="file">../data/world_merc.shp</Parameter>
      <Parameter name="type">shape</Parameter>
    </Datasource>
  </Layer>
</Map>
```
数据源除了可以是 Shapefile，也可以来自PostGIS：

```xml
<Map background-color="transparent" srs="+init=epsg:3857">
  <Style name="My Style">
    <Rule>
      <PolygonSymbolizer fill="#0000ff" />
      <LineSymbolizer stroke="rgb(255,0,0)" stroke-width="0.5" />
    </Rule>
  </Style>
  <Layer name="world" srs="+init=epsg:4326">
    <StyleName>My Style</StyleName>
    <Datasource>
      <Parameter name="type">postgis</Parameter>
      <Parameter name="host">localhost</Parameter>
      <Parameter name="dbname">test</Parameter>
      <Parameter name="user">postgres</Parameter>
      <Parameter name="password">123456</Parameter>
      <Parameter name="table">(select geom, name from world_borders) as world</Parameter>
      <Parameter name="estimate_extent">false</Parameter>
      <Parameter name="extent">-180,-90,180,89.99</Parameter>
    </Datasource>
  </Layer>
</Map>
```
运行服务之后，在浏览器按对应
```
hostname:port/:layer/:z/:x:/:y/:filename
```
格式输入 `url` 即可获取对应切片信息。
![ScreenShot]({{ site.url }}/public/img/2017/07/13/14-18-31.png)

