---
title: git 命令总结
date: 2021-07-12 01:16:30
tags: 总结
---
# git 命令总结

## 命令

### add

```
git add . // 添加所有本目录下变更的文件

// 如果要取消添加某个文件可以
git reset <file>   
```

### commit

```
git commit --amend # 修改最近提交，可以修改commit的描述信息
```

### config

```
# 关闭ssl验证,对应报错信息 SSL certificate problem：unable to get local issuer certificate
git config --global http.sslVerify false
# 保存账号密码（明文，使用https），ssh使用秘钥不需要保存密码
git config --global credential.helper store
```

#### 清理所有的账号密码

```
#取消本地缓存用户名和密码的安全策略
git config --global credential.helper wincred
# 清除缓存的用户名和密码
git credential-manager uninstall
```

使用这个命令之后,以后每次使用git都要重新输入账号密码

#### git允许保存账号密码

```
# 设置本地存储策略为保存用户名密码，这样第一次输入后就不需要输入了
git config --global credential.helper store

# 或者
# 默认十五分钟内不需要输入
git config --global credential.helper cache
```

### merge

```
# branch A上开了分支 branch B， 若修改了分支A，如何将修改的内容同步到分支B
git checkout B # 切换到B分支
git merge A # 将A合并到B分支
```

### reset

```bash
git reset --hard commitID # 强制回退道某个commitID
```

### remot

```
git remote # 查看所有远端仓
git remote -v # 查看所有远端仓地址
git remote add <远端仓名> <远端仓地址> # 增加远端仓 
git remote rm <远端仓名> # 删除远端仓
git remote set-url <远端仓名> <新的远端仓地址> # 修改远端仓地址（直接修改配置文件.git中的config文件中目标远端的url也可以修改地址） 
git remote update # jieang
```

### clean

```bash
git clean -f  # 删除指定路径下的没有被track过的文件
git clean -df #  连 untracked 的目录也一起删掉
git clean -xf # 删除当前目录下所有没有track过的文件. 不管他是否是.gitignore文件里面指定的文件夹和文件.
```

- -n  clean的演习, 告诉你哪些文件将会被删除.不会真正的删除文件, 只是一个提醒
- -f  删除当前目录下所有没有track过的文件. 他不会删除.gitignore文件里面指定的文件夹和文件, 不管这些文件有没有被track过
- -e 文件名或目录：删除时需忽略的文件名或目录

### branch

```
git branch # 查看所有本地分支
git branch -a # 查看所有分支（包括本地和远端）
git branch -r # 查看所有远端分支
git branch -vv # 查看本地分支所关联的远程分支
git branch -m old_branch new_branch # 修改本地分支名 
git branch -d <分支名> # 删除分支
git branch --contains {commitid} # 查看commitid 出现的分支
```

### show

```bash
git show commitid # 查看某个commitid对应的修改

git show commitid --stat # 查看某个commitid对应修改的文件
```

### log

```
git log --author=d00xxxxxxG@f42021
git log ==graph --all --color --deecorate --oneline 
```

- `--oneline`: 把每一个提交压缩到了一行中
- `--decorate`: 让 git log 显示指向这个提交的所有引用（比如说分支、标签等）
- `--color`: 彩色输出信息
- `--graph`: 绘制一个 ASCII 图像来展示提交历史的分支结构
- `--all`: 显示所有分支信息

## 操作

### **恢复文件**

如果不小心在本地删错了文件，但是版本库中还有，这时可以用 如下命令把误删的文件恢复到最新版本：

```
$ git checkout -- file 	#恢复删除的某个文件
$ git checkout -- * 	#恢复删除的所有文件
```

git checkout -- file 其实是用版本库或者暂存区里的版本替换工作区的版本，无论工作区是修改还是删除都可以”一键还原“。

### 子模块使用

#### 添加submodule

`git submodule add <url> <path>`

url：为子模块的路径，

path：为该子模块存储的目录路径。

执行成功后，git status会看到项目中修改了.gitmodules，并增加了一个新文件（为刚刚添加的路径）

git diff --cached查看修改内容可以看到增加了子模块，并且新文件下为子模块的提交hash摘要

git commit提交即完成子模块的添加

#### 使用submodule

克隆项目后，默认子模块目录下无任何内容。需要在项目根目录执行如下命令完成子模块的下载：

`git submodule init`
`git submodule update`
或：

`git submodule update --init --recursive`
执行后，子模块目录下就有了源码，再执行相应的makefile即可。

#### 更新submodule

子模块的维护者提交了更新后，使用子模块的项目必须手动更新才能包含最新的提交。

在项目中，进入到子模块目录下，执行 git pull更新，查看git log查看相应提交。

完成后返回到项目目录，可以看到子模块有待提交的更新，使用git add，提交即可。

#### 删除submodule

有时子模块的项目维护地址发生了变化，或者需要替换子模块，就需要删除原有的子模块。

删除子模块较复杂，步骤如下：

`rm -rf` 子模块目录 删除子模块目录及源码
`vi .gitmodules` 删除项目目录下.gitmodules文件中子模块相关条目
`vi .git/config` 删除配置项中子模块相关条目
`rm .git/module/*` 删除模块下的子模块目录，每个子模块对应一个目录，注意只删除对应的子模块目录即可
执行完成后，再执行添加子模块命令即可，如果仍然报错，执行如下：

git rm --cached 子模块名称

完成删除后，提交到仓库即可。
