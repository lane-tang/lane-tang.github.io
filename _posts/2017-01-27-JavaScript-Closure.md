---
layout: post
title:  "JavaScript Closure"
date:   2017-01-27 10:08:00 +0800
categories:
- JavaScript
comments: true
---
> Closures are nothing but FUNCTIONS WITH PRESERVED DATA

## 一个非典型的 Closure
所谓的Closure（闭包），即是指一个函数使用的定义在函数外的变量。   
举一个非典型的例子：
```javascript
var outer = 3;

var addTwo = function() {
  var inner = 2;
  return outer + inner;
};

console.dir(addTwo);
```
以上代码在 Chrome 浏览器的运行结果如下：
![My helpful screenshot]({{ site.url }}/public/img/screenshot-from-2017-01-27.png)
可以看到，outer变量在这里以闭包的形式存在。  
这就是闭包最本质的意义。

## 一个更有趣的例子
再看另一个更有趣的例子：
```javascript
var addTo = function(passed) {
  var add = function(inner) {
    return passed + inner;
  };
  return add;
}
console.dir(addTo(2));
```
在这段代码中 `passed: 2` 同样以闭包的形式出现。   
在这个例子中使用闭包的优势在于通过传入不同参数，就可以构建新的不同函数：
```javascript
var addThree = new addTo(3);
var addFour = new addTo(4);

console.log(addThree(1))    //4
console.log(addFour(1))    //5
```
