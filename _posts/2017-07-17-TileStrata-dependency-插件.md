---
layout: post
title:  "TileStrata Dependency 插件"
date:   2017-07-17 21:18:00 +0800
categories:
- GIS
- TileStrata
comments: true
---
该插件用以将另一图层的切片作为资源引入，这在您打算以多种方式呈递结果的时候尤其适用。

# 应用示例
```javascript
// ...

strata.layer('basemap')
    .route('t.png')
        .use(disk.cache({
            dir: './cache/tiles/basemap',
            maxage: 0
        }))
        .use(mapnik({
            pathname: './world_population.xml',
            tileSize: 256,
            scale: 1
        }));

strata.layer('zoomedoutlayer')
    .route('t@2x.png')
        .use(disk.cache({
            dir: './cache/tiles/basemap',
            maxage: 0}))
        .use(mapnik({
            pathname: './world_population.xml',
            tileSize: 512,
            scale: 2
        }));

strata.layer('mylayer')
    .route('tile.png')
        .use(disk.cache({
            dir: './cache/tiles/basemap', 
            maxage: 0}))
        .use(dependency(function(req) {
            if (req.z < 5) {
                return ['zoomedoutlayer', 't@2x.png'];
            }
                return ['basemap', 't.png'];
        }));

// ...

```
在以上示例中，依赖 basemap 和 zoomedoutlayer 图层的 mylayer 图层，在放大级数小于5时，显示 zoomedoutlayer 图层的结果，在放大级数大于等于5时显示 basemap 图层的结果。

![ScreenShot]({{ base.siteurl }}/public/img/2017/07/17/18-16-28.png)

![ScreenShot]({{ base.siteurl }}/public/img/2017/07/17/18-16-54.png)
