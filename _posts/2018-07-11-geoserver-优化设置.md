---
layout: post
title:  "Geoserver 优化配置"
date:   2018-07-11 10:56:00 +0800
categories:
- GIS
- Backend
comments: true
---
## Geoserver 支持的 JRE 版本
  - Java 8 - GeoServer 2.9.x and above (OpenJDK and Oracle JRE tested)
  - Java 7 - GeoServer 2.6.x to GeoServer 2.8.x (OpenJDK and Oracle JRE tested)
  - Java 6 - GeoServer 2.3.x to GeoServer 2.5.x (Oracle JRE tested)
  - Java 5 - GeoServer 2.2.x and earlier (Sun JRE tested)


## 使用 JAI 和 ImageIO 插件 [X]
  Install native JAI and ImageIO extensions [Docker Images]

  The Java Advanced Imaging API (JAI) is an advanced image processing library built by Oracle. GeoServer requires JAI to work with coverages and leverages it for WMS output generation. JAI performance is important for all raster processing, which is used heavily in both WMS and WCS to rescale, cut and reproject rasters.

  The Java Image I/O Technology (ImageIO) is used for raster reading and writing. ImageIO affects both WMS and WCS for reading raster data, and is very useful (even if there is no raster data involved) for WMS output as encoding is required when writing PNG/GIF/JPEG images.


## 针对容器的优化
### JAVA_OPT 设置 [O]
`jvm` 设置
  -Xms128m 初始内存设定
  -Xmx756M 最高内存
  -XX:SoftRefLRUPolicyMSPerMB=36000
  -XX:+UseParallelGC
  --XX:+UseParNewGC
  –XX:+UseG1GC

### Enable the Marlin rasterizer [X]
`jvm` 设置
  -Xbootclasspath/a:$MARLIN_JAR
  -Dsun.java2d.renderer=org.marlin.pisces.MarlinRenderingEngine


## 针对配置的优化
### Set a service strategy [O]
modifying the `web.xml` file of your GeoServer instance.
---
geoserver/src/web/app/src/main/webapp/WEB-INF/web.xml
---

| Strategy       | Description    |
| :------------- | :------------- |
| SPEED          | Serves output right away. This is the fastest strategy, but proper OGC errors are usually omitted. |
| BUFFER         | 	Stores the whole result in memory, and then serves it after the output is complete. This ensures proper OGC error reporting, but delays the response quite a bit and can exhaust memory if the response is large. |
| FILE           | Similar to BUFFER, but stores the whole result in a file instead of in memory. Slower than BUFFER, but ensures there won’t be memory issues. |
| PARTIAL-BUFFER | A balance between BUFFER and SPEED, this strategy tries to buffer in memory a few KB of response, then serves the full output. |

### Configure service limits [O]
  - Set the maximum amount of features returned by each WFS GetFeature request (this can also be set on a per featuretype basis by modifying the info.xml files directly)
  - Set the WMS request limits so that no request will consume too much memory or too much time

### Cache your data


## 针对数据的优化
### Use an external data directory

### Use a spatial database

### Pick the best performing coverage formats
#### Choose the right format
designed for data exchange: Examples of such formats are GeoTiff, ECW, JPEG 2000 and MrSid.
for data rendering and serving: ArcGrid.

#### Setup Geotiff data for fast rendering
  - inner tiling
  - overviews

#### Handling huge data sets
ImagePyramid plugin
