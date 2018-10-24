---
layout: post
title:  "JavaScript callbacks"
date:   2017-02-04 13:15:00 +0800
categories:
- JavaScript
comments: true
---
Callback 函数在 JavaScript 编程中十分常见，这实际上也是由于 JavaScript 自身事件驱动和异步单线程的特性所决定的。所谓 callback ，本质上就是讲一个函数作为参数传入另一函数中，使该函数在某一特定情况下被执行。

## callback 基础

举一个简单的例子：

```javascript
const x = function() {
  console.log("I am called from inside a function");
}

const y = function(callback) {
  console.log('do something...');
  callback();
}

y(x);
```

在上面的例子中，`x`的函数体被传入到`y`中，并在y中被执行，这就是一个典型的 callback 函数使用。   

使用 callback 函数的优势之一，是增加代码的灵活性：

```javascript
const calc = function(num1, num2, calcType) {
  if(calcType === "add") {
    return num1 + num2;
  } else if (calcType === "multipy") {
    return num1 * num2;
  }
}

console.log(calc(2, 3, 'add'))    // 5
console.log(calc(2, 3, 'multipy'))    // 6
```

以上代码如果使用 callback 函数实现，就会灵活的多：

```javascript
const add = function(a, b) {
  return a + b;
}

const multipy = function(a, b) {
  return a * b;
}

const calc = function(num1, num2, callback) {
  return callback(num1, num2);
}

console.log(calc(2, 3, add));

const printNum = function(a, b) {
  console.log(`There are two numbers ${a} and ${b}`)
}

calc(2, 3, printNum);
```

这样不仅实现了原有的功能，callback 功能还可以由用户自由扩展。   

## 在 Node.js 中的使用
Node.js中会大量使用 callback 函数，原因是因为 JavaScript Non-blocking 的属性，当在进行 HTTP Reqest 或是访问数据库的时候，是异步进行的。这种情况下需要引入 callback 函数，作为完成某个事件后激发。  
以模拟访问数据库为例：

```javascript
function getUserFromDB(callback) {
  setTimeout(() => callback({
    firstName: 'Lane',
    lastName: 'Tang'
  }), 1000);
}

function greetUser() {
  getUserFromDB(function(userObject) {
    console.log('Hi' + userObject.firstName);
  });
}

greetUser()
```

----
callback 的大量使用有时也会使程序异常复杂。甚至可能出现 [callback hell](http://callbackhell.com/) ，为解决这种问题，开发人员在 JavaScript 中引入了 Promise 。
