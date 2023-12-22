1. 确认开发设定的IP地址，当前固件中设置地址为：192.168.2.104
2. 对应的网卡要设置固定IP，信息如下
   IP地址：192.168.2.4（同网段即可）
   默认网关：192.168.2.1
   子网掩码：255.255.225.0
   DNS：不设置
3. 在浏览器端输入192.168.2.104，可浏览网络摄像机的web页面
4. 安装摄像头
5. 安装cp2012驱动，链接USB转ttl转接线，打开串口（波特率设置115200）可以浏览系统的相关打印。

## 简化后的编译命令

初次编译

#原始命令：`./build.sh init &&./build.sh`

`./build.sh   c  `

应用开发编译

原始命令：`./build.sh clean app && ./build.sh app && ./build.sh  firmware`

`./build.sh   app_auto c`

驱动开发编译

原始命令：`./bui d.sh clean driver &&./build.sh driver &&./build.sh irmware`

`./build.sh   dri_auto c`

## Ngnix配置

### [参考文档](https://blog.csdn.net/weixin_43239880/article/details/130841067)

### 常见配置项

user：指定运行Nginx的用户和用户组，通常为nginx。

worker_processes：指定Nginx的工作进程数，根据硬件和负载情况设置。

events：指定Nginx的工作模式和连接数限制等。

http：指定Nginx的HTTP配置项，包括静态文件服务、动态内容服务和反向代理等。

server：指定一个虚拟主机的配置，包括IP地址、端口号、访问限制等。

location：指定一个URL匹配规则，用于反向代理和重定向等。

access_log：指定访问日志的文件名和格式等。

error_log：指定错误日志的文件名和级别等。

gzip：指定是否开启Gzip压缩，以及压缩级别等。

### 配置样例

```
																																																																#####################################全局区块###################################
#user  nobody;

#nginx进程数，建议设置为等于CPU总核心数，主要影响并发处理
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

#####################################事件区块###################################
events {
    #单个进程最大连接数（最大连接数=连接数*进程数）
    #根据硬件调整，和前面工作进程配合起来用，尽量大，但是别把cpu跑到100%就行
    worker_connections  1024;
}

#####################################http区块###################################
#设定http服务器，利用它的反向代理功能提供负载均衡支持

http {
    #include：导入外部文件mime.types，将所有types提取为文件，然后导入到nginx配置文件中
    include       mime.types;
    #默认文件类型
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    #开启高效文件传输模式，sendfile指令指定nginx是否调用sendfile函数来输出文件，对于普通应用设为 on，如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络I/O处理速度，降低系统的负载。注意：如果图片显示不正常把这个改成off。
    sendfile        on;
    #tcp_nopush     on;

    #长连接超时时间，单位是秒
    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;
    #第一个Server区块开始，表示一个独立的虚拟主机站点
    server {
        # 提供服务的端口，默认80
        listen       80;
        # 提供服务的域名主机名
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;
        #对 "/" 启用反向代理,第一个location区块开始
        location / {
            root   html; #服务默认启动目录
            index  index.html index.htm; # 默认的首页文件，多个用空格分开
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html

        # 错误页面路由
        error_page   500 502 503 504  /50x.html;  # 出现对应的http状态码时，使用50x.html回应客户
        location = /50x.html { # location区块开始，访问50x.htm
            root   html;       # 指定对应的站点目录为html
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}
```

### 全局块

主要会设置一些影响nginx 服务器整体运行的配置指令，主要包括配 置运行 Nginx 服务器的用户（组）、允许生成的 worker process 数，进程 PID 存放路径、日志存放路径和类型以 及配置文件的引入等。

### events块

主要影响 Nginx 服务器与用户的网络连接，常用的设置包括是否开启对多 work process 下的网络连接进行序列化，是否 允许同时接收多个网络连接，选取哪种事件驱动模型来处理连接请求，每个 word process 可以同时支持的最大连接数等。

### http块

代理、缓存和日志定义等绝大多数功能和第三方模块的配置都在这里

### rtmp块

在Nginx中，RTMP（Real Time Messaging Protocol）配置项主要在 `rtmp_server`块中定义。以下是一些常用的RTMP配置项及其说明：

1. `listen`: 该选项指定RTMP服务器监听的端口。例如，`listen 1935;`表示RTMP服务器将监听1935端口。
2. `chunk_size`: 该选项设置每个RTMP消息的块大小。较小的块大小可以减少网络开销，但会增加协议开销。通常设置为4096或8192。例如，`chunk_size 4096;`表示每个RTMP消息的块大小为4096字节。
3. `allow`和 `deny`: 这两个选项用于控制哪些IP地址可以访问RTMP服务器。`allow`用于允许特定IP地址访问，`deny`用于拒绝特定IP地址访问。例如，`allow 192.168.0.1;`表示只允许192.168.0.1这个IP地址访问RTMP服务器。
4. `application`: 该选项定义了一个RTMP应用的名称和相关配置。每个应用都拥有自己的配置块，用于设置该应用的行为。例如：

```nginx
nginxapplication live {
    live on;
    record off;
}
```

上述配置定义了一个名为"live"的应用，该应用开启了直播流，但没有开启录制流。
5. `record`: 该选项用于指定是否录制RTMP流。例如，`record on;`表示开启录制流。你可以指定录制流的存储路径和文件名格式。例如：

```nginx
nginxrecord all;
record_path /var/www/html/recordings/%Y/%m/%d/%H/%M/%S;
record_suffix .flv;
```

上述配置将录制所有RTMP流，并将它们存储在 `/var/www/html/recordings`目录下，文件名格式为年/月/日/时/分/秒，文件后缀为.flv。
6. `hls_path`: 该选项用于指定HLS流的存储路径。例如，`hls_path /var/www/html/hls;`表示HLS流将存储在 `/var/www/html/hls`路径下。
7. `hls_fragment`: 该选项用于指定每个HLS片段的持续时间。例如，`hls_fragment 10s;`表示每个HLS片段的持续时间为10秒。
8. `hls_on_connect`: 该选项用于在客户端连接到RTMP服务器时执行的操作。例如，你可以使用该选项来设置一个特定的应用在客户端连接到RTMP服务器时自动开始录制。例如：

```nginx
nginxapplication live {
    live on;
    record on;
    hls_on_connect execute="rec_start" rec_prefix="live/";
}
```

## FastCGI

`fastcgi.cfg`是一个FastCGI的配置文件，它通常被用于设置FastCGI进程的行为。这个文件通常包括以下的一些配置项：

1. `fastcgi_param`：这个指令用于设置传递给FastCGI进程的参数。例如，`SCRIPT_FILENAME`参数可以告诉FastCGI进程如何找到要执行的脚本文件。
2. `fastcgi_root`：这个指令用于设置FastCGI进程可以访问的文件系统的路径。
3. `fastcgi_index`：这个指令用于设置在不存在默认的索引文件（如 `index.html`）时，FastCGI进程应该尝试加载的脚本文件。
4. `fastcgi_read_timeout`：这个指令用于设置FastCGI进程等待数据的时间。如果在这段时间内没有收到任何数据，FastCGI进程就会关闭连接。
5. `fastcgi_buffer_size`、`fastcgi_buffers`、`fastcgi_busy_buffers_size`：这些指令用于设置FastCGI进程接收和处理的HTTP请求的数据缓冲区的大小。

## 相关文件

### koi-utf

一种 **编码转换映射文件** ，用于在输出内容到客户端时，将一种编码转换到另一种编码。koi8-r是斯拉夫文字8位元编码，供俄语及保加利亚语使用。

### mime.types

**MIME类型定义文件** ，是一个记录所有可用MIME类型的文件 。

MIME（Multipurpose Internet Mail Extensions）是一种用于描述和标记数据类型的标准，它包括了用于电子邮件和在互联网上的所有类型数据  。mime.types是nginx配置文件之一，它用于定义MIME类型和文件扩展名之间的映系  。

### gtest测试

# web后端独立编译

安装交叉编译工具

```
apt install gcc-arm-linux-gnueabihf  #安装gcc
apt install g++-arm-linux-gnueabihf  #安装g++
 
apt install gcc-arm-linux-gnueabi
```

# 程序烧录

1、usb烧录驱动安装

2、断电情况下，长按mask按键，接入type-c电源。然后使用usb方式，能识别出来，就可以烧录

# 本地调试尝试

基于commitid：4d1cffd9938bbc71bd1daedef1829c62d66e3647

```
diff --git a/project/app/ipcweb/ipcweb-backend/cmake/toolchains/linux-arm.cmake b/project/app/ipcweb/ipcweb-backend/cmake/toolchains/linux-arm.cmake
index 3fbb00064..33794ef38 100644
--- a/project/app/ipcweb/ipcweb-backend/cmake/toolchains/linux-arm.cmake
+++ b/project/app/ipcweb/ipcweb-backend/cmake/toolchains/linux-arm.cmake
@@ -5,7 +5,8 @@ set(CMAKE_SYSTEM_PROCESSOR arm)
 set(BR2_SDK_PATH /work/linux/rk1808/buildroot/output/rockchip_puma/host)
 
 set(CMAKE_C_COMPILER   ${BR2_SDK_PATH}/bin/arm-linux-gcc)
-set(CMAKE_CXX_COMPILER ${BR2_SDK_PATH}/bin/arm-linux-g++)
+# set(CMAKE_CXX_COMPILER ${BR2_SDK_PATH}/bin/arm-linux-g++)
+set(CMAKE_CXX_COMPILER /usr/bin/arm-linux-gnueabihf-g++)
 
 set(BR2_SYSROOT ${BR2_SDK_PATH}/arm-buildroot-linux-gnueabihf/sysroot)
 set(CMAKE_SYSROOT ${BR2_SYSROOT})
diff --git a/project/app/ipcweb/ipcweb-backend/ipcweb-env-arm/etc4oem/nginx/nginx.conf b/project/app/ipcweb/ipcweb-backend/ipcweb-env-arm/etc4oem/nginx/nginx.conf
index b58a7c583..43b1c5e02 100644
--- a/project/app/ipcweb/ipcweb-backend/ipcweb-env-arm/etc4oem/nginx/nginx.conf
+++ b/project/app/ipcweb/ipcweb-backend/ipcweb-env-arm/etc4oem/nginx/nginx.conf
@@ -40,29 +40,29 @@ http {
     gzip_min_length 20;
     gzip_comp_level 5;
     gzip_vary on;
-    gzip_types text/html application/javascript application/x-javascript text/javascript image/png image/x-icon;
+    gzip_types application/javascript application/x-javascript text/javascript image/png image/x-icon;
     gzip_static on;
     gzip_buffers 2 4k;
     gzip_http_version 1.1;
 
     server {
-        listen       80;
+        listen       88;
         server_name  localhost;
 
        location /live {
-               flv_live on;
+               # flv_live on;
        }
         #charset koi8-r;
 
         #access_log  logs/host.access.log  main;
 
         location / {
-            root   /oem/usr/www;
+            root   /home/jihan/repo/rv1106_20230929/output/out/app_out/usr/www;
             index  index.html index.htm;
         }
 
        location ~* \.(mp4|bmp)$  {
-           root /oem/usr/www;
+           root /home/jihan/repo/rv1106_20230929/output/out/app_out/usr/www;
             if ($request_uri ~* view$) {
                add_header Content-Disposition inline;
            }
@@ -83,10 +83,10 @@ http {
 
         location /cgi-bin/ {
             gzip           off;
-            root           /oem/usr/www;
+            root           /home/jihan/repo/rv1106_20230929/output/out/app_out/usr/www;
             fastcgi_pass   unix:/run/fcgiwrap.sock;
             fastcgi_index  entry.cgi;
-            fastcgi_param  DOCUMENT_ROOT     /oem/usr/www/cgi-bin;
+            fastcgi_param  DOCUMENT_ROOT     /home/jihan/repo/rv1106_20230929/output/out/app_out/usr/www/cgi-bin;
             fastcgi_param  SCRIPT_NAME       /entry.cgi;
             include        fastcgi_params;
             set $path_info "";
@@ -142,22 +142,22 @@ http {
 
 }
 
-rtmp {
-    server {
-        listen 1935;
-        chunk_size 4096;
-        #allow publish 127.0.0.1;
-        #deny publish all;
-
-        application live {
-            live on;
-        }
-
-        #application hls {
-        #    live on;
-        #    hls on;
-        #    hls_path /tmp/hls;
-        #    hls_fragment 1s;
-        #}
-    }
-}
+# rtmp {
+#     server {
+#         listen 1935;
+#         chunk_size 4096;
+#         #allow publish 127.0.0.1;
+#         #deny publish all;
+
+#         application live {
+#             live on;
+#         }
+
+#         #application hls {
+#         #    live on;
+#         #    hls on;
+#         #    hls_path /tmp/hls;
+#         #    hls_fragment 1s;
+#         #}
+#     }
+# }
```
