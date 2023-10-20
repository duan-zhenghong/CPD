1. 确认开发设定的IP地址，当前固件中设置地址为：192.168.2.104
2. 对应的网卡要设置固定IP，信息如下
   IP地址：192.168.2.4（同网段即可）
   默认网关：192.168.2.1
   子网掩码：255.255.225.0
   DNS：不设置
3. 在浏览器端输入192.168.2.104，可浏览网络摄像机的web页面
4. 安装摄像头
5. 安装cp2012驱动，链接USB转ttl转接线，打开串口（波特率设置115200）可以浏览系统的相关打印。

简化后的工程

![1697772317422](image/start/1697772317422.png)

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
