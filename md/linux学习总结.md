---
ptitle: Linux 学习总结
date: 2021-07-12 01:16:30
tags: 总结
---
## 固定ip配置

## 修改配置文件

### 文件所在目录：

/etc/netplan/01-network-manager-all.yaml

> 在Ubuntu17后采用该文件配置，是一种类似与xml的配置文件

### 配置文件内容us

#### 静态IP配置

```
# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager
  ethernets:
          eth0:
                  dhcp4: false
                  addresses: [192.168.1.4/24]
                  gateway4: 192.168.1.1
                  nameservers:
                         addresses: [8.8.8.8, 114.114.114.114]
```

> dhcp4: 其中的4表示针对ipv4，其他类似
>
> addresses：可以有多个，逗号隔开即可
>
> eth0：网卡名称，通过 `ip addr` 命令可以查到
>
> ethernets：网卡信息，其中可以并列配置多张网卡
>
> 注意各个字段和内容冒号后要空格

#### 动态IP配置

```
# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager
  ethernets:
          eth0:
                  dhcp4: true
```

#### 配置多个网卡

如果虚拟机创建了又一个网卡，但是没有对应的ip配置，可通过如下方法：

```shell
vim /etc/netplan/02-network-manager-all.yaml
sudo netplan apply
```

> 创建一个新的网卡配置文件02-network-manager-all.yaml，并将配如下的信息写入，刷新网卡，既可以看到配置的固定ip

network:
  version: 2
  renderer: NetworkManager
  ethernets:
          eth0:
                  dhcp4: false
                  addresses: [192.168.1.4/24]
                  gateway4: 192.168.1.1
                  nameservers:
                         addresses: [8.8.8.8, 114.114.114.114]

## 配置生效

```
sudo netplan apply
```

> 即时生效，无序重启，生效后可以通过 `ip addr`命令查看到网卡的ip

## 附录

```
sudo netplan --debug apply
```

> 增加--debug可以看到执行过程，遇到问题方便定位

# linux 命令学习笔记

## 如何学习使用命令

```shell
duanzhenghong@duanzhenghong-pc:~$ uname --help
用法：uname [选项]...
输出一组系统信息。如果不跟随选项，则视为只附加 -s 选项。

  -a, --all                以如下次序输出所有信息。其中若 -p 和
                             -i 的探测结果不可知则被省略：
  -s, --kernel-name        输出内核名称
  -n, --nodename           输出网络节点上的主机名
  -r, --kernel-release     输出内核发行号
  -v, --kernel-version     输出内核版本
  -m, --machine            输出主机的硬件架构名称
  -p, --processor          输出处理器类型（不可移植）
  -i, --hardware-platform  输出硬件平台或（不可移植）
  -o, --operating-system   输出操作系统名称
      --help            显示此帮助信息并退出
      --version         显示版本信息并退出

GNU coreutils 在线帮助：<https://www.gnu.org/software/coreutils/>
请向 <http://translationproject.org/team/zh_CN.html> 报告 uname 的翻译错误
完整文档请见：<https://www.gnu.org/software/coreutils/uname>
或者在本地使用：info '(coreutils) uname invocation'
duanzhenghong@duanzhenghong-pc:~$ info uname
duanzhenghong@duanzhenghong-pc:~$ man uname

```

> 以 `uname` 为例子,如上展示了三种查看帮助和手册的方法, man 命令实际是manual的缩写

## 命令按功能分类

### 查看系统的一些基本信息

#### 版本

```shell
duanzhenghong@duanzhenghong-pc:~$ cat /etc/issue
Ubuntu 20.04.2 LTS \n \l
duanzhenghong@duanzhenghong-pc:~$ cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.2 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.2 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
duanzhenghong@duanzhenghong-pc:~$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.2 LTS
Release:        20.04
Codename:       focal
```

> LSB（linux标准库linux standard base）

```shell
duanzhenghong@duanzhenghong-pc:~$ uname
Linux
duanzhenghong@duanzhenghong-pc:~$ uname -a
Linux duanzhenghong-pc 5.8.0-50-generic #56~20.04.1-Ubuntu SMP Mon Apr 12 21:46:35 UTC 2021 x86_64 x86_64 x86                      _64 GNU/Linux
duanzhenghong@duanzhenghong-pc:~$ uname -v
#56~20.04.1-Ubuntu SMP Mon Apr 12 21:46:35 UTC 2021

```

#### 线程

ps -ef

> 常配合管道命令 | 和查找命令 grep 同时执行来查看特定进程。
>
> 参数含义:
>
> -e 显示所有进程。-f 全格式。-h 不显示标题。-l 长格式。-w 宽输出。a 显示终端上的所有进程，包括其他用户的进程。r 只显示正在运行的进程。x 显示没有控制终端的进程。

top

> 实时显示进程信息

htop

> htop是top的增强版,显示色彩,在命令行可以交互控制进程

建立软连接

```shell
root@dzh-pc:/usr/bin# ll | grep python
lrwxrwxrwx  1 root root          23 5月  27 21:30 pdb3.8 -> ../lib/python3.8/pdb.py*
lrwxrwxrwx  1 root root          31 3月   9 23:25 py3versions -> ../share/python3/py3versions.py*
lrwxrwxrwx  1 root root           9 3月   9 23:25 python3 -> python3.8*
-rwxr-xr-x  1 root root     5482296 5月  27 21:30 python3.8*
root@dzh-pc:/usr/bin# ln -s python3.8 python
root@dzh-pc:/usr/bin# ll | grep python
lrwxrwxrwx  1 root root          23 5月  27 21:30 pdb3.8 -> ../lib/python3.8/pdb.py*
lrwxrwxrwx  1 root root          31 3月   9 23:25 py3versions -> ../share/python3/py3versions.py*
lrwxrwxrwx  1 root root           9 6月   3 23:12 python -> python3.8*
lrwxrwxrwx  1 root root           9 3月   9 23:25 python3 -> python3.8*
-rwxr-xr-x  1 root root     5482296 5月  27 21:30 python3.8*
root@dzh-pc:/usr/bin# python
Python 3.8.5 (default, May 27 2021, 13:30:53)
[GCC 9.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

> 通过建立软连接python -> python3.8，可以直接使用python来调用python3.8

#### 计算机名

```shell
duanzhenghong@duanzhenghong-pc:~$ cat /etc/hostname
duanzhenghong-pc
duanzhenghong@duanzhenghong-pc:~$ hostname
duanzhenghong-pc
```

> hostname在linux和dos都可以使用

```shell
vim /etc/hostname
```

> 修改hostname文件中的名字并重启就可以改变计算机的名字

#### 配置固定ip的思路(hyper-v虚拟机)

- 虚拟机配置dhcp,使用默认的虚拟交换机(自动配饰nat内网穿透功能),同时在windows主机下,将外网共享给默认的虚拟交换机,配置后可以访问外网.
- 创建一个内部交换机(假设名为fixIP),指定为内部网络,其他默认,然后再对应的虚拟机设置上增加(注意是增加,默认的交换机仍在)一个网络适配器,指定使用fixIP虚拟交换机.然后启动虚拟机,虚拟机中会增加一个网卡,修改该网卡对应的配置文件,配置为static,配置一个固定ip,同时在主机环境中将fixIP指定一个ip(与虚拟机设置的固定ip同网段)
- 虚拟机的代理功能配置

  全局变量增加

  ```
  export http_proxy=http://username:password@proxyhk.huawei.com:8080

  export https_proxy=http://username:password@proxyhk.huawei.com:8080
  ```

  > 注意密码中包含的特殊字符需要转换成url编码格式
  >
- git代理设置

  https://www.jianshu.com/p/290152303598

## shell 特殊变量

1）$0  获取当前执行脚本的文件名包括路径
dirname $0   只取当前执行脚本的路径

basename $0   只取当前执行脚本文件名

2）$#  执行命令行(脚本)参数的总个数

3）$@   这个执行程序的所有参数

4）$*  获取当前shell 的所有参数(注意与$@区别)

> $* 和 $@ 的区别：
>
> $* 和 $@ 都表示传递给函数或脚本的所有参数，不被双引号" "包含时，都以"$1" "$2" … "$n" 的形式输出所有参数。但是当它们被双引号" "包含时，"$*" 会将所有的参数作为一个整体，以"$1 $2 … $n"的形式输出所有参数；"$@" 会将各个参数分开，以"$1" "$2" … "$n" 的形式输出所有参数。

5）$!  上一个执行命令的PID

6）$$  获取当前shell的PID

7）$_  代表上一个命令的最后一个参数，如果上个命令没有参数，则代表上个命令。总之取得是上个执行命令中的最后一块

```
root@dzh-pc:/dzh# pwd /dzh && ll $_
/dzh
总用量 24
drwxr-xr-x  6 root root 4096 6月  17 00:09 ./
drwxr-xr-x 21 root root 4096 3月  15  2021 ../
drwxr-xr-x  2 root root 4096 6月  17 01:09 blog/
drwxr-xr-x  7 root root 4096 8月   3 23:48 repository/
drwxr-xr-x  2 root root 4096 5月   2  2021 rubbish/
drwxr-xr-x  3 root root 4096 6月  10 00:24 tools/
root@dzh-pc:/dzh# pwd && ll $_
/dzh
ls: 无法访问 'pwd': 没有那个文件或目录
```

8）$?  上一个命令的退出状态

所谓退出状态，就是上一个命令执行后的返回结果。

返回值含义如下：

| 0     | 表示运行成功                                     |
| ----- | ------------------------------------------------ |
| 2     | 权限拒绝                                         |
| 1~125 | 表示运行失败，脚本命令、系统命令或者参数传递错误 |
| 126   | 找到了该命令，但是无法执行                       |
| 127   | 未找到要运行的命令                               |
| 128   | 命令被系统强制结束                               |

9）$n 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。

## linux重定向

`>`  会覆盖原有内容

`>>`  追加，不覆盖原内容

标准输入  文件描述符 0

标准输出  文件描述符 1

标准错误  文件描述符 2

### 例子

有些时都会碰到以下格式的命令：

```text
command >> result.log 2>&1 &
```

command >> result.log

这个很好理解，就是就运行的结果放入result.log

其实这个完整形式应该是：command 1>> result.log，所以只有运行正确的结果会保存到result.log中，但是我们设置log，往往是希望拍错时可以看到报错信息。

所以，应该想办法把错误信息也定向到result.log文件。

所以2>&1的作用，就是将错误信息定向到标准输入，最后一个&的作用就是让程序在后台运行。

总体的效果图：

![img](https://pic1.zhimg.com/80/v2-c41e76055c7839a0676b1da2f9ff2c70_1440w.jpg)

数字是执行的顺序

前后的顺序很重要，因为标准输出已经流向了result.log，所以再执行2>&1时，标出错误自然也会流向result.log.

但是如果顺序反了，比如:

```text
command  2>&1 >> result.log 
```

当command 运行出错时，请问这个命令的结果是什么

为什么会是这个结果？只输出错误日志到log？

参考文章：[Shell标准输出、标准错误 &gt;/dev/null 2&gt;&amp;1](https://link.zhihu.com/?target=http%3A//blog.sina.com.cn/s/blog_4aae007d010192qc.html)

command < filename 把标准输入重定向到filename文件中
command 0< filename 把标准输入重定向到filename文件中

command > filename 把标准输出重定向到filename文件中(覆盖)
command 1> fielname 把标准输出重定向到filename文件中(覆盖)

command >> filename 把标准输出重定向到filename文件中(追加)
command 1>> filename 把标准输出重定向到filename文件中(追加)

command 2> filename 把标准错误重定向到filename文件中(覆盖)
command 2>> filename 把标准输出重定向到filename文件中(追加)

command > filename 2>&1 把标准输出和标准错误一起重定向到filename文件中(覆盖)
command >> filename 2>&1 把标准输出和标准错误一起重定向到filename文件中(追加)

command < filename >filename2 把标准输入重定向到filename文件中，把标准输出重定向

到filename2文件中
command 0< filename 1> filename2 把标准输入重定向到filename文件中，把标准输出重定向

到filename2文件中

重定向的使用有如下规律：

1）标准输入0、输出1、错误2需要分别重定向，一个重定向只能改变它们中的一个。
2）标准输入0和标准输出1可以省略。（当其出现重定向符号左侧时）
3）文件描述符在重定向符号左侧时直接写即可，在右侧时前面加&。
4）文件描述符与重定向符号之间不能有空格！

## shell交互输入自动化

### 利用管道完成交互的自动化

这个就是利用管道特点，让前个命令的输出作为后个命令的输入完成的
eg：`echo -e "输入A\n输入B\n" | ./test.sh `

> 上面命令中的 "输入A\n输入B\n" 中的“\n”是换行符的意思，相当于输入一个后回车。

### 利用expect

expect是专门用来交互自动化的工具，但它有可能不是随系统就安装好，有时需要自己手工安装该命令
查看是否已经安装：rpm -qa | grep expect
以下脚本完成跟上述相同的功能

```
[root@localhost test]# cat expect_test.sh 
\#! /usr/bin/expect
spawn ./test.sh
expect "enter number:"
send "1\n"
expect "enter name:"
send "lufubo\n"
expect off
```

> 注意：第一行是/usr/bin/expect，这个是选用解释器的意思，我们shell一般选的是 /bin/bash,这里不是
> spawn: 指定需要将哪个命令自动化
> expect:需要等待的消息
> send:是要发送的命令
> expect off:指明命令交互结束

### 利用重定向

`./test.sh < input.data`

> ./test.sh是要执行的脚本
>
> input.data中是预先写好的要输入的参数，每行一个参数

## shell脚本生成文本文件

### 使用echo命令

```
echo "Hello, World!
My name is Shengbin." > readme.txt
```

这种方法其实就是把 `echo`的输出重定向到了文件。`echo`会原样保留换行符，因此多行也是支持的。

### 使用cat命令

```
cat > readme.txt << END_TEXT
Hello, World!
My name is Shengbin.
END_TEXT
```

上面的 `END_TEXT`是一个自定义的标识符，两者之间的文本将被认为是一个文件的内容，这个文件做为 `cat > readme.txt`的输入参数。 这是一种被称为[here document](http://www.javashuo.com/link?url=http://en.wikipedia.org/wiki/Here_document)的技术。

这种方法有一点优点就是在脚本里写的文本内容的格式与想要呈如今文本文件中的如出一辙。上一种方法则要求内容的第一行必须在 `echo`的同一行。

## 同时执行多个脚本的方法

&&   与的含义（逻辑运算短路原则），只有前面的执行成功了，才会继续执行后面的命令，单进程执行

||       或的含义（逻辑运算短路原则），只有前面的失败了，才会继续执行后面的，单进程执行

；     依次执行命令，前面的命令结束，才会执行后面的命令，单进程执行

&      并行执行，独立的关系。多进程执行

### 并行执行

实际应用的一个例子

```
#!/bin/bash

set -e

waitTime=1
# 并发8个子进程

for i in seq 0 7 
do
{
	sleep $[i*$waitTime];icomp -file command$[i*$waitTime].txt > log$[i*$waitTime].txt # 文件的开头加入了sleep，每个命令相隔1s，因为预编译阶段需要处理相同的文件名，会导致冲突报错，这样可以将预编译阶段错开，实现并行，实际优化效果明显
}&   # & 语句丢到后台，继续下个迭代，实现并发
done
wait # 等待所有后台子进程结束

```

## 循环

（todo）https://blog.csdn.net/oqqHuTu12345678/article/details/125660919

# 21个特殊符号

## > 重定向输出符号

    用法：命令 >文件名
     特性：覆盖（当输入文件和输出文件是同一文件，文
           件内容被清空；不适合连续重定向）
eg: [root@Centos home]# ls -l /home/ > 1.txt
root@Centos home]# cat 1.txt
total 32
-rw-r--r--. 1 root root     0 Jan 22 02:16 1.txt
-rw-r--r--. 1 root root    29 Jan 22 00:55 aa.txt
-rw-r--r--. 1 root root    22 Jan 22 02:15 bb.txt
-rw-r--r--. 1 root root    31 Jan 21 05:19 home.txt
drwxrwxrwx. 2 root root  4096 Jan 19 23:18 iso
drwx------. 2 root root 16384 Jan 19 21:02 lost+found
[root@Centos home]# date >2
[root@Centos home]# cat 2
Tue Jan 22 02:17:20 CST 2013

## >> 重定向输出符号

    用法：命令 >>文件名（没有就新建，有就追加）
      特性：追加
eg:[root@Centos home]# date >>2
[root@Centos home]# cat 2
Tue Jan 22 02:17:20 CST 2013
Tue Jan 22 02:19:00 CST 2013

`> 文件名` 可以快速清空文件内容

## 2> 错误重定向输出符号

    用法：命令 2>文件名
      特性：覆盖
eg：[root@Centos home]# vim a.txt
[root@Centos home]# cat a.txt
qwe
asd
zxc
123

## 2>> 错误重定向输出符号

    用法：命令 2>>文件名
      特性：错误信息的追加
   典型应用：命令 >文件名 命令 2>文件名
            命令 >/dev/null 2>/dev/null==命令 >
             /dev/null

## |  管道符号

    用法：命令1 | 命令2
      机制：上一个的命令输出作为下一个命令的输入
eg：
[root@Centos etc]#eg:ls -l | more
分页显示（只能向下翻页，按空格space键盘，向下翻一页，按enter键向下翻一行，直接一
         直按空格直到结束）
[root@Centos etc]#ls -l | less
分页显示：（按空格space键盘向下一页一页的翻，按箭头向上的键则向上一行一行的翻，按
            箭头向下的键则向下一行一行的翻，按enter键向下翻一行，到最后显示end时，
            敲一下q键退出。或者在中途按q键也是退出。）
[root@Centos ~]# ls -a | grep bash
.bash_history
.bash_logout
.bash_profile
.bashrc
grep用来从一个文件中找出匹配指定关键字的那一行，并送到标准输出,结合管道，我们
通常用它来过滤搜索结果.

## `*`  匹配任意字符

 eg： home]# touch abc*def.pdf
                  touch q.pdf
                  touch 1*1.pdf
                  touch *1.pdf （先建立四个文件）
         （1）find /home/*.pdf  （可通过后面的后缀名来查找，但是linux的后缀名不一定就是你看                                 见的）
[root@Centos /]# find /home/*.pdf
/home/1*1.pdf
/home/*1.pdf
/home/abc*def.pdf
/home/q.pdf
        （2）find /home/*\**.pdf（这个匹配中间有一个*，*的前后随便有几个字符也包括0个都可以）
[root@Centos /]# find /home/*\**.pdf
/home/1*1.pdf
/home/*1.pdf
/home/abc*def.pdf
         （3） find /home/\**.pdf（这个是匹配第一个字符为*，后面随便有几个字符）
[root@Centos /]# find /home/\**.pdf
/home/*1.pdf
          （4）find /home/*\*1.pdf（这个是匹配有一个*，*前面随便几个字符，*的后面是1的）
[root@Centos /]# find /home/*\*1.pdf
/home/1*1.pdf
/home/*1.pdf

## ？ 匹配任意一个字符

 eg：
[root@Centos home]# ls
ab.txt  a.txt  ba.txt  b.txt  iso  lost+found
[root@Centos home]# find /home/?.txt
/home/a.txt
/home/b.txt

## &  后台进程符

    用法：命令（程序） &

## && 逻辑与

    用法：命令1 && 命令2
      机制：如果命令1执行成功，继续执行命令2；否则，
           不执行命令2
eg:
[root@Centos ~]# date > 2.txt
[root@Centos ~]# date > 2.txt && cat 2.txt
Wed Jan 23 07:49:36 CST 2013

## || 逻辑或

    用法：命令1 || 命令2
       机制：如果命令1执行成功，不执行命令2；否则，
           才执行命令2

## ！ 逻辑非

    机制：排除指定范围

## [x-y]  指定范围

## #  注释

 eg：当你打开一个shell脚本的时候，第一句基本是#!/bin/bash
        井号也常出现在一行的开头，不会被执行。
        当某条命令不想被执行的时候，只需在该行的前面加上#即可。
       #ls（则表示ls命令不会执行）
       echo "aaa" >>liu;#cat liu（则仅此cat命令不会执行，前面的命令还是会执行）

## ""  双引号

    机制：把它所包含的内容作为普通字符，但‘’
    $ `` 除外
eg：
[root@Centos /]# echo -e "your system is init done.\nplease reboot"
your system is init done.
please reboot
[root@Centos ~]# echo "`date`"
Wed Jan 23 07:51:49 CST 2013
[root@Centos ~]# echo "$LANG"
en_US.UTF-8

## ‘ ’ 单引号

    机制：把它所包含的内容作为普通字符，无例外

## ``  倒引号（在tab键的上面）

    机制：执行它所包含的内容,他包含的是命令

> $(命令) 同样可以达到倒引号的效果

## \  转义字符

    用法; \符号
       机制：把符号的特定含义去掉，使其变成普通标点
             符号

## $  变量调用符号

    用法： $变量
       机制：调用变量，从而得到‘变量的值’

```
[root@Centos ~]# LI=date(先定义变量，定义变量必须是大写）
[root@Centos ~]# $LI（调用变量）
Wed Jan 23 08:08:11 CST 2013
```

- `$`可获取变量的值: `echo $a`
- "$" **获取变量值时最好使用"括起来**

  ```
  a="i am skyler"
  [ $a == "i am skyler" ]
  ```

  这里解析下[]，[]是条件判断符号，相当于test命令。他的意思是判断a变量的值是否等于"i am skyler"。
  那么为什么会报错呢，因为[ $a == "i am skyler"]这种写法变量解析后成为[ i am skyler == "i am skyler" ]，很明显，这个判断式无法判断等号两边的字符串，我们想要的是[ "i am skyler" == "i am skyler" ]的比较。

  应该用 [ "$a" == "i am skyler" ]
- `$0 $1 $n` 获取文件名称和参数值，一般在bash脚本中较多

  $0 表示shell脚本文件名；从1开始表示第几个参数，1表示第一个参数。

  ```
  创建一个test.sh文件并填充代码
  [root@izbp10lqlgy2g31s41bt94z ~]# echo 'echo $0 $1 $2' > test.sh
  [root@izbp10lqlgy2g31s41bt94z ~]# cat test.sh
  echo $0 $1 $2

  执行test.sh 并传入变量
  [root@izbp10lqlgy2g31s41bt94z ~]# sh test.sh i am skyler
  test.sh i am
  ```

  可以看到，三个参数中前两个打印出来了，因为我们没有声明$3，所有打印出了文件名称和前两个参数
- `${#}`获取变量值的长度

  ```
  [root@izbp10lqlgy2g31s41bt94z ~]# a=11111
  [root@izbp10lqlgy2g31s41bt94z ~]# echo "get length of a = ${#a}"
  get length of a = 5
  ```
- `$#` 获取参数数量

  ```
  [root@izbp10lqlgy2g31s41bt94z ~]# echo 'echo $# $0 $1' > test.sh
  [root@izbp10lqlgy2g31s41bt94z ~]# cat test.sh
  echo $# $0 $1
  [root@izbp10lqlgy2g31s41bt94z ~]# sh test.sh I am a shuashua
  4 test.sh I
  ```
- `$@ $\*` 数组的形式引用参数列表

  如 `"$*"`用 `"`括起来的情况、以"$1 $2 … $n"的形式输出所有参数

  如 `"$@"`用 `"`括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数

  它们的区别在于使用双引号括起来用时，假设传入的参数为1 2 3，那么 `$*`的值为”1 2 3”一个变量

  ```
  test.sh
  echo '$@的数组参数格式'
  for x in "$@"
  do
   echo + $x
  done
  echo '$*的数组参数格式'
  for x in "$*"
  do
   echo + $x
  done

  root@izbp10lqlgy2g31s41bt94z:~# sh test.sh 1 2 3
  $@的数组参数格式
  + 1
  + 2
  + 3
  $*的数组参数格式
  + 1 2 3
  ```
- `$?` 上个命令返回值

  0表示成功，非0表示执行失败

  最后运行的命令的结束代码（返回值）
- `$$`Shell本身的PID（ProcessID）
- `$()` 等同于使用反引号\`\`,属于命令替换
- `$[]` 表达式计算，等价于 `$(( ))`

  ```
  [root@izbp10lqlgy2g31s41bt94z ~]# echo $[5 + 5]
  10
  ```
- `$-` 显示shell所使用的当前选项

  ```
  [root@izbp10lqlgy2g31s41bt94z ~]# echo $-
  himBH

  解释：himBH每一个字符是一个shell的选项，详情man bash然后搜索 -h -B 等。详情参考：http://kodango.com/explain-shell-default-options
  ```
- `$!`Shell最后运行的后台Process的PID

  ```
  [root@izbp10lqlgy2g31s41bt94z ~]# cat test.sh &
  [1] 362
  [root@izbp10lqlgy2g31s41bt94z ~]# echo $# $0 $1
  ^C
  [1]+ 完成     cat test.sh
  [root@izbp10lqlgy2g31s41bt94z ~]# echo $!
  362
  ```
- `!$` 将上一条命令的参数传递给下一条命令的参数，更多应用在bash脚本

  ```
  [root@izbp10lqlgy2g31s41bt94z ~]# cd /Users/skyler/project/test
  [root@izbp10lqlgy2g31s41bt94z ~]# ll !$
  [root@izbp10lqlgy2g31s41bt94z ~]# ll /Users/skyler/project/test
  362
  ```
- !! 将上一条命令输出 ，更多应用在bash脚本

  ```
  [root@izbp10lqlgy2g31s41bt94z ~]# !!
  [root@izbp10lqlgy2g31s41bt94z ~]# ll /Users/skyler/project/test
  ```
- `${ }` 变量替换

  字符串截取请[参考](#参考)

  假设我们定义了一个变量为：

  file=/dir1/dir2/dir3/my.file.txt

  我们可以用 **${ }** 分别替换获得不同的值：

  ```
  ${file#*/}：拿掉第一条 / 及其左边的字串：dir1/dir2/dir3/my.file.txt
  ${file##*/}：拿掉最后一条 / 及其左边的字串：my.file.txt
  ${file#*.}：拿掉第一个 . 及其左边的字串：file.txt
  ${file##*.}：拿掉最后一个 . 及其左边的字串：txt
  ${file%/*}：拿掉最后一条 / 及其右边的字串：/dir1/dir2/dir3
  ${file%/*}：拿掉第一条 / 及其右边的字串：(空值)
  ${file%.*}：拿掉最后一个 . 及其右边的字串：/dir1/dir2/dir3/my.file
  ${file%%.*}：拿掉第一个 . 及其右边的字串：/dir1/dir2/dir3/my
  ```

  **记忆的方法为**：

  ```
  # 是去掉左边(在键盘上 # 在 $ 之左边)
  % 是去掉右边(在键盘上 % 在 $ 之右边)
  单一符号是最小匹配；两个符号是最大匹配。
  ```

  还可以按下标取指定长度的子串：

  ```
  ${file:0:5}：提取最左边的 5 个字?：/dir1
  ${file:5:5}：提取第 5 个字右边的连续 5 个字：/dir2
  ```

  我们也可以对变量值里的字串作替换：

  ```
  ${file/dir/path}：将第一个 dir 提换为 path：/path1/dir2/dir3/my.file.txt
  ${file//dir/path}：将全部 dir 提换为 path：/path1/path2/path3/my.file.txt
  ```

  利用 ${ } 还可针对不同的变数状态赋值(没设定、空值、非空值)：

  ```
  ${file-my.file.txt} ：假如 $file 为空值，则使用 my.file.txt 作默认值。(保留没设定及非空值)
  ${file:-my.file.txt} ：假如 $file 没有设定或为空值，则使用 my.file.txt 作默认值。 (保留非空值)
  ${file+my.file.txt} ：不管 $file 为何值，均使用 my.file.txt 作默认值。 (不保留任何值)
  ${file:+my.file.txt} ：除非 $file 为空值，否则使用 my.file.txt 作默认值。 (保留空值)
  ${file=my.file.txt} ：若 $file 没设定，则使用 my.file.txt 作默认值，同时将 $file 定义为非空值。 (保留空值及非空值)
  ${file:=my.file.txt} ：若 $file 没设定或为空值，则使用 my.file.txt 作默认值，同时将 $file 定义为非空值。 (保留非空值)
  ${file?my.file.txt} ：若 $file 没设定，则将 my.file.txt 输出至 STDERR。 (保留空值及非空值))
  ${file:?my.file.txt} ：若 $file 没设定或为空值，则将 my.file.txt 输出至 STDERR。 (保留非空值)
  ${#var} 可计算出变量值的长度：${#file} 可得到 27 ，因为 /dir1/dir2/dir3/my.file.txt 刚好是 27 个字?…
  ```

  接下来介绍一下 bash 的数组(array)处理方法：
  一般而言，A=”a b c def” 这样的变量只是将 $A 替换为一个单一的字串，
  但是改为 A=(a b c def) ，则是将 $A 定义为数组。
  bash 的数组替换方法可参考如下方法：

  - ${A[@]} 或 ${A[*]} 可得到 a b c def (全部数组)
  - ${A[0]} 可得到 a (第一个数组)，${A[1]} 则为第二个数组…
  - `${#A[@]}` 或 `${#A[*]}` 可得到 4 (全部数组数量)
  - `${#A[0]}` 可得到 1 (即第一个数组(a)的长度)，${A[3]} 可得到 3 (第一个数组(def)的长度)
  - A[3]=xyz 则是将第 4 个数组重新定义为 xyz …

## ； 命令分隔符

    用法：命令1 ； 命令2
       机制;一行语句中，顺次执行各命令
eg：date >>myfile;cat myfile（分号前面有空格和没有空格都一样）

20（） 整体执行
eg：
[root@Centos home]# (cd ~;VC=`pwd`;echo $VC)
/root

## []是条件判断符号，相当于test命令

## 变量分离

## <  重定向输入符号

    用法：命令 <文件名

输入重定向
输入重定向是指把命令（或可执行程序）的标准输入重定向到指定的文件中。也就是说，输入可以不来自键盘，而来自一个指定的文件。所以说，输入重定向主要用于改变一个命令的输入源，特别是改变那些需要大量输入的输入源。
例如，命令wc统计指定文件包含的行数、单词数和字符数。如果仅在命令行上键入：
wc
wc将等待用户告诉它统计什么，这时shell就好象死了一样，从键盘键入的所有文本都出现在屏幕上，但并没有什么结果，直至按下＜ctrl+d＞，wc才将命令结果写在屏幕上。
eg：1
[root@Centos home]# wc(自己随便输入）
ziji suibian shuru
123 122
2233  （输入完之后按住crtl+d）
      3       6      32（告诉你有几行，几个单词，几个字符）
eg：2
[root@Centos /]# wc /etc/passwd（wc命令后面可以接文件，意思就是统计文件内容的个数）
  29   45 1394 /etc/passwd
[root@Centos /]# wc /home/aa.txt

 1  6 29 /home/aa.txt
参考：https://blog.51cto.com/litaotao/1187983

# shell返回值

## 返回值含义

| 返回值 | 含义                   |                              示例                              |                                说明 |
| :----: | :--------------------- | :------------------------------------------------------------: | ----------------------------------: |
|   1   | 各种常见错误           |                        let "var1 = 1/0"                        |         shell里面最常见的错误返回值 |
|   2   | shell内建功能使用错误  |                      empty_function() {}                      |            常见于关键字或者命令出错 |
|  126  | 命令无法执行           |                           /dev/null                           |        由于权限等导致的命令无法执行 |
|  127  | 命令无法找到           |                        illegal_command                        |            一般是PATH环境变量不对等 |
|  128  | 退出返回值错误         |                          exit 3.14159                          |      返回值只能是整数，小数就不对了 |
| 128+n | 信号 "n"+128           | kill -9$PPID of script |             $? 即返回 137 (128 + 9) |                                     |
|  130  | ctrl+c 退出            |                             Ctl-C                             | 其实ctrl+c返回的是2 (130 = 128 + 2) |
|  255*  | 返回值超出可接受的范围 |                            exit -1                            |                      只能是 0 - 255 |

## 启动控制脚本的标准返回值

下表列出了关于/etc/init.d/目录下启动控制脚本的标准返回值：

- 0 程序在运行或者服务状态OK
- 1 程序已经死掉，但是 pid文件仍在 /var/run目录下存在
- 2 程序已经死掉，但是lock文件仍在 /var/lock 目录下存在
- 3 程序没有运行
- 4 程序运行状态未知
- 5-99 供LSB扩展的保留段
- 100-149 供特定系统发行版使用的保留段
- 150-199 供特定程序使用的保留段
- 200-254 保留段

## 自定义返回值

在写shell脚本的时候需要注意自定义的退出返回值最好不要与上面表格中所定义的重复，对于管理人员来说养成良好的习惯有助于遇到错误时作出正确的判断。 根据上表至少可以得出，在自定义返回值的时候：

- 最好不要用的：0-4 126-130 255
- 应避免使用的：5-99
- 可随意使用的：100-125 131-254

## shell返回码与函数返回码、命令返回码的区别：

shell返回码，标识整个脚本的执行结果状态，用“exit 返回码”表示。

函数返回码，标识一个函数的执行结果状态，用“return 返回码”表示。

命令返回码，标识一个命令的执行结果状态，在命令执行后，紧跟着获取返回码，用"$?"获取

参考文档:

- http://tldp.org/LDP/abs/html/exitcodes.html
- http://refspecs.linux-foundation.org/LSB_4.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptact.html

# Linux目录介绍

## /etc/init.d

1、init.d 目录中存放的是一系列系统服务的管理（启动与停止）脚本。
2、用service命令可执行init.d目录中相应服务的脚本。

例：执行命令“service resin start”，可启动/etc/init.d/resin脚本

参考：[/etc/init.d/目录_weixin_34289744的博客-CSDN博客](https://blog.csdn.net/weixin_34289744/article/details/91695045)

## /var/log

系统日志

# 命令

## arch

```
arch # 查看CPU架构
```

## bc

1. 输入bc可以进入交互页面，包含加减乘除指数余数运算的表达式都可以计算
2. 管道符

   ```
   $ echo "15+5" | bc
   20
   ```
3. scale指定精度

   ```
   $ echo 'scale=2; (2.777 - 1.4744)/1' | bc
   1.30
   ```
4. ibase、obase指定输入输出数的进制，进制转换

   ```
   $ echo "ibase=2;111" | bc # 二进制的111 转换为10进制
   $ echo "obase=10;ibase=2;11000000" | bc  # 执行结果为：192，这是用bc将二进制转换为十进制。
   ```

   注意： `该命令可以进行大数运算`

## basename

```
basename `pwd` # 获取当前文件夹的名字（通过处理一个路径得到）
```

## cat

```sh
# 清空文档内容
cat /dev/null > /etc/test.txt
# 把文件file1的内容加上行号输入到file2里
cat-n file1 > file2
# 多个文件按顺序放到一个文件里
cat file1 file2 file3 > file4



# 创建一个包含已知内容的文件
# 这里 END是一个自定义的结束符号，分界符<<作用是，表示分界符后的内容将被当做标准输入传给<<前面的命令
cat >> ~/.ArtGet/conf/Setting.xml << END
<?xml version="1.0" encoding="UTF-8"?>

<settings>
	<userName>d00889966</userName>
	<password>huawei!@#123</password>
</settings>

END

# 输入的字符串中加入变量，实现变量替换,但是这里结束符需要用单引号包起来，如果要抑制变量替换，去掉单引号即可
cat >> ~/.ArtGet/conf/Setting.xml << 'END'
<?xml version="1.0" encoding="UTF-8"?>

<settings>
	<userName>$userName</userName>
	<password>$passward</password>
</settings>

'END'
```

## chown

```sh
chown -R builduser:users  /usr1   # 递归的修改目录 /usr1 的归属用户为users用户组的builduser用户
```

## chmod

```
# 修改权限 方式1
chmod o+w xxx.xxx
chmod go-rw xxx.xxx
```

> u 代表所有者（user）
> g 代表所有者所在的组群（group）
> o 代表其他人，但不是u和g （other）
> a 代表全部的人，也就是包括u，g和o
>
> 行动：
> \+ 表示添加权限
> \- 表示删除权限
> = 表示使之成为唯一的权限

```sh
# 修改权限 方式2
chmod 777 xxx.xxx
```

> **权限信息解析**
>
> ls -l可以查看权限信息,一共有10位数，如下是两组例子：
>
> drwxr-xr-x
> -rw-r--r--
>
> 第一位代表的是类型，`-`代表文件，`d`代表目录
>
> 后九位三个一组分别描述了user、group、other的权限
>
> r （用数字4表示）表示文件可以被读（read）
> w （用数字2表示）表示文件可以被写（write）
> x （用数字1表示）表示文件可以被执行（如果它是程序的话）
> \- （用数字0表示）表示相应的权限还没有被授予

参考：[关于Linux下s、t、i、a权限](https://www.cnblogs.com/qlqwjy/p/8665871.html)

### 特殊权限

- SetUID（4）

  针对文件所述用户（user）设置s权限，数字表示为4

当一个可执行程序具有SetUID权限，用户执行这个程序时，将以程序所有者的身份执行。前提是这个文件是可执行文件，即具有x权限(属组必须先设置相应的x权限)。chmod命令不进行必要的完整性检查，即使没有x权限就设置s权限，chmod也不会报错，当我们ls -l时看到rwS，**大写S说明s权限未生效**）

设置s权限：

`chmod u+s xxx`

`chmod 4777 xxx`  SetUID的权限位是4，因此可以用chmod 4777 xxx设置s权限

回收s权限：

`chmod u-s xxx`

`chmod 0777 xxx`

- SetGID（2）

  一个可执行文件具有SetGID权限表示运行这个程序的时候是以这个程序的所属组的身份运行，同样这个文件所属组需要具有x权限(必须可以运行)

  设置权限方法:

  　　`chmod g+s xxx`

  　　chmod 2777 xxx

  收回权限方法:

  　　`chmod g-s xxx`

  　　`chmod 0777 xxx`
- 黏着位 t (1)

针对others设置，可以实现文件夹共享

设置粘着位，一般针对权限是777的文件夹设置权限。如果文件设置了t权限则只有属主和root有删除文件的权限(没有意义)

如果权限为777的目录设置t权限，索引用户可以在这个目录下面创建文件和删除自己创建的文件，删除其他人创建的文件权限不被允许(当然root可以删除所有人创建的权限)。(为了共享目录，例如临时文件夹)

设置权限：

　　`chmod o+t xxx`

　　`chmod 1777 xxx`

收回权限

　　`chmod o-t xxx`　　

　　`chmod 0777 xxx`

- i：不可修改权限

 例：chattr u+i filename 则filename文件就不可修改，无论任何人，如果需要修改需要先删除i权限，用chattr -i filename就可以了。查看文件是否设置了i权限用lsattr filename。

- a：只追加权限

 对于日志系统很好用，这个权限让目标文件只能追加，不能删除，而且不能通过编辑器追加。可以使用chattr +a设置追加权限。

## crontab

参考：[crontab命令详解 含启动/重启/停止](https://www.cnblogs.com/kenshinobiy/p/7685229.html)

linux 系统是由 cron (crond) 这个系统服务来控制的。Linux 系统上面原本就有非常多的计划性工作，因此这个系统服务是默认启动的。另外, 由于使用者自己也可以设置计划任务，所以， Linux 系统也提供了使用者控制计划任务的命令 :**crontab 命令**。

### crond简介

crond 是linux下用来周期性的执行某种任务或等待处理某些事件的一个守护进程，与windows下的计划任务类似，当安装完成操作系统后，默认会安装此服务 工具，并且会自动启动crond进程，crond进程每分钟会定期检查是否有要执行的任务，如果有要执行的任务，则自动执行该任务。

Linux下的任务调度分为两类，**系统任务调度和用户任务调度**。

#### 系统任务调度

系统周期性所要执行的工作，比如写缓存数据到硬盘、日志清理等。在/etc目录下有一个crontab文件，这个就是系统任务调度的配置文件。

/etc/crontab文件包括下面几行：

```
[root@localhost ~]# cat /etc/crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=””HOME=/
# run-parts
51 * * * * root run-parts /etc/cron.hourly
24 7 * * * root run-parts /etc/cron.daily
22 4 * * 0 root run-parts /etc/cron.weekly
42 4 1 * * root run-parts /etc/cron.monthly
```

> 前四行是用来配置crond任务运行的环境变量:
>
> 第一行SHELL变量指定了系统要使用哪个shell，这里是bash
>
> 第二行PATH变量指定了系统执行 命令的路径
>
> 第三行MAILTO变量指定了crond的任务执行信息将通过电子邮件发送给root用户，如果MAILTO变量的值为空，则表示不发送任务 执行信息给用户
>
> 第四行的HOME变量指定了在执行命令或者脚本时使用的主目录。
>
> 第六至九行表示的含义将在下个小节详细讲述。这里不在多说。

#### 用户任务调度

用户定期要执行的工作，比如用户数据备份、定时邮件提醒等。用户可以使用 crontab 工具来定制自己的计划任务。所有用户定义的crontab 文件都被保存在 /var/spool/cron目录中。其文件名与用户名一致。

使用者权限文件：
文件：
/etc/cron.deny
说明：
该文件中所列用户不允许使用crontab命令

文件：
/etc/cron.allow
说明：
该文件中所列用户允许使用crontab命令

文件：
/var/spool/cron/
说明：
所有用户crontab文件存放的目录,以用户名命名

#### crontab文件的含义

用户所建立的crontab文件中，每一行都代表一项任务，每行的每个字段代表一项设置，它的格式共分为六个字段，前五段是时间设定段，第六段是要执行的命令段，格式如下：

```
minute  hour  day  month  week  command
```

其中：

minute： 表示分钟，可以是从0到59之间的任何整数。

hour：表示小时，可以是从0到23之间的任何整数。

day：表示日期，可以是从1到31之间的任何整数。

month：表示月份，可以是从1到12之间的任何整数。

week：表示星期几，可以是从0到7之间的任何整数，这里的0或7代表星期日。

command：要执行的命令，可以是系统命令，也可以是自己编写的脚本文件。

[![《crontab命令详解 含启动/重启/停止》](image/linux学习总结/08090352-4e0aa3fe4f404b3491df384758229be1.png)](https://www.vpsrr.com/wp-content/uploads/2015/04/08090352-4e0aa3fe4f404b3491df384758229be1.png)

在以上各个字段中，还可以使用以下特殊字符：

星号（*）：代表所有可能的值，例如month字段如果是星号，则表示在满足其它字段的制约条件后每月都执行该命令操作。

逗号（,）：可以用逗号隔开的值指定一个列表范围，例如，“1,2,5,7,8,9”

中杠（-）：可以用整数之间的中杠表示一个整数范围，例如“2-6”表示“2,3,4,5,6”

正斜线（/）：可以用正斜线指定时间的间隔频率，例如“0-23/2”表示每两小时执行一次。同时正斜线可以和星号一起使用，例如*/10，如果用在minute字段，表示每十分钟执行一次。

### crond服务

安装crontab：

```
yum install crontabs
```

服务操作说明：

```
/sbin/service crond start //启动服务
/sbin/service crond stop //关闭服务
/sbin/service crond restart //重启服务
/sbin/service crond reload //重新载入配置
```

查看crontab服务状态：

```
service crond status
```

手动启动crontab服务：

```
service crond start
```

查看crontab服务是否已设置为开机启动，执行命令：

```
ntsysv
```

加入开机自动启动：

```
chkconfig –level 35 crond on
```

### crontab命令详解

1．命令格式：

crontab [-u user] file

crontab [-u user] [ -e | -l | -r ]

2．命令功能：

通过crontab 命令，我们可以在固定的间隔时间执行指定的系统指令或 shell script脚本。时间间隔的单位可以是分钟、小时、日、月、周及以上的任意组合。这个命令非常设合周期性的日志分析或数据备份等工作。

3．命令参数：

-u user：用来设定某个用户的crontab服务，例如，“-u ixdba”表示设定ixdba用户的crontab服务，此参数一般有root用户来运行。

file：file是命令文件的名字,表示将file做为crontab的任务列表文件并载入crontab。如果在命令行中没有指定这个文件，crontab命令将接受标准输入（键盘）上键入的命令，并将它们载入crontab。

-e：编辑某个用户的crontab文件内容。如果不指定用户，则表示编辑当前用户的crontab文件。

-l：显示某个用户的crontab文件内容，如果不指定用户，则表示显示当前用户的crontab文件内容。

-r：从/var/spool/cron目录中删除某个用户的crontab文件，如果不指定用户，则默认删除当前用户的crontab文件。

-i：在删除用户的crontab文件时给确认提示。

4．常用方法：

1). 创建一个新的crontab文件

在 考虑向cron进程提交一个crontab文件之前，首先要做的一件事情就是设置环境变量EDITOR。cron进程根据它来确定使用哪个编辑器编辑 crontab文件。9 9 %的UNIX和LINUX用户都使用vi，如果你也是这样，那么你就编辑$ HOME目录下的. profile文件，在其 中加入这样一行：

EDITOR=vi; export EDITOR

然后保存并退出。不妨创建一个名为 `<user>` cron的文件，其中 `<user>`是用户名，例如， davecron。在该文件中加入如下的内容。

\# (put your own initials here)echo the date to the console every

\# 15minutes between 6pm and 6am

0,15,30,45 18-06 * * * /bin/echo ‘date’ > /dev/console

保存并退出。确信前面5个域用空格分隔。

在上面的例子中，系统将每隔15分钟向控制台输出一次当前时间。如果系统崩溃或挂起，从最后所显示的时间就可以一眼看出系统是什么时间停止工作的。在有些系统中，用tty1来表示控制台，可以根据实际情况对上面的例子进行相应的修改。为了提交你刚刚创建的crontab文件，可以把这个新创建的文件作为 cron命令的参数：

$ crontab davecron

现在该文件已经提交给cron进程，它将每隔1 5分钟运行一次。

同时，新创建文件的一个副本已经被放在/var/spool/cron目录中，文件名就是用户名(即dave)。

2). 列出crontab文件

为了列出crontab文件，可以用：

$ crontab -l

0,15,30,45,18-06 * * * /bin/echo `date` > dev/tty1

你将会看到和上面类似的内容。可以使用这种方法在$ H O M E目录中对crontab文件做一备份：

$ crontab -l > $HOME/mycron

这样，一旦不小心误删了crontab文件，可以用上一节所讲述的方法迅速恢复。

3). 编辑crontab文件

如果希望添加、删除或编辑crontab文件中的条目，而E D I TO R环境变量又设置为v i，那么就可以用v i来编辑crontab文件，相应的命令为：

$ crontab -e

可以像使用v i编辑其他任何文件那样修改crontab文件并退出。如果修改了某些条目或添加了新的条目，那么在保存该文件时， c r o n会对其进行必要的完整性检查。如果其中的某个域出现了超出允许范围的值，它会提示你。

我们在编辑crontab文件时，没准会加入新的条目。例如，加入下面的一条：

\# DT:delete core files,at 3.30am on 1,7,14,21,26,26 days of each month

30 3 1,7,14,21,26 * * /bin/find -name “core’ -exec rm {} \;

现在保存并退出。最好在crontab文件的每一个条目之上加入一条注释，这样就可以知道它的功能、运行时间，更为重要的是，知道这是哪位用户的作业。

现在让我们使用前面讲过的crontab -l命令列出它的全部信息：

$ crontab -l

\# (crondave installed on Tue May 4 13:07:43 1999)

\# DT:ech the date to the console every 30 minites

0,15,30,45 18-06 * * * /bin/echo `date` > /dev/tty1

\# DT:delete core files,at 3.30am on 1,7,14,21,26,26 days of each month

30 3 1,7,14,21,26 * * /bin/find -name “core’ -exec rm {} \;

4). 删除crontab文件

要删除crontab文件，可以用：

$ crontab -r

5). 恢复丢失的crontab文件

如果不小心误删了crontab文件，假设你在自己的$ H O M E目录下还有一个备份，那么可以将其拷贝到/var/spool/cron/`<username>`，其中 `<username>`是用户名。如果由于权限问题无法完成拷贝，可以用：

$ crontab `<filename>`

其中，`<filename>`是你在$ H O M E目录中副本的文件名。

我建议你在自己的$ H O M E目录中保存一个该文件的副本。我就有过类似的经历，有数次误删了crontab文件（因为r键紧挨在e键的右边）。这就是为什么有些系统文档建议不要直接编辑crontab文件，而是编辑该文件的一个副本，然后重新提交新的文件。

有些crontab的变体有些怪异，所以在使用crontab命令时要格外小心。如果遗漏了任何选项，crontab可能会打开一个空文件，或者看起来像是个空文件。这时敲delete键退出，不要按 `<Ctrl-D>`，否则你将丢失crontab文件。

5．使用实例

```
* * * * * command              // 每1分钟执行一次command
3,15 * * * * command           // 每小时的第3和第15分钟执行
3,15 8-11 * * * command        // 在上午8点到11点的第3和第15分钟执行
3,15 8-11 */2 * * command      // 每隔两天的上午8点到11点的第3和第15分钟执行
3,15 8-11 * * 1 command        // 每个星期一的上午8点到11点的第3和第15分钟执行
30 21 * * * /etc/init.d/smb restart           // 每晚的21:30重启smb 
45 4 1,10,22 * * /etc/init.d/smb restart      // 每月1、10、22日的4 : 45重启smb 
10 1 * * 6,0 /etc/init.d/smb restart          // 每周六、周日的1 : 10重启smb
0,30 18-23 * * * /etc/init.d/smb restart      // 每天18 : 00至23 : 00之间每隔30分钟重启smb 
0 23 * * 6 /etc/init.d/smb restart            // 每星期六的晚上11 : 00 pm重启smb 
* */1 * * * /etc/init.d/smb restart           // 每一小时重启smb 
* 23-7/1 * * * /etc/init.d/smb restart        // 晚上11点到早上7点之间，每隔一小时重启smb 
0 11 4 * mon-wed /etc/init.d/smb restart      // 每月的4号与每周一到周三的11点重启smb 
0 4 1 jan * /etc/init.d/smb restart           // 一月一号的4点重启smb 
01 * * * * root run-parts /etc/cron.hourly    // 每小时执行/etc/cron.hourly目录内的脚本,run-parts这个参数了，如果去掉这个参数的话，后面就可以写要运行的某个脚本名，而不是目录名了
```

### 使用注意事项

1. 注意环境变量问题

有时我们创建了一个crontab，但是这个任务却无法自动执行，而手动执行这个任务却没有问题，这种情况一般是由于在crontab文件中没有配置环境变量引起的。

在 crontab文件中定义多个调度任务时，需要特别注意的一个问题就是环境变量的设置，因为我们手动执行某个任务时，是在当前shell环境下进行的，程 序当然能找到环境变量，而系统自动执行任务调度时，是不会加载任何环境变量的，因此，就需要在crontab文件中指定任务运行所需的所有环境变量，这 样，系统执行任务调度时就没有问题了。

不要假定cron知道所需要的特殊环境，它其实并不知道。所以你要保证在shelll脚本中提供所有必要的路径和环境变量，除了一些自动设置的全局变量。所以注意如下3点：

1）脚本中涉及文件路径时写全局路径；

2）脚本执行要用到java或其他环境变量时，通过source命令引入环境变量，如：

cat start_cbp.sh

\#!/bin/sh

source /etc/profile

export RUN_CONF=/home/d139/conf/platform/cbp/cbp_jboss.conf

/usr/local/jboss-4.0.5/bin/run.sh -c mev &

3）当手动执行脚本OK，但是crontab死活不执行时。这时必须大胆怀疑是环境变量惹的祸，并可以尝试在crontab中直接引入环境变量解决问题。如：

0 * * * * . /etc/profile;/bin/sh /var/www/java/audit_no_count/bin/restart_audit.sh

1. 注意清理系统用户的邮件日志

每条任务调度执行完毕，系统都会将任务输出信息通过电子邮件的形式发送给当前系统用户，这样日积月累，日志信息会非常大，可能会影响系统的正常运行，因此，将每条任务进行重定向处理非常重要。

例如，可以在crontab文件中设置如下形式，忽略日志输出：

0 */3 * * * /usr/local/apache2/apachectl restart >/dev/null 2>&1

“/dev/null 2>&1”表示先将标准输出重定向到/dev/null，然后将标准错误重定向到标准输出，由于标准输出已经重定向到了/dev/null，因此标准错误也会重定向到/dev/null，这样日志输出问题就解决了。

1. 系统级任务调度与用户级任务调度

系 统级任务调度主要完成系统的一些维护操作，用户级任务调度主要完成用户自定义的一些任务，可以将用户级任务调度放到系统级任务调度来完成（不建议这么 做），但是反过来却不行，root用户的任务调度操作可以通过“crontab –uroot –e”来设置，也可以将调度任务直接写入/etc /crontab文件，需要注意的是，如果要定义一个定时重启系统的任务，就必须将任务放到/etc/crontab文件，即使在root用户下创建一个 定时重启系统的任务也是无效的。

1. 其他注意事项

新创建的cron job，不会马上执行，至少要过2分钟才执行。如果重启cron则马上执行。

当crontab突然失效时，可以尝试/etc/init.d/crond restart解决问题。或者查看日志看某个job有没有执行/报错tail -f /var/log/cron。

千万别乱运行crontab -r。它从Crontab目录（/var/spool/cron）中删除用户的Crontab文件。删除了该用户的所有crontab都没了。

在crontab中%是有特殊含义的，表示换行的意思。如果要用的话必须进行转义\%，如经常用的date ‘+%Y%m%d’在crontab里是不会执行的，应该换成date ‘+\%Y\%m\%d’。

## df

df命令用于显示磁盘分区上的可使用的磁盘空间。默认显示单位为KB。可以利用该命令来获取硬盘被占用了多少空间，目前还剩下多少空间等信息。

### 语法

df(选项)(参数)

### 选项

-a或--all：包含全部的文件系统；
--block-size=<区块大小>：以指定的区块大小来显示区块数目；
-h或--human-readable：以可读性较高的方式来显示信息；
-H或--si：与-h参数相同，但在计算时是以1000 Bytes为换算单位而非1024 Bytes；
-i或--inodes：显示inode的信息；
-k或--kilobytes：指定区块大小为1024字节；
-l或--local：仅显示本地端的文件系统；
-m或--megabytes：指定区块大小为1048576字节；
--no-sync：在取得磁盘使用信息前，不要执行sync指令，此为预设值；
-P或--portability：使用POSIX的输出格式；
--sync：在取得磁盘使用信息前，先执行sync指令；
-t<文件系统类型>或--type=<文件系统类型>：仅显示指定文件系统类型的磁盘信息；
-T或--print-type：显示文件系统的类型；
-x<文件系统类型>或--exclude-type=<文件系统类型>：不要显示指定文件系统类型的磁盘信息；
--help：显示帮助；
--version：显示版本信息。

#### 参数

文件：指定文件系统上的文件。

#### 实例

查看系统磁盘设备，默认是KB为单位：

```
[root@LinServ-1 ~]# df
文件系统             1K-块          已用     可用           已用%   挂载点
/dev/sda2            146294492    28244432  110498708     21%     /
/dev/sda1            1019208      62360     904240        7%      /boot
tmpfs                1032204      0         1032204       0%      /dev/shm
/dev/sdb1            2884284108   218826068 2518944764    8%      /data1
```

使用-h选项以KB以上的单位来显示，可读性高：

```
[root@LinServ-1 ~]# df -h
文件系统              容量  已用 可用 已用% 挂载点
/dev/sda2             140G   27G  106G  21% /
/dev/sda1             996M   61M  884M   7% /boot
tmpfs                1009M     0 1009M   0% /dev/shm
/dev/sdb1             2.7T  209G  2.4T   8% /data1
```

查看全部文件系统：

```
[root@LinServ-1 ~]# df -a
文件系统               1K-块        已用     可用   已用%    挂载点
/dev/sda2            146294492  28244432 110498708  21% /
proc                         0         0         0   -  /proc
sysfs                        0         0         0   -  /sys
devpts                       0         0         0   -  /dev/pts
/dev/sda1              1019208     62360    904240   7%   /boot
tmpfs                  1032204         0   1032204   0%   /dev/shm
/dev/sdb1            2884284108 218826068 2518944764 8%   /data1
none                         0         0         0   -    /proc/sys/fs/binfmt_misc
```

## dirname

获取父目录

```bash
cd $(dirname `which python3`) # 查找Python3的所在目录，通过dirname找到父目录，并进入该目录，反引号嵌套后有问题，使用$()等价替换外层的反引号
```

## du

disk usage

```

du -sh   # 查看指定目录的大小，无参的情况下，表示查看当前目录的磁盘占用，-s表示仅显示总计
du -h -d 1 ~/repo/rv1106/project/ #-d 与 -s 不能共同使用。 -s 显示总计大小，而 -d 指定递归的深度。

du -h -d 1 . | sort -n  -r  # 结合sort 对结果排序  -n -r逆序输出
668K    ./tests
100K    ./rockchip-conf
96M     .
76K     ./.github
57M     ./demos
15M     ./src
11M     ./examples
6.4M    ./scripts
4.8M    ./env_support
1.6M    ./docs

du -a /path/to/directory # 递归显示每个文件的大小，如果不使用 -a 参数，du 命令默认只显示目录的大小总计，而不显示每个文件的大小。
```

## dmesg

dmesg指令是一个在Linux系统中查看内核日志的实用工具。它允许我们查看系统内核的输出消息，包括引导信息、硬件检测、设备驱动程序和系统错误等。通过使用dmesg指令，我们可以追踪系统启动过程中的事件，排查故障和问题.

## `dmesg`

## echo

```
# 将文本重定向写入某个文件
echo “hello world！” > myfile.txt
# 命令自动输入y，如下在执行demo.sh过程中需要输入y
echo y | demo.sh
```

## find

```shell
find -maxdepth=1 -type d -mtime +15 # 查看深度为1 查找类型为文件夹 切为15天之前的文件夹，maxdepth指定最大遍历深度

find . -name *.sh | xargs git update-index --chmod=+z # 给所有的shell脚本添加执行权限
# xargs 是一个强有力的命令，它能够捕获一个命令的输出，然后传递给另外一个命令，一般结合管道符使用，应对不支持|管道来传递参数的一些命令的传参

find `pwd` # 展示当前目录下所有文件，使用绝对路径
# 通过上面两个命令的执行可以发现，find 命令是将路径与发现的文件逐一拼接返回结果
```

> -iname 忽略大小写搜索

```
find｛路径｝-type f  # 展示某个目录下所有文件，｛路径｝参数拼接目录下的文件路径并返回
find . # 展示当前目录下所有文件，使用相对路径
```

> 增加 -type f参数可以可以过滤掉目录，设备等，只保留文件

```
find / -perm 4755 -o -perm 2755  #跟据权限查看，-o表示or，4代表SetUID，2代表SetGID
find . -type f -size +500M # 查找超过500M的文件
find . -type f -exec du -h {} + | sort -r -h # 查看所有文件，并按文件大小排序
```

排除某些目录

```
find . -type f ! -path "./.git/*" -exec du -h {} + | sort -r -h |head -100
```

## free

free命令可以显示当前系统未使用的和已使用的内存数目，还可以显示被内核使用的内存缓冲区。

#### 语法

free(选项)

#### 选项

-b：以Byte为单位显示内存使用情况；
-k：以KB为单位显示内存使用情况；
-m：以MB为单位显示内存使用情况；
-o：不显示缓冲区调节列；
-s<间隔秒数>：持续观察内存使用状况；
-t：显示内存总和列；
-V：显示版本信息。

#### 实例

```
jihan@ubuntu:~/repo/rv1106_IR/project$ free -m
              total        used        free      shared  buff/cache   available
Mem:           6417        2593         418           0        3406        3557
Swap:          2047          48        1999
```

第一部分Mem行解释：

total：内存总数；
used：已经使用的内存数；
free：空闲的内存数；
shared：当前已经废弃不用；
buffers Buffer：缓存内存数；
cached Page：缓存内存数。
关系：total = used + free

第二部分(-/+ buffers/cache)解释:

(-buffers/cache) used内存数：第一部分Mem行中的 used – buffers – cached
(+buffers/cache) free内存数: 第一部分Mem行中的 free + buffers + cached
可见-buffers/cache反映的是被程序实实在在吃掉的内存，而+buffers/cache反映的是可以挪用的内存总数。

第三部分是指交换分区。

#### 实例

```
[root@cp31 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:          15876        2323        5996         772        7556       11908
Swap:          8063           0        8063
```

## grep

```sh
grep -E '123|abc' filename # 找出文件中包含123或abc的行， -E表示使用正则表达式搜索
awk '/123|abc' filename # 找出文件中包含123或abc的行
egrep '123|abc' filename # 找出文件中包含123或abc的行
grep "keyword" -rl target_dir # 目录中搜索关键字，只展示包含关键字的文件名（-l参数）
# 在某个目录下递归查找替换指定字符串，使用grep查找关键字所在的文件，sed进行替换
sed -i "s/目标字符串/用于替换的字符串/g" `grep "目标字符串" -rl 目录`
grep -m num -rn "string" # 只匹配前m个命中结果

# 显示命中结果的上下行范围
grep -C 5 foo file 显示file文件里匹配foo字串那行以及上下5行
grep -B 5 foo file 显示foo及前5行
grep -A 5 foo file 显示foo及后5行
grep ^$ # 可以匹配开头结尾
```

> -m 指定最大匹配次数

## head

```
# 查看前几行，如下查看前一行
head -n 1
head -1 
```

## id

```
id # 查看用户id 组id 用户组信息
```

## iptables

iptables命令是Linux上常用的防火墙软件，是netfilter项目的一部分。可以直接配置，也可以通过许多前端和图形界面配置。

#### 语法

iptables -t 表名 <-A/I/D/R> 规则链名 [规则号] <-i/o 网卡名> -p 协议名 <-s 源IP/源子网> --sport 源端口 <-d 目标IP/目标子网> --dport 目标端口 -j 动作

#### 选项

-t<表>：指定要操纵的表；
-A：向规则链中添加条目；
-D：从规则链中删除条目；
-i：向规则链中插入条目；
-R：替换规则链中的条目；
-L：显示规则链中已有的条目；
-F：清除规则链中已有的条目；
-Z：清空规则链中的数据包计算器和字节计数器；
-N：创建新的用户自定义规则链；
-P：定义规则链中的默认目标；
-h：显示帮助信息；
-p：指定要匹配的数据包协议类型；
-s：指定要匹配的数据包源ip地址；
-j<目标>：指定要跳转的目标；
-i<网络接口>：指定数据包进入本机的网络接口；
-o<网络接口>：指定数据包要离开本机所使用的网络接口。

**表名：**

* raw：用于高级功能，如网址过滤。
* mangle：用于实现服务质量的数据包修改（QoS）。
* net：用于地址转换，常用于网关路由器。
* filter：用于防火墙规则的包过滤。

**规则链名：**

* INPUT链：处理输入数据包。
* OUTPUT链：处理输出数据包。
* FORWARD链：处理转发数据包。
* PREROUTING链：用于目标地址转换（DNAT）。
* POSTROUTING链：用于源地址转换（SNAT）。

**动作：**

* accept：接收数据包。
* DROP：丢弃数据包。
* REDIRECT：重定向、映射、透明代理。
* SNAT：源地址转换。
* DNAT：目标地址转换。
* MASQUERADE：用于ADSL的IP伪装（NAT）。
* LOG：日志记录。

#### 实例

##### 清除已有iptables规则

```
iptables -F
iptables -X
iptables -Z
```

##### 开放指定的端口

```
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT               #允许本地回环接口(即运行本机访问本机)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT    #允许已建立的或相关连的通行
iptables -A OUTPUT -j ACCEPT         #允许所有本机向外的访问
iptables -A INPUT -p tcp --dport 22 -j ACCEPT    #允许访问22端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT    #允许访问80端口
iptables -A INPUT -p tcp --dport 21 -j ACCEPT    #允许ftp服务的21端口
iptables -A INPUT -p tcp --dport 20 -j ACCEPT    #允许FTP服务的20端口
iptables -A INPUT -j reject       #禁止其他未允许的规则访问
iptables -A FORWARD -j REJECT     #禁止其他未允许的规则访问
```

##### 屏蔽IP

iptables -I INPUT -s 123.45.6.7 -j DROP #屏蔽单个IP的命令
iptables -I INPUT -s 123.0.0.0/8 -j DROP #封整个段即从123.0.0.1到123.255.255.254的命令
iptables -I INPUT -s 124.45.0.0/16 -j DROP #封IP段即从123.45.0.1到123.45.255.254的命令
iptables -I INPUT -s 123.45.6.0/24 -j DROP #封IP段即从123.45.6.1到123.45.6.254的命令是

##### 查看已添加的iptables规则

iptables -L -n -v

Chain INPUT (policy DROP 48106 packets, 2690K bytes)
pkts bytes target prot opt in out source destination
5075 589K ACCEPT all -- lo * 0.0.0.0/0 0.0.0.0/0
191K 90M ACCEPT tcp -- * * 0.0.0.0/0 0.0.0.0/0 tcp dpt:22
1499K 133M ACCEPT tcp -- * * 0.0.0.0/0 0.0.0.0/0 tcp dpt:80
4364K 6351M ACCEPT all -- * * 0.0.0.0/0 0.0.0.0/0 state RELATED,ESTABLISHED
6256 327K ACCEPT icmp -- * * 0.0.0.0/0 0.0.0.0/0

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
pkts bytes target prot opt in out source destination

Chain OUTPUT (policy ACCEPT 3382K packets, 1819M bytes)
pkts bytes target prot opt in out source destination
5075 589K ACCEPT all -- * lo 0.0.0.0/0 0.0.0.0/0

##### 删除已添加的iptables规则

将所有iptables以序号标记显示，执行：

```
iptables -L -n --line-numbers
```

比如要删除INPUT里序号为8的规则，执行：

```
iptables -D INPUT 8
```

## kill

同类的还有pkill（与killall类似）、killall（killall 命令用于杀死指定名字的进程）命令，不需要查询进程id，可根据关键字杀死进程。

```
kill -9 <pid> # 杀掉进程
```

> kill就是给某个进程id发送了一个信号。默认发送的信号是SIGTERM，而kill -9发送的信号是SIGKILL，即exit。exit信号不会被系统阻塞，所以kill -9能顺利杀掉进程。当然你也可以使用kill发送其他信号给进程。

## last

查看用户登录日志 last

```
jihan@ubuntu:~/repo/rv1106_IR/project$ last
jihan    tty1                          Wed Dec 13 21:22   still logged in
reboot   system boot  5.4.0-84-generic Wed Dec 13 21:22   still running
jihan    pts/4        192.168.206.1    Tue Dec  5 18:44 - 18:44  (00:00)
jihan    pts/4        192.168.206.1    Tue Dec  5 18:43 - 18:43  (00:00)
jihan    pts/4        192.168.206.1    Tue Dec  5 18:43 - 18:43  (00:00)
jihan    tty1                          Tue Dec  5 18:08 - crash (8+03:14)
reboot   system boot  5.4.0-84-generic Tue Dec  5 18:07   still running

wtmp begins Tue Dec  5 18:05:47 2023
```

## ln

link files, 命令是一个非常重要命令，它的功能是为某一个文件在另外一个位置建立一个同步的链接。

```sh
ln -s log2013.log link2013 # 给log2013.log创建一个软连接 link2013
# lrwxrwxrwx 1 root root     11 12-07 16:01 link2013 -> log2013.log
```

> -s 软链接(符号链接)

## ls/ll

```sh
# 当前目录下查看所有文件（包括隐藏的文件）
ls -a
ll -a
# 在ls中列出文件的绝对路径
ls | sed "s:^:`pwd`/:"                 # 就是在每行记录的开头加上当前路径
find  $PWD -maxdepth 1  | xargs ls -ld # 列出当前目录下的所有文件（包括隐藏文件）的绝对路径， 对目录不做递归
find  $PWD | xargs ls -ld              # 递归列出当前目录下的所有文件（包括隐藏文件）的绝对路径
ls -d */  #显示目录下所有的文件夹名
```

> ll 命令相当于 `ls -l`
>
> -t 按修改时间排序

## lsb_release

```
lsb_release -a # 查看发行版本信息
```

## more

more 命令类似 cat ，不过会以一页一页的形式显示，更方便使用者逐页阅读，而最基本的指令就是按空白键（space）就往下一页显示，按 b 键就会往回（back）一页显示，而且还有搜寻字串的功能（与 vi 相似），使用中的说明文件，请按 h 。

## mount

* mount [-l|-h|-V]
* mount -a [-fFnrsvw] [-t fstype] [-O optlist]
* mount [-fnrsvw] [-o options] device|dir
* mount [-fnrsvw] [-t fstype] [-o options] device dir

```
# 挂载一个设备文件到指定挂载点
mount /dev/sda1 /mnt

# 指定文件系统类型和挂载选项 
mount -t ext4 -o ro /dev/sda1 /media/usb

# 卸载一个已经挂载的文件系统
umount /mnt

# 获取mount命令的帮助信息
man mount
info mount
```

## mkdir

```shell
mkdir -p parent/file # 不加-p参数，且parent目录不存在的情况下会创建失败
mkdir -p parent/{1/{11,12,13},2/{21,22,23}}/son # 批量创建文件夹
####################
.
└── parent
    ├── 1
    │   ├── 11
    │   │   └── son
    │   ├── 12
    │   │   └── son
    │   └── 13
    │       └── son
    └── 2
        ├── 21
        │   └── son
        ├── 22
        │   └── son
        └── 23
            └── son
###################
```

> -p, --parents     需要时创建目标目录的上层目录，但即使这些目录已存在也不当作错误处理

## netstat

netstat命令用来打印Linux中网络系统的状态信息，可让你得知整个Linux系统的网络情况。

#### 语法

netstat(选项)

#### 选项

-a或--all：显示所有连线中的Socket；
-A<网络类型>或--<网络类型>：列出该网络类型连线中的相关地址；
-c或--continuous：持续列出网络状态；
-C或--cache：显示路由器配置的快取信息；
-e或--extend：显示网络其他相关信息；
-F或--fib：显示FIB；
-g或--groups：显示多重广播功能群组组员名单；
-h或--help：在线帮助；
-i或--interfaces：显示网络界面信息表单；
-l或--listening：显示监控中的服务器的Socket；
-M或--masquerade：显示伪装的网络连线；
-n或--numeric：直接使用ip地址，而不通过域名服务器；
-N或--netlink或--symbolic：显示网络硬件外围设备的符号连接名称；
-o或--timers：显示计时器；
-p或--programs：显示正在使用Socket的程序识别码和程序名称；
-r或--route：显示Routing Table；
-s或--statistice：显示网络工作信息统计表；
-t或--tcp：显示TCP传输协议的连线状况；
-u或--udp：显示UDP传输协议的连线状况；
-v或--verbose：显示指令执行过程；
-V或--version：显示版本信息；
-w或--raw：显示RAW传输协议的连线状况；
-x或--unix：此参数的效果和指定"-A unix"参数相同；
--ip或--inet：此参数的效果和指定"-A inet"参数相同。

#### 实例

列出所有端口 (包括监听和未监听的)

```
netstat -a     #列出所有端口
netstat -at    #列出所有tcp端口
netstat -au    #列出所有udp端口   
```

列出所有处于监听状态的 Sockets

```
netstat -l        #只显示监听端口
netstat -lt       #只列出所有监听 tcp 端口
netstat -lu       #只列出所有监听 udp 端口
netstat -lx       #只列出所有监听 UNIX 端口
```

显示每个协议的统计信息

```
netstat -s   显示所有端口的统计信息
netstat -st   显示TCP端口的统计信息
netstat -su   显示UDP端口的统计信息
```

在netstat输出中显示 PID 和进程名称

```
netstat -pt
```

`netstat -p`可以与其它开关一起使用，就可以添加“PID/进程名称”到netstat输出中，这样debugging的时候可以很方便的发现特定端口运行的程序。

在netstat输出中不显示主机，端口和用户名(host, port or user)

当你不想让主机，端口和用户名显示，使用netstat -n。将会使用数字代替那些名称。同样可以加速输出，因为不用进行比对查询。

```
netstat -an
```

如果只是不想让这三个名称中的一个被显示，使用以下命令:

```
netsat -a --numeric-ports
netsat -a --numeric-hosts
netsat -a --numeric-users
```

持续输出netstat信息

```
netstat -c   #每隔一秒输出网络信息
```

显示系统不支持的地址族(Address Families)

```
netstat --verbose
```

在输出的末尾，会有如下的信息：

```
netstat: no support for `AF IPX' on this system.
netstat: no support for `AF AX25' on this system.
netstat: no support for `AF X25' on this system.
netstat: no support for `AF NETROM' on this system.
```

显示核心路由信息

netstat -r
使用netstat -rn显示数字格式，不查询主机名称。

找出程序运行的端口

并不是所有的进程都能找到，没有权限的会不显示，使用 root 权限查看所有的信息。

```
netstat -ap | grep ssh
```

找出运行在指定端口的进程：

```
netstat -an | grep ':80'
```

显示网络接口列表

```
netstat -i
```

显示详细信息，像是ifconfig使用 `netstat -ie`。

IP和TCP分析

查看连接某服务端口最多的的IP地址：

```
netstat -ntu | grep :80 | awk '{print $5}' | cut -d: -f1 | awk '{++ip[$1]} END {for(i in ip) print ip[i],"\t",i}' | sort -nr
```

TCP各种状态列表：

```
netstat -nt | grep -e 127.0.0.1 -e 0.0.0.0 -e ::: -v | awk '/^tcp/ {++state[$NF]} END {for(i in state) print i,"\t",state[i]}'
```

查看phpcgi进程数，如果接近预设值，说明不够用，需要增加：

```
netstat -anpo | grep "php-cgi" | wc -l
```

## ps（Process Status）

其他进程命令：htop(可视化)、pstree显示进程间的继承关系

```
ps -ef |grep redis # 查找进程并筛选出有redis字样的进程
```

> - -e 列出所有的进程
> - -f 以完整的格式输出，常与 -e 一起使用
> - -au 显示较详细的资讯
> - -aux 显示所有包含其他使用者的行程
> - au(x) 输出格式 :

## pwd

```
# 当前目录
$PWD   # 或者pwd
# 上级目录
dirname "$PWD"
# 获取当前所在文件夹名
basename "$PWD" # 或者 basename `pwd`
```

## passwd

```
sudo passwd user_name # root修改普通用户密码，后面输入密码确认即可
passwd root # 修改、设置root密码
```

## pstree

pstree命令以树状图的方式展现进程之间的派生关系，显示效果比较直观。

```
pstree  # 查看进程树
pstree -p # 查看进程树，并打印每个进程的PID
pstree -p <PID> # 查看某个进程树形结构
pstree  -a  # 显示所有进程的所有详细信息
```

## read

语法

```
read [-ers][-a aname][-d delim][-i text][-n nchars][-N nchars][-p prompt][-t timeout][-u fd][name ...]
```

参数说明

- -s 安静模式，在输入字符时不再屏幕上显示，例如login时输入密码。
- -p 后面跟提示信息，即在输入前打印提示信息。

eg：

```
read -p "请输入域账号：" userNanme
read -sp "请输入密码："  password # 安静模式，命令行输入时不会显示明文密码。
```

## realpath

```
realpath filename # 查看文件的绝对路径
ls | xargs realpath # 显示当前目录下所有文件绝对路径
```

## rm

反选删除文件：`rm -rf ` !(file1 | file2)

> -r 表示遇到文件夹递归删除, -f表示强制删除, 命令表示表示删除当前目录下除了file1 和file2的所有文件

## rmdir

```
# 删除空目录
rmdir `find -type d -maxdepth 1 -empty`
```

## rsync

- `--exclude-from`  排除指定文件

  在以下示例中，不会传输文件 `src_directory/file.txt`：

  ```
  rsync -a --exclude 'file.txt' src_directory/ dst_directory/
  ```
- `--exclude`  排除指定目录

  1. 只需将目录的相对路径传递给 `--exclude`选项，如下所示：

     ```
     rsync -a --exclude 'dir1' src_directory/ dst_directory/
     ```

     如果要排除目录内容，但不排除目录本身，请使用 `dir1/*`而不是 `dir1`：

     ```
     rsync -a --exclude 'dir1/*' src_directory/ dst_directory/
     ```
  2. 排除多个文件或目录，只需指定多个 `--exclude`选项:

     ```
     rsync -a --exclude 'file1.txt' --exclude 'dir1/*' --exclude 'dir2' src_directory/ dst_directory/
     ```

     如果您想使用单个 `--exclude`选项，则可以用大括号 `{}`列出要排除的文件和目录，用逗号分隔，如下所示：

     ```
     rsync -a --exclude={'file1.txt','dir1/*','dir2'} src_directory/ dst_directory/
     ```

     如果要排除的文件和/或目录数量很大，则可以使用多个 `--exclude`选项来指定要排除在文件中的文件和目录，然后将文件传递给 `--exclude-from`选项。

     下面的命令与上面的命令完全相同：

     ```
     rsync -a --exclude-from='exclude-file.txt' src_directory/ dst_directory/
     ```

     exclude-file.txt 文件内如如下:

     ```
     file1.txt
     dir1/*
     dir2
     ```
  3. 根据模式排除多个文件或目录

     借助rsync，还可以根据与文件或目录名称匹配的模式排除文件和目录。

     例如，要排除所有 `.jpg`个文件，您可以运行：

     ```bash
     rsync -a --exclude '*.jpg*' src_directory/ dst_directory/
     ```

     排除那些与特定模式匹配的文件和目录之外的所有其他文件和目录并不困难。假设您要排除所有其他文件和目录，但以 `.jpg`结尾的文件除外。

     一种选择是使用以下命令：

     ```bash
     rsync -a -m --include='*.jpg' --include='*/' --exclude='*' src_directory/ dst_directory/
     ```

     使用多个包含/排除选项时，将应用第一个匹配规则。

     - `--include='*.jpg'`-首先，我们包括所有 `.jpg`文件。
     - `--include='*/'` -然后，我们将所有目录都包含在 `src_directory`目录中。没有这个rsync，只会在顶层目录中复制 `*.jpg`个文件。
     - `-m` -删除空目录。

     另一个选择是将[Find命令](https://www.myfreax.com/how-to-find-files-in-linux-using-the-command-line/)的输出传递给rsync：

     ```bash
     find src_directory/ -name "*.jpg" -printf %P\\0\\n | rsync -a --files-from=- src_directory/ dst_directory/
     ```

     - `-printf %P\\0\\n`  从文件路径中删除 `src_directory/`。
     - `--files-from=-`  表示仅包含来自标准输入的文件（从find命令传递的文件）。

# service

```
service --status-all
 [ + ]  acpid
 [ - ]  alsa-utils
 [ - ]  anacron
 [ + ]  apparmor
 [ + ]  apport
 [ + ]  avahi-daemon
 [ - ]  bluetooth
 [ - ]  console-setup.sh
 [ + ]  cron
 [ + ]  cups
 [ + ]  cups-browsed
 [ + ]  dbus
 [ - ]  dns-clean
 [ - ]  gdm3
 [ + ]  grub-common
 [ - ]  hwclock.sh
 [ + ]  irqbalance
 [ + ]  kerneloops
 [ - ]  keyboard-setup.sh
 [ + ]  kmod
 [ + ]  network-manager
 [ + ]  networking
 [ + ]  open-vm-tools
 [ - ]  plymouth
 [ - ]  plymouth-log
 [ - ]  pppd-dns
 [ + ]  procps
 [ - ]  rsync
 [ + ]  rsyslog
 [ - ]  saned
 [ + ]  speech-dispatcher
 [ - ]  spice-vdagent
 [ + ]  ssh
 [ + ]  udev
 [ + ]  ufw
 [ + ]  unattended-upgrades
 [ - ]  uuidd
 [ + ]  whoopsie
 [ - ]  x11-common
```

## seq

生成数字序列，可用于循环

```
$ seq 5 # 生成1到该数字的序列，结果1 2 3 4 5
$ seq 3 5 # 生成3到5的序列， 3 4 5
$ seq 3 3 18 #生成3到18的序列，间隔3取值，结果 3 6 9 12 15 18，指定的增量也可以为负值，增量为0可以持续的产生输出
$ seq -s: 3 3 18 3:6:9:12:15:18      #-s后紧跟分隔符，指定分隔符为：，结果 3:6:9:12:15:18
$ seq -s' '  3 3 18 3 6 9 12 15 18   #-s后指定分隔符为空格，结果 3 6 9 12 15 18
$ seq -s* 5 | bc # 结合bc命令，生成数学表达式，通过管道传递给bc命令计算，结果是5的阶乘120
$ echo {a..g}  # seq仅适用于数字序列，echo可以生成字母序列，结果 a b c d e f g
```

## scp

```
scp -P port filename user@ip:/dirname # -P参数指定端口
```

## sed

```
sed -i '/keyword/d' `grep -rl "keyword" ./`  # 删除关键字所在行
```

## set

[参考](#参考)

## stat

显示文件的信息

可以显示访问时间、修改时间、更改时间（使用chmod、chown等）

```
root@dzh-pc:/dzh/repository/hexo-md# stat yarn.lock 
  文件：yarn.lock
  大小：50440           块：104        IO 块：4096   普通文件
设备：805h/2053d        Inode：3019600     硬链接：1
权限：(0644/-rw-r--r--)  Uid：(    0/    root)   Gid：(    0/    root)
最近访问：2021-11-16 23:08:49.324448918 +0800
最近更改：2021-07-12 01:38:27.891624388 +0800
最近改动：2021-07-12 01:38:27.891624388 +0800
创建时间：-
```

## su (switch user)

```
su root # 然后输入密码 就可以切换到root账户
```

## shutdown

```
shutdown -P now # -P 同--poweroff 关机
shutdown -h now # 现在立即关机 -h 代表 --halt 与关机相同
shutdown -r now # 现在立即重启
shutdown -r +3 # 三分钟后重启
```

## tr

转换或者删除文件中的字符。

```
cat testfile |tr a-z A-Z  # CHAR1-CHAR2 ：字符范围从 CHAR1 到 CHAR2 的指定，范围的指定以 ASCII 码的次序为基础，只能由小到大，不能由大到小。将文件testfile中的小写字母全部转换成大写字母

cat testfile | tr " " "\n" | tail -1  # 将testfile 文件内容中空格换位换行符，并取最后一行内容。
```

## tar

```
# tar -cf all.tar *.jpg
这条命令是将所有.jpg的文件打成一个名为all.tar的包。-c是表示产生新的包，-f指定包的文件名。

# tar -rf all.tar *.gif
这条命令是将所有.gif的文件增加到all.tar的包里面去。-r是表示增加文件的意思。

# tar -uf all.tar logo.gif
这条命令是更新原来tar包all.tar中logo.gif文件，-u是表示更新文件的意思。

# tar -xf all.tar
这条命令是解出all.tar包中所有文件，-x是解开的意思

# tar -tf all.tar
这条命令是列出all.tar包中所有文件，-t是列出文件的意思

# tar -zcvf sourcecode.tar.gz sourcecode
压缩sourcecode为sourcecode.tar.gz

# tar zxvf sourcecode.tar.gz
解压sourcecode.tar.gz文件

```

> 独立参数（这五个是独立的命令，压缩解压都要用到其中一个，可以和别的命令连用但只能用其中一个）：
>
> -c: 建立压缩档案
> -x：解压
> -t：查看内容
> -r：向压缩归档文件末尾追加文件
> -u：更新原压缩包中的文件
>
> 可选参数（下面的参数是根据需要在压缩或解压档案时可选的）：
>
> -z：有gzip属性的
> -j：有bz2属性的
> -Z：有compress属性的
> -v：显示所有过程
> -O：将文件解开到标准输出
>
> 必选参数：
>
> -f: 使用档案名字，切记，这个参数是最后一个参数，后面只能接档案名。

## tail

```
tail -n filename # 输出末尾n行
tail -n 5 filename # 输出末尾5行
tail -f filename #  输出最后10行内容，同时监视文件的改变，只要文件有一变化就显示出来。
tail +20 filename # 输出文件最后内容，从第20行开始到末尾
tail -v filename # -v在输出文件内容前，标识文件名
tail -q filename1 filename2 # -q在显示多个文件内容时，不显示文件名
```

查看最后一行和最后倒数第二行

```
# 查看倒数第一行
ls |tail -1
# 查看倒数第二行
ls |tail -2|head -1
```

## tee

读取标准输入，并写入到标准输出和若干文件中

```
wc -l file1.txt|tee -a file2.txt # 读取文件2的行数，打印在命令行，同时写入到文件2中
```

> -a  写入的方式为追加而不是覆盖

## test

test命令是shell环境中测试条件表达式的实用工具。

#### 语法

test(选项)

#### 选项

```
-b<文件>：如果文件为一个块特殊文件，则为真；
-c<文件>：如果文件为一个字符特殊文件，则为真；
-d<文件>：如果文件为一个目录，则为真；
-e<文件>：如果文件存在，则为真；
-f<文件>：如果文件为一个普通文件，则为真；
-g<文件>：如果设置了文件的SGID位，则为真；
-G<文件>：如果文件存在且归该组所有，则为真；
-k<文件>：如果设置了文件的粘着位，则为真；
-O<文件>：如果文件存在并且归该用户所有，则为真；
-p<文件>：如果文件为一个命名管道，则为真；
-r<文件>：如果文件可读，则为真；
-s<文件>：如果文件的长度不为零，则为真；
-S<文件>：如果文件为一个套接字特殊文件，则为真；
-u<文件>：如果设置了文件的SUID位，则为真；
-w<文件>：如果文件可写，则为真；
-x<文件>：如果文件可执行，则为真。
```

#### 实例

linux中shell编程中的test常见用法：

##### 判断表达式

```
if test     #表达式为真
if test !   #表达式为假
test 表达式1 –a 表达式2     #两个表达式都为真
test 表达式1 –o 表达式2     #两个表达式有一个为真
test 表达式1 ! 表达式2      #条件求反
```

##### 判断字符串

```
test –n 字符串    #字符串的长度非零
test –z 字符串    #字符串的长度是否为零
test 字符串1＝字符串2       #字符串是否相等，若相等返回true
test 字符串1!＝字符串2      #字符串是否不等，若不等反悔false
```

##### 判断整数

```
test 整数1 -eq 整数2    #整数相等
test 整数1 -ge 整数2    #整数1大于等于整数2
test 整数1 -gt 整数2    #整数1大于整数2
test 整数1 -le 整数2    #整数1小于等于整数2
test 整数1 -lt 整数2    #整数1小于整数2
test 整数1 -ne 整数2    #整数1不等于整数2
```

##### 判断文件

```
test File1 –ef File2    两个文件是否为同一个文件，可用于硬连接。主要判断两个文件是否指向同一个inode。
test File1 –nt File2    判断文件1是否比文件2新
test File1 –ot File2    判断文件1比是否文件2旧
test –b file   #文件是否块设备文件
test –c File   #文件并且是字符设备文件
test –d File   #文件并且是目录
test –e File   #文件是否存在 （常用）
test –f File   #文件是否为正规文件 （常用）
test –g File   #文件是否是设置了组id
test –G File   #文件属于的有效组ID
test –h File   #文件是否是一个符号链接（同-L）
test –k File   #文件是否设置了Sticky bit位
test –b File   #文件存在并且是块设备文件
test –L File   #文件是否是一个符号链接（同-h）
test –o File   #文件属于有效用户ID
test –p File   #文件是一个命名管道
test –r File   #文件是否可读
test –s File   #文件是否是非空白文件
test –t FD     #文件描述符是在一个终端打开的
test –u File   #文件存在并且设置了它的set-user-id位
test –w File   #文件是否存在并可写
test –x File   #文件属否存在并可执行
```

## time

time命令放在要执行的命令之前可以观测命令执行消耗了多长时间

```
$time seq 1000000 #
1
2
3
…
…
999998
999999
1000000
real  0m9.290s <== 9+ seconds
user  0m0.020s
sys   0m0.899s 
```

## top

top命令可以实时动态地查看系统的整体运行情况，是一个综合了多方信息监测系统性能和运行信息的实用工具。通过top命令所提供的互动式界面，用热键可以管理。

#### 语法

top(选项)

#### 选项

-b：以批处理模式操作；
-c：显示完整的治命令；
-d：屏幕刷新间隔时间；
-I：忽略失效过程；
-s：保密模式；
-S：累积模式；
-i<时间>：设置间隔时间；
-u<用户名>：指定用户名；
-p<进程号>：指定进程；
-n<次数>：循环显示的次数。

## touch

用于修改文件或者目录的时间属性，包括存取时间和更改时间，文件不存在，系统会自动创建一个新文件

## tree

```
tree -h <目录> # 查看目录树，同时打印出文件大小
```

```
tree -fi # 打印所有文件
```

> -f 为每个文件打印全路径前缀
>
> -i 不打印文件层次的缩进

## umask

当我们登录系统之后创建一个文件是会有一个默认权限的，umask就是用于设置用户创建文件或者目录的默认权限的。umask权限的设置是四位数，后三位是ugo对应的属性，首位就是特殊位权限。

```
umask 0022 # 设置权限掩码，临时
```

> [权限掩码]是由3个八进制的数字所组成，掩码置1的位没有对应的权限；chmod是设哪个位，哪么哪个位就有权限，而umask是设哪个位，则哪个位上就没权限。
>
> 文件基数为666，目录为777，即文件无设x位，目录可设x位。
>
> eg：umask一般默认022，对于文件666-022=644，默认的权限就是rw- r-- r--
>
> 对于文件夹777-022=755，默认的权限就是rwxr-xr-x

永久修改umask：

可以编辑以下文件 添加umask=022。

交互式登陆的配置生效：

`/etc/profile < /etc/profile.d/*.sh < ~/.bash_profile < ~/.bashrc </etc/bashrc` （/etc/bashrc的配置最有效 可以覆盖前面的配置）

非交互登陆的配置生效：

`~/.bashrc < /etc/bashrc  < /etc/profile.d/*.sh`

## uptime

查看系统运行时间、用户数、负载 uptime

```
[root@cp31 ~]# uptime
 18:50:33 up 98 days,  8:42,  1 user,  load average: 0.25, 0.25, 0.25
```

## w

查看活动用户

```
jihan@ubuntu:~/repo/rv1106_IR/project$ w
 22:55:07 up 8 days,  1:32,  1 user,  load average: 0.00, 0.02, 0.09
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
jihan    tty1     -                13Dec23  8days  0.06s  0.04s -bash
```

## wc

```sh
wc -l filename # 查看行数
wc -w filename # 看文件里有多少个word。
wc -L filename # 文件里最长的那一行是多少个字。
```

> -c 统计字节数。
>
> -l 统计行数。
>
> -w 统计字数

eg:

`root@dzh-pc:/dzh/repository/hexo-md# wc -lcw yarn.lock`
` 1356  2073 50440 yarn.lock`

## wget

```shell
wget --no-check-certificate  url  # --no-check-certificate不做证书验证，下载指定文件
wget -b -i xxx.txt # 批量下载xxx.txt中的文件链接，xxx.txt为要下载的链接，一行一个。
wget -c http://www.linuxde.net/testfile.zip # 继续中断的下载时可以使用-c参数。
wget [url] --proxy=no # wget 使用代理 下载超时，可以取消代理
wget --spider URL # 测试下载链接      定时下载之前进行检查、间隔检测网站是否可用、检查网站页面的死链接
```

> -b 表示后台下载
>
> -i 表示批量下载

## whoami

```
whoami # 查看当前用户名 也可以使用id -un
```

## yum命令

yum命令是在Fedora和RedHat以及SUSE中基于rpm的软件包管理器，它可以使系统管理人员交互和自动化地更细与管理RPM软件包，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软体包，无须繁琐地一次次下载、安装。

yum提供了查找、安装、删除某一个、一组甚至全部软件包的命令，而且命令简洁而又好记。

#### 语法

yum(选项)(参数)

#### 选项

-h：显示帮助信息；
-y：对所有的提问都回答“yes”；
-c：指定配置文件；
-q：安静模式；
-v：详细模式；
-d：设置调试等级（0-10）；
-e：设置错误等级（0-10）；
-R：设置yum处理一个命令的最大等待时间；
-C：完全从缓存中运行，而不去下载或者更新任何头文件。

#### 参数

install：安装rpm软件包；
update：更新rpm软件包；
check-update：检查是否有可用的更新rpm软件包；
remove：删除指定的rpm软件包；
list：显示软件包的信息；
search：检查软件包的信息；
info：显示指定的rpm软件包的描述信息和概要信息；
clean：清理yum过期的缓存；
shell：进入yum的shell提示符；
resolvedep：显示rpm软件包的依赖关系；
localinstall：安装本地的rpm软件包；
localupdate：显示本地rpm软件包进行更新；
deplist：显示rpm软件包的所有依赖关系。

#### 实例

常用的命令包括：

```
自动搜索最快镜像插件：yum install yum-fastestmirror
安装yum图形窗口插件：yum install yumex
查看可能批量安装的列表：yum grouplist
```

#### 安装

```
yum install              #全部安装
yum install package1     #安装指定的安装包package1
yum groupinsall group1   #安装程序组group1
```

#### 更新和升级

```
yum update               #全部更新
yum update package1      #更新指定程序包package1
yum check-update         #检查可更新的程序
yum upgrade package1     #升级指定程序包package1
yum groupupdate group1   #升级程序组group1
```

#### 查找和显示

```
yum info package1      #显示安装包信息package1
yum list               #显示所有已经安装和可以安装的程序包
yum list package1      #显示指定程序包安装情况package1
yum groupinfo group1   #显示程序组group1信息yum search string 根据关键字string查找安装包
```

#### 删除程序

```
yum remove <package_name>    #删除程序包
yum groupremove group1       #删除程序组group1
yum deplist package1         #查看程序package1依赖情况
```

#### 清除缓存

```
yum clean packages       #清除缓存目录下的软件包
yum clean headers        #清除缓存目录下的 headers
yum clean oldheaders     #清除缓存目录下旧的 headers
```


# linux中工具使用

## docker

### 常用命令选项

| 选项       | 说明                                                                                                                                                                                                                  |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| search，se | 搜索镜像源 `docker search image_name`                                                                                                                                                                               |
| pull       | 下载镜像 `docker pull image_name`                                                                                                                                                                                   |
| images     | 查看本地所有镜像 `docker images`                                                                                                                                                                                    |
| rmi        | 删除镜像 `docker rmi 镜像id`                                                                                                                                                                                        |
| run        | 启动容器 `docker run --name 容器名 -it 镜像id(或镜像名)  /bin/bash `<br />如果需要root登录可以使用 `--user root` 参数<br />`-i`：以交互模式运行容器<br />`-t`：为容器重新分配一个伪输入终端，通常与-i同时使用 |
| rm         | 删除容器（非运行中的）`docker rm 容器名`（或容器id，可以只写前几位如果唯一的话）                                                                                                                                    |
| stop       | 停止容器 `docker stop 容器名`                                                                                                                                                                                       |
| ps         | 查看当前运行容器列表和状态 `docker ps -a`                                                                                                                                                                           |
| start      | 启动容器 但不进入 `docker start 容器名`                                                                                                                                                                             |
| attach     | 进入容器 `docker attach 容器名`                                                                                                                                                                                     |
| rename     | 重命名容器 `docker rename 原容器名 新容器名`                                                                                                                                                                        |

### 容器与宿主机之间copy

- #### 从容器拷贝文件到宿主机

  docker cp {容器名/ID}:{容器中要拷贝的文件名及其路径} {要拷贝到宿主机里面对应的路径}

  eg:`docker cp mycontainer:/opt/testnew/file.txt /opt/test/`
- #### 从宿主机拷贝文件到容器

  docker cp 宿主机中要拷贝的文件名及其路径 容器名:要拷贝到容器里面对应的路径

  eg: `docker cp /opt/test/file.txt mycontainer:/opt/testnew/`

> 需要注意的是，不管容器有没有启动，拷贝命令都会生效。

### 批量处理镜像或容器

所有容器id：`docker ps -a -q`

所有镜像id：docker images -q

### 提交镜像

- `docker login -u {账号} {域名}:{端口}`
- docker commit 作用是提交容器副本使之成为一个新的镜像

  `docker commit {CONTAINER ID} {REPOSITORY}:{TAG}`

  eg: docker commit 05b95b04b6f5 dggecr03.his.xxxxxx.com:80/guangqi/suse12_sp5_fdk_llt1119:1.1

  > docker commit不会将你挂载的volumes一起打包到image中
  >
  > 当我们提交container为image时，container的进程会暂停以防止数据不完整等情况。想改变这种默认行为，可以使用'--pause'选项。
  >
- docker tag 标记本地镜像，将其归入某一仓库

  `docker commit {IMAGE ID} {REPOSITORY}:{TAG}`

  > {IMAGE ID}为 docker commit 后产生的新的镜像id
  >
- docker push {REPOSITORY}:{TAG}

  `docker push {REPOSITORY}:{TAG}`

### 镜像服务启停

| 命令                                                      | 说明           |
| --------------------------------------------------------- | -------------- |
| systemctl start docker                                    | 启动           |
| sudo systemctl daemon-reload                              | 重启守护进程   |
| systemctl restart docker<br />sudo service docker restart | 重启docker服务 |
| service docker stop<br />systemctl stop docker            | 关闭docker服务 |

### 查看镜像ip

 `cat /etc/hosts`

### 容器切换用户

- 首先保证容器正在运行
- 可通过sudo docker container ls或者sudo docker ps查看容器的CONTAINER ID
- 如下命令切换到root用户，更改 `-u`参数可以切换到其他用户

  `sudo docker exec -ti -u root 容器id  bash`

### 依据dockerfile生成镜像

[参考](#参考) mill

## ssh

### SSH免密登陆设置

在Windows下查看**[c盘->用户->自己的用户名->.ssh]**下是否有*"id_rsa、id_rsa.pub"*文件，如果没有需要从第一步开始手动生成,有的话直接跳到第二步。

#### 第1步：创建SSH Key

打开**Git Bash**，在控制台中输入以下命令:

```ruby
$ ssh-keygen -t rsa -C "youremail@example.com"
```

密钥类型可以用 -t 选项指定。如果没有指定则默认生成用于SSH-2的RSA密钥。这里使用的是rsa。
 同时在密钥中有一个注释字段，用-C来指定所指定的注释，可以方便用户标识这个密钥，指出密钥的用途或其他有用的信息。所以在这里输入自己的邮箱或者其他都行,当然，如果不想要这些可以直接输入：

```ruby
$ ssh-keygen
```

我一般就是这么做的。

输入完毕后按回车，程序会要求输入一个密码，输入完密码后按回车会要求再确认一次密码，如果不想要密码可以在要求输入密码的时候按两次回车，表示密码为空，并且确认密码为空，此时**[c盘>用户>自己的用户名>.ssh]**目录下已经生成好了。

#### 第2步：部署公钥

##### 版本管理仓库免密登陆

不同的版本管理代码仓库都大同小异，这里以Github举例，登录Github。打开setting->SSH keys，点击右上角 New SSH key，把**[c盘->用户->自己的用户名->.ssh]**目录下生成好的公钥*"id_rsa.pub"*文件以文本打开复制放进 key输入框中，再为当前的key起一个title来区分每个key。

##### 其他Linux设备免密登陆

实际上是将id_rsa.pub的内容放到authorized_keys文件内（没有的话就创建），注意要在对应的用户文件下放置，如下是在root用户的目录下

```
$ cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
```

##### 直接部署公钥到其他linux机器

```
ssh-copy-id -i ~/.ssh/id_rsa.pub user@ip   # 部署公钥到目标主机
```

### 用指定私钥生成公钥

```
ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub
```

## vim

### vim行跳转

- 普通模式下 gg 跳转到第一行（命令行模式下，:0 或者:1 也可以）
- 普通模式下 G跳转到行尾
- 命令行模式下，:n跳转到第n行（打开文件时 使用 `vim filename +n` 可以直接跳转到指定行）

### 显示行号

命令行模式下，`set number` 或者 `set nu`

### 删除多行

命令行模式下，输入 `32,65d`，回车键，32-65行就被删除

普通模式下输入Ndd，回车，从该行开始数N行删除

### 撤销编辑

命令行模式下输入 `u`可以恢复

### 复制粘贴

`6,9 co 12`   复制第6行到第9行之间的内容到第12行后面。

### 搜索

- 进入搜索模式：普通模式下输入 `/`
- 切换搜索结果：

  下一个，按下n(小写n)

  上一个，按下N大写N）
- 向上/向下搜索

  向下搜索：`/关键字`

  向上搜索：`？关键字`

## apt(包管理软件)

1、在虚拟机中安装vmware tools工具，方便传递文件

```
sudo apt-get install open-vm-tools-desktop
```

完成后重启，通过命令[vmware](https://so.csdn.net/so/search?q=vmware&spm=1001.2101.3001.7020)-toolbox-cmd -v 验证安装

2、下载更新软件包列表信息。运行以下命令：

```
sudo apt-get update
```

3、查找软件包

```
apt-cache search <关键字>
```

## zypper（suse管理软件包工具）

### zypper的几个重要选项

| 选项           | 说明                      |
| -------------- | ------------------------- |
| repos, lr      | 列出已定义的仓库          |
| sl             | 列出库（目的是与rug兼容） |
| addrepo, ar    | 添加库                    |
| sa             | 添加库（目的是与rug兼容） |
| renamerepo, nr | 重命名指定的安装源        |
| modifyrepo, mr | 修改指定的安装源          |
| refresh, ref   | 刷新所有安装源            |
| clean          | 清除本地缓存              |
| removerepo,rr  | 移除仓库传递              |

### zypper软件管理批

| 选项               | 说明                                                        |
| ------------------ | ----------------------------------------------------------- |
| install, in        | 安装软件包                                                  |
| remove, rm         | 删除软件包                                                  |
| verify, ve         | 检验软件包依赖关系的完整性                                  |
| update, up         | 更新已安装的软件包到新的版本                                |
| dist-upgrade, dup  | 整个系统的升级                                              |
| source-install, si | 安装源代码软件包和它们的编译依赖                            |
| info               | 查看某个软件包具体版本信息、是否安装等  zypper info package |

### zypper的查询选项

| 选项              | 说明                         |
| ----------------- | ---------------------------- |
| search, se        | 安装软件包                   |
| packages, pa      | 列出所有可用的软件包         |
| patterns, pt      | 列出所有可用的模式           |
| products, pd      | 列出所有可用的产品           |
| what-provides, wp | 列出能够提供指定功能的软件包 |

## ftp服务搭建

FTP文件传送协议(File Transfer Protocol，简称FTP)，是一个用于从一台主机到另一台主机传输文件的协议

### 安装ftp软件

**Linux下有许多FTP服务器软件**：Proftpd、Wu-FTP、vsftpd

```
# Ubuntu安装vsftp
sudo apt install vsftpd
# 查看安装版本
vsftpd --version
```

### 配置FTP服务

```
sudo useradd -m ftp_jihan # 添加用户
sudo passwd ftp_jihan #设置密码
# 在home目录下创建ftp_home文件夹
```

```
# 配置vsftpd.conf文件
sudo vim /etc/vsftpd.conf
```

再文件后面添加两行信息

local_root=/home/ftp_home  # 配置ftp登录后所在的目录

allow_writeable_chroot=YES

其他选项配置

chroot_local_user=YES

listen=YES

listen_ipv6=NO

local_enable=YES #允许本地用户登录

write_enable=YES #允许用户有修改文件权限

### 启动ftp服务

```
sudo service vsftpd start # 启动
sudo systemctl restart vsftpd # 重启
sudo /etc/init.d/vsftpd restart # 重启ftp服务
sudo systemctl enable vsftpd # 开机启动
sudo netstat -antup | grep ftp # 确认服务是否启动
```

### 登录ftp

```
ftp 192.168.137.3 # 登录ftp服务器，后面为服务器IP地址
```

### windows直接网络映射访问ftp服务器文件

打开我的电脑，鼠标右键选择“添加一个网络位置（L）”

点击下一步

点击“选择自定义网络位置”后，点击下一步

输入 ftp://[ubuntu的ip]后，点击下一步

取消勾选匿名登陆，在用户名栏输入你要登陆的用户名，点击下一步，默认选择直到完成

文件夹中看到映射的文件夹，双击输入用户名密码，就可以访问了

## ubuntu

### 关闭图形界面

```
sudo systemctl set-default multi-user.target
# 然后重启
```

### 关闭自动更新（缩短重启时间）

```
sudo dpkg-reconfigure unattended-upgrades
# 选择no并按ENTER以禁用无人参与的升级。
# 后面可以使用 sudo apt update 或 sudo apt upgrade 进行升级
```

# 参考

[shell编程教程](http://c.biancheng.net/shell/program/)

[set 命令，shopt 命令](https://github.com/duan-zhenghong/bash-tutorial/blob/master/docs/set.md)

[使用 Dockerfile 定制镜像](https://www.runoob.com/docker/docker-dockerfile.html)
