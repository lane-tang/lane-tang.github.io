---
layout: post
title:  "通过命令行设置 Raspberry Pi 无线上网"
date:   2017-02-14 14:37:00 +0800
categories:
- Raspberry pi
- Translate
comments: true
---
如果您无法通过访问图形用户界面在Raspberry Pi上设置WiFi，则可以使用此方法。特别适用于控制台，如果您无法访问屏幕或有线以太网。还要注意的是，不需要额外的软件；您所需要的一切都已经包含在Raspberry Pi中。

## 获取无线网络详细信息

要扫描WiFi网络，请使用命令`sudo iwlist wlan0 scan`。这将列出所有可用的WiFi网络，以及其他有用的信息。注意这里：

`ESSID："test"`是WiFi网络的名称。

`IE：IEEE 802.11i / WPA2 Version 1`是使用的认证。在这种情况下，WPA2是WPA更新和更安全的无线标准。本指南应适用于`WPA`或`WPA2`，但可能对`WPA2`企业版无效。对于`WEP`十六进制键，请参阅这里的最后一个例子。您还需要无线网络的密码。对于大多数家庭路由器，能在路由器背面的贴纸上找到。在这个例子中，网络的`ESSID（ssid）`是`testing`，密码`（psk）`是`testsPassword`。

您可以使用wpa_passphrase生成PSK并输入。通过上面的例子，调用的命令将是 `wpa_passphrase“testing”`，这将要求您输入密码，并输出一个可用的wpa-兼容的网络配置文件：

```text
network={
    ssid="testing"
    #psk="testingPassword"
    psk=131e1e221f6e06e3911a2d11ff2fac9182665c004de85300f9cac208a6a80531
}
```

该工具需要8到63个字符的密码。将生成的配置文件粘贴到你的配置文件中。对于更复杂的密码短语，您还可以提取文本文件的内容，并将其用作wpa_passphrase的输入，如果密码存储在纯文本中，则可以通过调用`wpa_passphrase "test" < 存储密码的文件`。之后你应该删除存储有密码的文件。

## 将网络详细信息添加到Raspberry Pi

在nano中打开的`wpa-supplicant`配置文件：

```bash
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

转到文件的底部并添加以下内容：

```text
network={
    ssid="The_ESSID_from_earlier"
    psk="Your_wifi_password"
}
```

请注意，尽管`wpa_passphrase`返回未使用引号的psk值，但`wpa_supplicant.conf`文件需要引用该值，否则您的Pi将无法连接到您的网络。

在示例网络的情况下，我们将输入：

```text
network={
    ssid="testing"
    psk="testingPassword"
}
```

如果使用`wpa_passphrase`，可以通过调用`wpa_passphrase "testing" "testPassword">> /etc/wpa_supplicant/wpa_supplicant.conf`将其输出重定向到您的配置文件中。请注意，这需要您在root用户下操作（通过执行sudo su），或者您可以使用`wpa_passphrase "testing" "testingPassword” | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null`，这样不必更改为root用户也能添加密码。这两种方法都需提供必要的管理权限来更改文件。最后，请确保您使用`>>`，或使用`-a`与`tee`（两者都可以用于将文本附加到现有文件），因为使用`>`或省略`-a`在时，都将擦除原来的所有内容，然后将输出附加到指定的文件。请注意，在第二个表单结尾处重定向到`/dev/null`只是阻止结果输出到屏幕（标准输出）。

现在按`Ctrl + X`，然后按`Y`保存文件，最后按`Enter`键。

在种情况下，`wpa-supplicant`通常会在几秒钟内发生变化，并尝试连接到无线网络。如果没有，请使用`sudo wpa_cli reconfigure`重新启动界面。

您可以使用`ifconfig wlan0`验证是否已成功连接。如果`inet addr`字段旁边有地址，则Raspberry Pi已连接到网络。如果没有，请检查您的密码和ESSID是否正确。

## 不必要的网络

如果要连接的网络不使用密码，则网络的`wpa_supplicant`将需要包含正确的`key_mgmt`。例如:

```text
network={
    ssid="testing"
    key_mgmt=NONE
}
```

## 隐藏网络

如果您使用隐藏的网络，`wpa_supplicant`文件`scan_ssid`中的额外选项可能有助于连接。

```text
network={
    ssid="yourHiddenSSID"
    scan_ssid=1
    psk="Your_wifi_password"
}
```

您可以使用`ifconfig wlan0`验证是否已成功连接。如果`inet addr`字段旁边有地址，则Raspberry Pi已连接到网络。如果没有，请检查您的密码和ESSID是否正确。

# 添加多个无线网络配置

在最新版本的Raspbian上，可以为无线网络设置多个无线网络记录。例如，您可以设置一个用于家庭，一个用于学校。

例如：

```text
network={
    ssid="SchoolNetworkSSID"
    psk="passwordSchool"
    id_str="school"
}

network={
    ssid="HomeNetworkSSID"
    psk="passwordHome"
    id_str="home"
}
```

如果您有两个范围内的网络，您可以添加优先级以在它们之间进行选择。具有最高优先级的范围内的网络将优先连接。

```text
network={
    ssid="HomeOneSSID"
    psk="passwordOne"
    priority=1
    id_str="homeOne"
}

network={
    ssid="HomeTwoSSID"
    psk="passwordTwo"
    priority=2
    id_str="homeTwo"
}
```

---
原文地址：https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md