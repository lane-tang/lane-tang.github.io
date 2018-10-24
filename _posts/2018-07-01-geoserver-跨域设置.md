---
layout: post
title:  "geoserver 跨域设置"
date:   2018-07-01 09:56:00 +0800
categories:
- GIS
- Backend
comments: true
---
跨域问题是由浏览器考虑到自身安全机制而，设置的针对第三方服务器的访问限制。

## Enable CORS

The standalone distributions of GeoServer include the Jetty application server. Enable Cross-Origin Resource Sharing (CORS) to allow JavaScript applications outside of your own domain to use GeoServer.

For more information on what this does and other options see Jetty Documentation

Uncomment the following `<filter>` and `<filter-mapping>` from  `webapps/geoserver/WEB-INF/web.xml`:

```xml
<web-app>
    <filter>
        <filter-name>cross-origin</filter-name>
        <filter-class>org.eclipse.jetty.servlets.CrossOriginFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>cross-origin</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
</web-app>
```
