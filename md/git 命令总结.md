---
title: git 命令总结
date: 2021-07-12 01:16:30
tags: 总结
---
# git入门

官方文档有最全面的讲解，优先参考官方文档 ：[https://git-scm.com/book/zh/v2](https://git-scm.com/book/zh/v2)

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
git reset --hard commitID # 强制回退到某个commitID
```

### remote

```
git remote: 显示当前仓库配置的所有远程仓库的简写名称。
git remote -v: 显示当前仓库配置的所有远程仓库的简写名称和对应的 URL。
git remote add <remote_name> <remote_url>: 添加一个新的远程仓库，指定远程仓库的简写名称和 URL。
git remote remove <remote_name>: 移除指定名称的远程仓库。
git remote rename <old_name> <new_name>: 重命名指定名称的远程仓库。
git remote set-url <远端仓名> <新的远端仓地址>: 修改远端仓地址（直接修改配置文件.git中的config文件中目标远端的url也可以修改地址） 
git remote update: 获取远程仓库中的最新提交和分支，并将这些信息更新到本地仓库中。
```

### rm

```
#缓存未清除：如果已经将某些文件或目录添加到Git版本控制中，并且之后才将它们添加到.gitignore文件中，那么这些文件或目录的更改可能仍然会被Git缓存。可以使用以下命令清除Git缓存：
git rm -r --cached <dir>
git add .
```

### clean

```bash
git clean: 移除工作目录中所有未跟踪的文件和目录（不包括被忽略的文件）。
git clean -n 或 git clean --dry-run: 显示将要执行的清理操作，但不实际移除文件和目录。
git clean -f 或 git clean --force: 强制执行清理操作，移除未跟踪的文件和目录。
git clean -d 或 git clean --directories: 移除未跟踪的目录。
git clean -x 或 git clean --force --ignored: 移除未跟踪的文件和目录，包括被忽略的文件。
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

### diff

```
git diff: 比较当前工作目录中的文件与最后一次提交（HEAD）之间的差异。
git diff <commit>: 比较当前工作目录中的文件与指定提交之间的差异。
git diff <commit1> <commit2>: 比较两个指定提交之间的差异。
git diff --cached: 比较暂存区（Index）中的文件与最后一次提交之间的差异（已经 git add 的文件）。
git diff <branch1> <branch2>: 比较两个分支之间的差异。
git diff <filename> 是一个用于比较特定文件差异的 Git 命令。它可以显示指定文件在不同版本之间的修改内容，包括行级别的插入、删除和修改。
```

### show

```bash
git show: 显示最新的提交（HEAD）的详细信息。
git show <commit>: 显示指定提交的详细信息，其中 <commit> 可以是提交的哈希值、分支名、标签名等。
git show commitid --stat：查看某个commitid对应修改的文件，概览。
git show <commit>:<file>: 显示指定提交中某个文件的详细信息。
git show <object>: 显示指定对象的详细信息，其中 <object> 可以是提交、标签或树对象的哈希值。
```

## 常用git操作

### **恢复文件**

如果不小心在本地删错了文件，但是版本库中还有，这时可以用 checkout 命令还原，本质是用版本库或者暂存区里的版本替换工作区的版本。

```
git checkout <commit> <file> # 其中 `<commit>` 是要还原的版本的提交哈希值或分支名称，`<file>` 是要还原的文件的路径。执行上述命令后，Git 将会将指定文件还原为指定版本的内容。
```

> 注意，在使用 `git checkout` 命令之前，确保没有未提交的更改或者将会丢失这些更改。如果有未提交的更改，可以先进行提交或者使用 `git stash` 命令将其保存为临时更改。

```
git checkout -- <file> # 用于恢复被删除的某个文件
git checkout -- *      # 用于恢复被删除的所有文件
```

> Git 将会还原所有已修改但未暂存的文件到前一个提交的状态。

```
git checkout - # 将会切换回上一个分支，并将工作目录中的文件更新为该分支的最新状态。与cd - 类似
```

### 代码冲突处理

代码冲突发生在多个开发者同时修改同一个文件的同一部分时，Git 无法自动解决冲突，需要手动处理。下面是处理代码冲突的一般步骤：

#### 查找冲突

在进行 Git 操作（如合并分支或拉取远程分支）时，如果发生冲突，Git 会在冲突的文件中标记出冲突的部分。您可以使用文本编辑器或专用的代码编辑工具打开冲突的文件，查找冲突标记。

```
<<<<<<< HEAD
// 当前分支的修改内容
=======
// 合并分支的修改内容
>>>>>>> branch-name
```

> ``<<<<<<< HEAD `到`=======` 之间是当前分支的修改内容，`=======`到`>>>>>>> branch-name` 之间是合并分支的修改内容。

#### 解决冲突

根据需要，手动编辑冲突的文件，选择要保留的代码或根据需求进行修改。您可以根据自己的需求来决定如何解决冲突，可以保留当前分支的修改、合并分支的修改，或者合并两者。

#### 提交解决

一旦您完成了冲突的解决，将文件保存，并使用以下命令将解决后的文件标记为已解决：

```
git add <resolved-file>  # <resolved-file> 是冲突已经解决的文件路径
```

#### 完成合并或提交

当所有冲突都解决并已标记为已解决后，继续进行您的合并操作（如 `git merge`）或提交操作（如 `git commit`）。Git 将使用您解决冲突后的文件来完成合并或提交过程。

> 请记住，在处理代码冲突时，与其他开发者进行协作和沟通是非常重要的。确保您了解彼此的修改意图，并遵循团队的协作流程。

## 常用git命令

### **git status**

* 当前分支的名称：显示当前所在的分支。
* 未暂存的文件：列出在工作目录中已被修改但尚未添加到暂存区的文件。
* 暂存区的文件：列出已经添加到暂存区但尚未提交的文件。
* 未跟踪的文件：列出在工作目录中存在但尚未被 Git 跟踪的文件。
* 分支状态：如果本地分支落后于远程分支，将显示提示信息。

### git diff

```
git diff: 比较当前工作目录中的文件与最后一次提交（HEAD）之间的差异。
git diff <commit>: 比较当前工作目录中的文件与指定提交之间的差异。
git diff <commit1> <commit2>: 比较两个指定提交之间的差异。
git diff --cached: 比较暂存区（Index）中的文件与最后一次提交之间的差异（已经 git add 的文件）。
git diff <branch1> <branch2>: 比较两个分支之间的差异。
git diff <filename> 是一个用于比较特定文件差异的 Git 命令。它可以显示指定文件在不同版本之间的修改内容，包括行级别的插入、删除和修改。
```

### git log

```
git log # 每条记录包含下面的信息
git log --author=<author>  # 
```

--oneline:  把每一个提交压缩到了一行中

--decorate: 让 git log 显示指向这个提交的所有引用（比如说分支、标签等）

--color: 彩色输出信息

--graph: 绘制一个 ASCII 图像来展示提交历史的分支结构

--all: 显示所有分支信息




## 子仓功能

### 添加submodule

`git submodule add <url> <path>`

url：为子模块的路径，

path：为该子模块存储的目录路径。

执行成功后，git status会看到项目中修改了.gitmodules，并增加了一个新文件（为刚刚添加的路径）

git diff --cached查看修改内容可以看到增加了子模块，并且新文件下为子模块的提交hash摘要

git commit提交即完成子模块的添加

### 使用submodule

克隆项目后，默认子模块目录下无任何内容。需要在项目根目录执行如下命令完成子模块的下载：

`git submodule init`
`git submodule update`
或：

`git submodule update --init --recursive`
执行后，子模块目录下就有了源码，再执行相应的makefile即可。

### 更新submodule

子模块的维护者提交了更新后，使用子模块的项目必须手动更新才能包含最新的提交。

在项目中，进入到子模块目录下，执行 git pull更新，查看git log查看相应提交。

完成后返回到项目目录，可以看到子模块有待提交的更新，使用git add，提交即可。

### 删除submodule

有时子模块的项目维护地址发生了变化，或者需要替换子模块，就需要删除原有的子模块。

删除子模块较复杂，步骤如下：

`rm -rf` 子模块目录 删除子模块目录及源码
`vi .gitmodules` 删除项目目录下.gitmodules文件中子模块相关条目
`vi .git/config` 删除配置项中子模块相关条目
`rm .git/module/*` 删除模块下的子模块目录，每个子模块对应一个目录，注意只删除对应的子模块目录即可
执行完成后，再执行添加子模块命令即可，如果仍然报错，执行如下：

git rm --cached 子模块名称

完成删除后，提交到仓库即可。
