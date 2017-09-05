---
layout: post
title:  "TileStrata Balancer"
date:   2017-07-25 11:48:00 +0800
categories:
- GIS
- TileStrata
comments: true
---
一个挂在多个 TileStrata 服务器前弹性的，可感知 [metatile](http://wiki.openstreetmap.org/wiki/Meta_tiles) 的负载均衡器。

# 具体使用
```bash
$ tilestrata-balancer \
	--hostname=127.0.0.1 \ # 绑定地址
	--port=8080 \ # 与外部的通信端口
	--private-port=8081 \ # 与 TileStrata 服务器的通信端口
	--check-interval=5000 \ # ping 子节点的时间间隔
	--unhealthy-count=1
```
在本地服务器端，需要使用 `balancer` 选项配置如何确定负载均衡器。TileStrata 服务器运行之后，它会首先向负载均衡器报道，告知自己已经准备好处理路由服务。之后，均衡器会间歇检查服务器的 `/health` 路由，确保其正常工作。
```javascript
// ...

var strata = tilestrata({
  balancer: {
    /* the port should match --private-port */
    host: '192.168.0.1:8081',
    /* the magnitude is relative to other servers (default: 1) */
    node_weight: 3
  }
});

// ...
```

如果使用 `metatiles`, 需要将 `metatile` 选项设置在 `layer` 层级，这样可以被均衡器识别到。
```javascript
strata.layer('mylayer', {metatile, 4})
	.use(mapnik({metatile: 4, /* ... */}))
// ...
```


# 实际运行结果
TileStrata Balancer:
```bash
tilestrata-balancer info Listening on 127.0.0.1:8081 (private)
tilestrata-balancer info Listening on 127.0.0.1:8080 (public)
tilestrata-balancer info pool Added 127.0.0.1:8082
tilestrata-balancer info pool Added 127.0.0.1:8083
...
```

TileStrata Server 1:
```bash
tilestrata info balancer Attempting to register with 127.0.0.1:8081...
tilestrata info balancer Successfully registered
...
```

TileStrata Server 2:
```bash
tilestrata info balancer Attempting to register with 127.0.0.1:8081...
tilestrata info balancer Successfully registered
...
```
![ScreenShot]({{ base.url }}/public/img/2017/07/25/11-32-08.png)
