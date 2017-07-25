---
layout: post
title:  "连接 Raspberry Pi 到 Bluemix IOT 服务"
date:   2017-03-20 14:37:00 +0800
categories:
- Raspberry pi
- Bluemix
comments: true
---
这篇文章简单的介绍了如何将 Raspberry Pi 连接到 IBM Bluemix 物联网服务器。

## 必要的软件包安装
这里可以首先考虑安装`wiringPi`，可以用以查看Raspberry Pi 的 GPIO 状态。（可选）
具体步骤如下：
```bash
$ git clone git://git.drogon.net/wiringPi # 从GitHub获取源代码
$ cd wiringPi
$ ./build # 编译安装源代码
$ gpio readall # 安装完成后就能查看 GPIO 端口了
```

要连接Raspberry Pi 到 IBM Bluemix 物联网服务器，首先需要安装 IOT 库：
```bash
$ curl -LO https://github.com/ibm-messaging/iot-raspberrypi/releases/download/1.0.2/iot_1.0-1_armhf.deb # 获取安装包
$ sudo dpkg -i iot_1.0-1_armhf.deb # 安装软件
$ service iot getdeviceid # 获取设备ID
The device ID is XXXXXXXXXXXXXXXX
...
```

之后需要登陆到 IBM Bluemix 平台，新建一个"Internet of Things"服务。  
选择 App 状态 `Leave Unbound`， 在 Service name 填写 `your-service-name`。  
在进入的服务界面中点击`Launch Dashboard`进入仪表盘。  
选择`Device`标签页，然后通过`Add Device`添加一个新设备。  
在输入设备的相关信息并点击 `Continue` 之后，会获得如下格式的配置文档：  
```
org=your_org_name
id=your_device_id
type=apikey
auth-key=your_auth_key
auth-token=your_auth_token
```
将以上内容添加到`/etc/iotsample-raspberrypi/device.cfg`文件中。

在终端下执行：
```bash
sudo service iot restart
```
重启 iot 服务。就能在 Dashboard 的 Device 标签页下获取来自 Raspberry Pi 的实时运行状态信息（CPU温度、内存占用 ...）。
