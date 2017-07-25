---
layout: post
title:  "First look of TileStrata"
date:   2017-07-11 20:49:00 +0800
categories:
- GIS
- TileStrata
comments: true
---

> TileStrata is a pluggable "slippy map" tile server that emphasizes code-as-configuration. The primary goal is painless extendability. It's clean, highly tested, performant, and integrates seamlessly with an elastic load balancer designed specifically for tile serving: [TileStrata Balancer](https://github.com/naturalatlas/tilestrata-balancer). 

# 简介
TileStrata 主要有5种类型的插件组成，分别是：
- "provider" 用于提供新的地图切片，如：mapnik
- "cache" 缓存切片数据以备后续访问
- "transform" 将生成的切片进行一定的处理
- "request hook" 在切片数据被请求访问时进行相应操作
- "response hook" 在切片数据被访问之后进行相应操作
![]()

### 插件列表
- [tilestrata-mapnik](https://github.com/naturalatlas/tilestrata-mapnik) 使用 [mapnik](http://mapnik.org/) 从指定数据源生地图切片
- [tilestrata-disk](https://github.com/naturalatlas/tilestrata-disk) 将切片缓存到文件系统，并在需要的时候提供文件访问
- [tilestrata-dependency](https://github.com/naturalatlas/tilestrata-dependency) 从其他层级获取切片
- [tilestrata-sharp](https://github.com/naturalatlas/tilestrata-sharp) 使用 [libvips](https://www.npmjs.com/package/sharp) 压缩、重新调整大小、或者转换文件格式。支持`jpg`,`png`,`webp`
- [tilestrata-gm](https://github.com/naturalatlas/tilestrata-gm) 使用 [Graphics Magick](https://www.npmjs.com/package/gm) 对切片进行各种图像操作
- [tilestrata-headers](https://github.com/naturalatlas/tilestrata-headers) 设置/重置 Response Headers
- [tilestrata-blend](https://github.com/naturalatlas/tilestrata-blend) 将多层切片堆叠在一起
- [tilestrata-jsonp](https://github.com/naturalatlas/tilestrata-jsonp) 将 `utfgrids` 或者其他 JSON 作为 JSONP 提供服务
- [tilestrata-datadog](https://github.com/naturalatlas/tilestrata-datadog) 将时间数据提供给 [Datadog](https://www.datadoghq.com/)
- [tilestrata-utfmerge](https://github.com/naturalatlas/tilestrata-utfmerge) 将 UTF 互动网格并入到 `mapnik`
- [tilestrata-vtile](https://github.com/naturalatlas/tilestrata-vtile) 输出适量切片
- [tilestrata-vtile-raster](https://github.com/naturalatlas/tilestrata-vtile-raster) 将矢量切片转换成栅格图片
- [tilestrata-vtile-composite](https://github.com/naturalatlas/tilestrata-vtile-composite) 合并多个矢量切片
- [tilestrata-proxy](https://github.com/naturalatlas/tilestrata-proxy) 从其他服务器获取栅格数据
- [tilestrata-lru](https://github.com/naturalatlas/tilestrata-lru) 将栅格数据缓存到内存中
- [tilestrata-etag](https://github.com/naturalatlas/tilestrata-etag) 
- [tilestrata-bing](https://github.com/naturalatlas/tilestrata-bing) 提供 Bing 地图切片
- [tilestrata-underzoom](https://github.com/naturalatlas/tilestrata-underzoom) 为高放大层级制造马赛克效果
- [tilestrata-postgismvt](https://github.com/Stezii/tilestrata-postgismvt) 从 PostGIS 数据库中输出 Mapbox 矢量数据
- [tilestrata-postgis-geojson-tiles](https://github.com/naturalatlas/tilestrata-postgis-geojson-tiles) 从 PostGIS 数据库中输出 GeoJSON 切片

# 配置
```javascript
var tilestrata = require('tilestrata');
var disk = require('tilestrata-disk');
var mapnik = require('tilestrata-mapnik');
var strata = tilestrata();

// 定义图层
strata.layer('basemap')
  .route('tile.png')
    .use(disk.cache({dir: './tiles/srtm/', maxage: 0}))
    .use(mapnik({
        pathname: './test/stylesheet.xml',
        tileSize: 512,
        scale: 1
    }));

// start accepting requests
strata.listen(8080);
```
一旦配置完毕，切片可以通过以下地址访问：  
`/:layer/:z/:x/:y/:filename`  
在上面的例子中 `layer` 为 `basemap` ， `filename` 为 `tile.png` 。 `z` 为放大层级， `x` , `y` 均为该层级下的坐标。

### 与 Express / Connect 兼容
TileStrata 提供 Express 的中间件支持，因此可以在 Express 应用中轻松使用而不必在 `strata` 上执行 `listen`
```javascript
var tilestrata = require('tilestrata');
var strata = tilestrata();
strata.layer('basemap') /* ... */
strata.layer('contours') /* ... */

app.use(tilestrata.middleware({
    server: strata,
    prefix: '/maps'
}));
```

# 使用注意
## Metatile 的负载均衡 & 图层共享
TileStrata 2.0 及以上的版本中加入了 [TileStrata Balancer](https://github.com/naturalatlas/tilestrata-balancer) 的支持，一个特别针对 `metatiles` 这样精细的切片服务而设计的弹性负载均衡机制。一般意义上的负载均衡并不会意识到 `metatiles` 的存在，因此只会机械的将对切片的访问请求分配到多个服务器，这样就导致了冗余的投递过程，无疑会浪费计算效能。  
作为新加入的福利，均衡器并设定并非所有图层在每个服务器中均可访问。均衡器会追踪每个 Node 进程的图层提供者，因此他知道每一条路由。  
TileStrata 的负载均衡具有一下特点：
- **灵活性:**  设置简单
- **连贯的路由:**  提升本地缓存的效率
- **了解Metatile:**  防止冗余投递
- **了解图层:**  允许多个图层杂糅在一起

## 重建切片缓存
如果你更新地图样式或数据，你可能需要更新切片。与其一次性将所有切片数据全部扔掉，然后再让服务器重新生成一次，不如设置 `X-TileStrata-SkipCache`
仅重建划定的切片范围。[TileMantle](https://github.com/naturalatlas/tilemantle)让这个过程十分简单：
```bash
npm install -g tilemantle
tilemantle http://myhost.com/mylayer/{z}/{x}/{y}/t.png \
    -p 44.9457507,-109.5939822 -b 30mi -z 10-14 \
    -H "X-TileStrata-SkipCache:mylayer/t.png"
```
为了 [tilestrata-dependency](https://github.com/naturalatlas/tilestrata-dependency) 插件，`header` 的值被规定为一下格式：
```bash
X-TileStrata-SkipCache:*
X-TileStrata-SkipCache:[layer]/[file],[layer]/[file],...
```
在更高级的应用场景中，可能需要切片在图片缓存实际写入文件系统之前不要从服务器返回请求。为达到这样的效果,需要设定：
```bash
X-TileStrata-CacheWait:1
```

## 健康检查
TileStrara 包含一个 `/health` 节点，当服务器能接受访问时，返回状态 `200 OK` 。返回的数据格式始终是 JSON 。通过在 callback 函数中设置 `healthy` 选项可以进一步配置状态和返回的数据。
```javascript
// not healthy
var strata = tilestrata({
	healthy: function(callback) {
	    callback(new Error('CPU is too high'), {loadavg: 3});
	}
});

// healthy
var strata = tilestrata({
	healthy: function(callback) {
	    callback(null, {loadavg: 1});
	}
});
```


















