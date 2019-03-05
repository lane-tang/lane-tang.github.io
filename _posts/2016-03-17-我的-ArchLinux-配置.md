---
layout: post
title:  "我的 ArchLinux 配置"
date:   2016-03-17 12:45:00 +0800
categories:
- ArchLinux
- Gnome
banner_image: 2016/03/17/archlinux.png
comments: true
---
相比于其他 Linux 操作系统 Arch 做的最好的一点就是包管理系统， `pacman` 和 `yaourt`中可以找到几乎所有我想安装的软件，完全不必单独下载源代码手动编译，同时管理起来也非常方便。Arch 的另一大优势就是它采用了滚动更新，让所有软件都能保持在最新的状态。

Arch 的缺点是对用户门槛要求较高，尤其是整个系统安装过程都需要在命令行下执行，没有接触过 Linux 的人可能会感到一头雾水，好在 [ArchWiki](https://wiki.archlinux.org/) 非常详细，仔细阅读的话不仅对 Arch 的使用，对操作系统原理的理解也会大有裨益。

---
## yaourt 安装与使用

安装`yaourt`是完成 Arch 系统安装后应该做的第一件事。

`yaourt`( Yet Another User Repository Tool ) 是 Arch 社区为了扩展 `pacman` 对 AUR ( Arch User Repository ) 的支持而做的另一款包管理系统，它能够自动编译和安装来自 AUR 和 Arch 仓库里各种软件。`yaourt`采用和`pacman`一样的语法，同时提供语法高亮的交互界面，使用十分方便。

### yaourt 安装

`yaourt`的安装十分简单，首先需要编辑`pacman`的配置文件:

```bash
$sudo vim /etc/pacman.conf
```

在配置文件末尾下添加一个新的源：

```text
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```

保存关闭文件之后，就可以通过`pacman`很方便的安装`yaourt`了：

```bash
$sudo pacman -Sy yaourt
```

### yaourt 使用

`yaourt`的语法结构一般是：

```bash
$yaourt <操作符> [操作] [应用名]
```

要更新 Arch 系统，只需要运行：

```bash
$yaourt -Syu
```

安装某一个特定的包：

```bash
$yaourt -S <应用名>
```

To upgrade/add packages:
升级已存在的包：

```bash
$yaourt -U <应用名>
```

从系统中删除一个包：

```bash
$yaourt -R <package-name>
```

安装在本地的包：

```bash
$yaourt -P <应用所在的文件夹>
```

显示安装的应用信息：

```bash
$yaourt --stats
```

---

## 关于 GNOME 的介绍

Gnome 是 Linux 操作系统的一种 桌面环境。与 Windows 不同， Linux 的桌面环境与系统内核分开的：桌面对 Linux 而言只是一个应用程序而已，即使没有这个程序系统照样运行。事实上 Arch 本身并不提供桌面环境，需要用户根据自己需求安装，目前主流的桌面环境有 Gnome，KDE， Xfce, Budgie 等等。关于桌面环境的根多信息，可以参考 ArchWiki：[Desktop environment](https://wiki.archlinux.org/index.php/Desktop_environment#List_of_desktop_environments) 。

个人选择的桌面环境是 Gnome， 这是比较老牌的 Linux 桌面环境，所以相对而言更稳定，开发维护的团队更加专业。

![Gnome](https://www.gnome.org/wp-content/uploads/2015/10/activities_overview.png)
默认的 Gnome 看起来可能有一些简陋。但是 Linux 最大的魅力之一就是其强大的定制功能。功能的定制不但能使界面更加美观，同时能适应用户自己的操作习惯，提高工作效率。

---

## 我的 Gnome 配置

### 1. 准备工作

  首先需要安装的就是`gnome-tweak-tool`，有了这件工具，Gnome 的配置就简单许多了。`gnome-tweak-tool` 默认包含在`gnome-extra`中，如果之前没有安装`gnome-extra`包的话（推荐安装，因为这里面包含一些其他有用的工具），则需要单独安装`gnome-tweak-tool`。

```bash
$pacman -S gnome-tweak-tool
```

### 2. 插件管理

  在`Tweak Tool`应用的`Extensions`标签栏中打开需要的插件（一些插件为系统提供，更多的则需要用户自己到[官网](https://extensions.gnome.org/)下载,除 Chrome 外的大多数浏览器可以直接在网页上安装管理插件，Chrome 浏览器的用户请参考[这篇](https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome)Wiki），以下是一些个人常用的插件：

- [User Themes](https://extensions.gnome.org/extension/19/user-themes/) : 这个一定要打开，否则不能自定义 Shell Theme。

  - [Activities Configurator](https://extensions.gnome.org/extension/358/activities-configurator/) ：    这个插件主要用来管理屏幕左上角的`预览`模式按钮的显示方式，包括将原来的按钮换成图标，或者自定义现实的文本和样式等等。
    ![Activities Configurator](https://extensions.gnome.org/extension-data/screenshots/screenshot_358_0tEVXqg.png)

  - [AlternateTab](https://extensions.gnome.org/extension/15/alternatetab/) ：通过 `Alt + Tab` 按键可以实现在同一窗口下不同应用之间的快速切换。
    ![AlternateTab](https://extensions.gnome.org/extension-data/screenshots/screenshot_15.png)

  - [Applications Menu](https://extensions.gnome.org/extension/6/applications-menu/) ：该插件会在屏幕左上角添加一个根据不同类别分类应用程序的菜单。
    ![Applications Menu](https://extensions.gnome.org/extension-data/screenshots/screenshot_6.png)

  - [Caffeine](https://extensions.gnome.org/extension/517/caffeine/) ：这个插件可以关闭屏幕的自动休眠功能。
    ![Caffeine](https://extensions.gnome.org/extension-data/screenshots/screenshot_517.png)

  - [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/) ：这是一个非常有用的插件，它可以在屏幕侧边显示用户添加的常用的程序快速启动图标和当前正在运行程序的快捷栏（默认情况下只在`预览`模式中显示），同时也能方便用户在不同桌面之间快速切换。
    ![Dash to Dock](https://extensions.gnome.org/extension-data/screenshots/screenshot_307_VW5dorQ.png)

  - [Dynamic Panel Transparency](https://extensions.gnome.org/extension/1011/dynamic-panel-transparency/) ：当应用不在全屏状态时，顶部状态栏保持用户自己设置的透明度，有应用在全屏状态时，顶部状态栏变显示不透明。
    ![Dynamic Panel Transparency](https://extensions.gnome.org/extension-data/screenshots/screenshot_1011_pWGnOl9.png)

  - [Impatience](https://extensions.gnome.org/extension/277/impatience/) ：优化`预览`模式启动的速度。

  - [Native Window Placement](https://extensions.gnome.org/extension/18/native-window-placement/) ：在`预览`模式中平衡各应用窗口显示的大小。
    ![Native Window Placement](https://extensions.gnome.org/extension-data/screenshots/screenshot_18.png)

  - [Removable Drive Menu](https://extensions.gnome.org/extension/7/removable-drive-menu/)：当有外部设备（手机，U盘等）接入到电脑时，会在顶部状态栏显示当前设备的状态，方便用户取消挂载设备。
    ![Removable Drive Menu](https://extensions.gnome.org/extension-data/screenshots/screenshot_7.png)

### 3. 自定义主题

  `Numix-themes`是一个非常漂亮的应用`Material Design`设计的主题包，它包含了 [GTK+](https://en.wikipedia.org/wiki/GTK%2B) 主题和图标主题，更多信息可以访问 [Numix 官方网站](https://numixproject.org/)：
  ![Numix](http://pre07.deviantart.net/4d48/th/pre/f/2014/223/d/3/numix_circle_linux_desktop_icon_theme_by_me4oslav-d6uxcka.png)
  安装起来也非常方便：

  ```bash
  $pacman -S numix-themes
  ```

  安装完成之后，直接在应用程序中打开 `Tweak Tool` ，即可从 `Appearance` 标签栏中选择要应用的主题，在 `Extensions` 标签栏中打开和配置相关插件。（还有一些其它非常有用的设置）

  推荐一些其他的非常漂亮的主题和图标：
- [Adapta-theme](https://github.com/adapta-project/adapta-gtk-theme)

  ![Materials](https://github.com/adapta-project/adapta-github-resources/raw/master/images/Materials.png)

- [Arc-theme](https://github.com/horst3180/arc-theme)

  ![githubusercontent](https://camo.githubusercontent.com/4c0001cbfe222446c4b3af91027b716daec7d3d7/687474703a2f2f692e696d6775722e636f6d2f5068354f624f612e706e67)

- [Paper-icon-theme](https://github.com/snwh/paper-icon-theme)

  ![screenshot](https://snwh.org/images/paper/screenshot.png)

- [Capitaine-cursors](https://github.com/keeferrourke/capitaine-cursors)

  ![capitaine_cursors_by_krourke](http://pre06.deviantart.net/4408/th/pre/f/2016/208/4/7/capitaine_cursors_by_krourke-dabmjtm.png)

- [La-Capitaine-icon-theme](https://github.com/keeferrourke/la-capitaine-icon-theme)

  ![preview](https://github.com/keeferrourke/la-capitaine-icon-theme/raw/master/preview.svg.png)

---
## 关于 Shell 的选择

Linux( 包括Mac OS ) 默认的 Shell 是 Bash 。但是在实际使用中，Z-Shell 比 Bash 更加方便，尤其是在命令的自动补全方面。同时针对Zsh有大量的插件，让命令行的使用更加高效。使用 Oh-My-Zsh 的配置框架能在短短几行代码之间给你强大的 Zshell 。有关如何用Oh-My-Zsh配置主题和启用插件，可以登陆 [Oh-My-Zsh 的官方网站](http://ohmyz.sh/)了解更多。

Arch 默认是不安装 Zshell 的，需要自己手动安装:

```bash
$pacman -S zsh
```

安装完成之后只需一行代码就可以完成安装 Oh-My-Zsh：

```bash
$sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

之后就只需要从 Bash 切换到 Zsh 了：

```bash
$chsh -s /usr/local/bin/zsh
```

---

经过以上步骤，Gnome桌面配置就基本完成了。
