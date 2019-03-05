---
layout: post
title:  "Raspberry Pi 入手设置"
date:   2017-02-11 10:21:00 +0800
categories:
- Raspberry pi
- Hardware
comments: true
---
因为要做毕业设计的原因，入手了树莓派3B。这里先简单介绍一下入手后的配置。

## Raspbain 系统的安装

首先需要准备一张16G的 SD 卡，在[树莓派官网](https://www.raspberrypi.org/downloads/raspbian/)下载 Raspbain 系统镜像。  

Linux 用户可以使用`dd`命令将镜像写入SD卡（ 注意命令行中的 `sdX` 是指 SD 卡所在的分区。关于 SD 卡所在的分区可以用 `df -h` 或是 `sudo fdisk -l` 查看得到。 ）：

```bash
dd bs=4M if=2017-04-10-raspbian-jessie.img of=/dev/sdX
```

Windows 用户可以使用 Win32DiskImager 工具很方便的将镜像写入 SD 卡。  

之后将 SD 卡插入树莓派，接通电源，系统就可以正常启动了。  

但之在此之前，还需要做一件事： 因为 Raspbain 系统默认关闭了 SSH 端口，并不能通过另一台计算机远程访问。要开启 SHH 端口需要在 `/boot` 分区新建一个名为 `ssh` 的空白文档。之后再连接电源。

## 连接与配置树莓派

### 连接

将树莓派连接网线之后，便可以使用在同一子网下的计算机远程访问树莓派。通过查看路由器的 `DHCP` 路由表获取树莓派的 IP 地址，Linux 用户也可以使用 `nmap` 工具扫面当前子网下的所有设备来获得树莓派的 IP 地址。  

Windows 用户可以使用 PuTTY 工具，输入树莓派的 IP 地址。

```text
username: pi
password: raspberry
```

Linux 用户直接在终端下使用：

```bash
ssh pi@[IP Address]
```

输入密码之后便可很方便的操控设备了。

### 配置

连接树莓派之后，使用 `sudo raspi-config` 开始配置树莓派。包括更改默认密码，设置时区，设置默认语言等等。  

完成基本配置之后，应该做的第一件事就是升级系统。  
首先需要更新软件列表：

```bash
sudo apt-get update
```

之后就可以升级系统了：

```bash
sudo apt-get dist-upgrade
```

---
经过以上步骤，树莓派的基本配置就算完成了。
