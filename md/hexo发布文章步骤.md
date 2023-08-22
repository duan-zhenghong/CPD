---
title: hexo发布文章步骤
date: 2021-07-12 01:16:30
tags: hexo
---
# hexo发布文章步骤

- 编写完成Markdown文档

  文档头部添加如下内容，用于指定文章名称、编辑时间和标签分类：

  ```
  ---
  title: git 命令总结
  date: 2021-07-12 01:16:30
  tags:总结
  ---
  ```

- hexo server 启动本地服务器，测试本地浏览

  默认在：`http://localhost:4000`

  localhost就是当前主机的IP，如果使用的是虚拟机，可以查一下虚拟机的IP，通过宿主机中输入`http://虚拟机ip:4000`也可访问

- hexo generate 生成静态页面

  本地测试无问题，就可以生成静态页面的代码

- hexo deploy 部署

  将生成的静态页面的代码提交到库上，进行部署展示。

  > 注意：对于gitee的普通用户还需要在库上gitee pages 服务中手动点击 **更新** 才能完成最终的网页展示

