---
layout: post
title:  "TileStrata Disk 插件"
date:   2017-07-15 21:04:00 +0800
categories:
- GIS
- TileStrata
comments: true
---
TileStrata Disk 是一个从磁盘存储/检索切片的 TileStrata 插件。它既可以用以缓存切片数据，也可作提供切片数据。在用它来缓存数据时，请确保为每个图层设置不同的目录（比如："tiles/layer_a", "tiles/layer_b"）。如果提供 `maxage` 参数，它将检查切片的最近一次修改时间，如果间隔过长，将返回 `null`。如果 `maxage = 0` 切片缓存就被彻底取消。

# 使用示例
一般情况下，只需要指定切片文件的缓存路径,这种情况下 `maxage` 默认设置为 `null`：
```javascript
var disk = require('tilestrata-disk');

// cache: cache tiles to disk
server.layer('mylayer').route('tile.png')
    .use(/* some provider */)
    .use(disk.cache({dir: './tiles/mylayer'}));

// ...
```

当对切片文件缓存时间有要求是，可以指定缓存时间，单位是‘秒’：
```javascript
var disk = require('tilestrata-disk');

// cache: cache with maxage
server.layer('mylayer').route('tile.png')
    .use(/* some provider */)
    .use(disk.cache({maxage: 3600, dir: './tiles/mylayer'}));

// ...
```

不仅如此，还可以对不同放大层级设置不同缓存时间：
```javascript
var disk = require('tilestrata-disk');

// cache: cache with maxage function (advanced)
server.layer('mylayer').route('tile.png')
    .use(/* some provider */)
    .use(disk.cache({
        dir: './tiles/mylayer',
        maxage: function(server, req) {
            if (req.x > 5) return 0; // don't cache
            if (req.y > 6) return 0; // don't cache
            if (req.z > 7) return 0; // don't cache
            return 3600*24;
        }
    }));

// ...
```
可以发现，在以上代码设定范围内的切片均没有在文件系统中缓存：
![ScreenShot]({{ site.url }}/public/img/2017/07/15/16-04-12.png)

使用者可以自定义缓存文件路径：
```javascript
var disk = require('tilestrata-disk');

// cache: custom directory layout
server.layer('mylayer').route('tile.png')
    .use(/* some provider */)
    .use(disk.cache({path: './tiles/{layer}/{z}/{x}/{y}-{filename}'}));

// ...
```

也可以使用 callback 配置文件路径：
```javascript
var disk = require('tilestrata-disk');

// cache: custom directory layout (via callback)
server.layer('mylayer').route('tile.png')
    .use(/* some provider */)
    .use(disk.cache({path: function(tile) {
        return './tiles/' + tile.layer + '/' + tile.z + '/' /* ... */
    }}));

// ...
```

使用 Disk 插件作为静态切片文件的提供者：
```javascript
var disk = require('tilestrata-disk');

// provider: serve pre-existing / pre-sliced tiles off disk
server.layer('mylayer').route('tile.png')
    .use(disk.provider('/path/to/dir/{z}/{x}/{y}/file.png'));

// ...
```
这种情况下，用户只能请求保存在文件系统中静态的切片数据，服务器不会生成任何新的切片。

# 高级使用
如果使用 TileStrata 0.6.0 及以上版本，你可以指定 `refreshage`， 这个参数规定切片数据在 TileStrata 刷新它之前最多能存活多长时间。这个参数需要和 `maxage` 一同使用：
```javascript
.use(disk.cache({
    dir: './tiles/mylayer',
    refreshage: 3600, // 1 hour
    maxage: 3600*24*7 // 1 week
}));

// ...
```
在当前配置下，如果某一切片缓存存在已有两天时间，服务器在提供旧的切片同时，会告诉 TileStrata 为下一位请求的用户在后台生成一张新的切片。



