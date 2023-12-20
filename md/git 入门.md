---
title: git 命令总结
date: 2021-07-12 01:16:30
tags: 总结
---
# git入门

官方文档有最全面的讲解，优先参考官方文档 ：[https://git-scm.com/book/zh/v2](https://git-scm.com/book/zh/v2)

## 关键概念

### git中的四个区域

#### 工作目录（Working Directory）

工作目录是您当前正在进行编辑和修改的项目目录。它包含了 Git 仓库中的文件的实际副本。当您在工作目录中进行修改时，这些更改只存在于工作目录中，并未被 Git 跟踪。工作目录对应于您本地文件系统中的实际项目目录。这是您编辑、修改和创建文件的地方。工作目录中的文件并不直接受 Git 控制。

#### 缓存区（Staging Area）

缓存区是位于 Git 仓库和工作目录之间的一个中间区域。它充当了暂存更改的临时存储区域。在进行提交之前，您可以使用 `git add` 命令将修改的文件添加到缓存区，以准备将其包含在下一次提交中。缓存区可以更好地组织提交历史记录。缓存区对应于 Git 仓库中的一个文件，它位于项目根目录的 `.git` 文件夹中的 `index` 文件。该文件记录了将包含在下一次提交中的文件列表和它们的状态信息。``.git/index` 文件是一个二进制文件，保存了文件的元数据、SHA-1 校验和和文件路径等信息。

#### 本地仓库（Local Repository）

仓库是包含项目完整历史记录和元数据的 Git 存储区域。它保存了所有提交的快照和相关的元数据信息，例如提交作者、提交时间戳等。当您使用 `git commit` 命令时，Git 将缓存区中的更改作为一个新的提交保存到仓库中。这样，您可以随时回滚到以前的提交，查看历史记录，或与其他开发者共享和协作。仓库对应于项目根目录的 `.git` 文件夹。`.git` 文件夹中包含了所有 Git 仓库的元数据和对象数据库。

在 `.git` 文件夹中，有一些重要的文件和目录，包括：

* `objects` 目录：存储 Git 对象的实际内容。
* `refs` 目录：存储分支（branches）、标签（tags）和其他引用的指针文件。
* `HEAD` 文件：指向当前所在分支的引用。
* `config` 文件：存储仓库的配置信息。
* `logs` 目录：存储提交历史记录和其他引用的日志。

#### 远程仓库（Remote Repository）

远程仓库是位于远程服务器上的 Git 仓库副本。它允许多个开发者之间的协作和代码共享。远程仓库通常用于团队协作或备份代码。您可以使用 `git push` 命令将本地仓库中的更改推送到远程仓库，以便其他开发者可以访问和获取最新的更改。类似地，使用 `git pull` 命令从远程仓库拉取最新的更改到本地仓库。远程仓库可以使用 URL 进行访问，例如 GitHub、GitLab 或 Bitbucket。

> 远端仓库的创建配置和使用在对应的平台有详细描述，例如gitee：[https://help.gitee.com/repository](https://help.gitee.com/repository)

### GIT中的指针（引用）

#### HEAD

HEAD 是当前所在分支的引用，也是当前工作树（Working Tree）所指向的提交。它可以被看作是当前活动分支的别名。当您执行 `git checkout` 或者进行提交时，HEAD 将移动到新的提交，反映出工作树和当前分支的最新状态。

> `HEAD~` 表示当前提交的父提交，`HEAD~2` 表示当前提交的父提交的父提交，依此类推。这种相对表示法对于访问历史中的先前提交很有用。

#### 分支引用

分支引用是指向特定分支的指针。例如，`master`、`develop` 或者其他自定义的分支名称。每个分支引用都指向一个提交对象，表示该分支的最新提交。当您在特定分支上进行提交时，该分支引用会随之更新。

#### 远程分支引用

远程分支引用是指向远程仓库的分支的指针。这些引用通常以 `<remote>/<branch>` 的形式命名，例如 `origin/master`。它们是本地仓库中对远程仓库分支的跟踪。当您与远程仓库进行交互（如拉取、推送）时，这些远程分支引用会更新以反映远程仓库的最新状态。

#### 标签引用

标签引用是指向特定提交的不可变指针。标签用于标记某个特殊的提交，通常是版本号、重要里程碑或发布版本等。标签引用不会随提交的改变而移动，因此可以用于永久性地标记某个特定状态。

## 常用git操作

### 密钥配置

> Windows 用户建议使用 **Windows PowerShell** 或者  **Git Bash** ，在 **命令提示符** 下无 `cat` 和 `ls` 命令。

1、通过命令 `ssh-keygen` 生成 SSH Key：

```bash
ssh-keygen -t ed25519 -C"Gitee SSH Key"
```

* `-t` key 类型
* `-C` 注释

输出，如：

```bash
Generating public/private ed25519 key pair.
Enter fileinwhich to save the key (/home/git/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/git/.ssh/id_ed25519
Your public key has been saved in /home/git/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:ohDd0OK5WG2dx4gST/j35HjvlJlGHvihyY+Msl6IC8I Gitee SSH Key
The key's randomart image is:
+--[ED25519 256]--+
|    .o           |
|   .+oo          |
|...O.o +       |
|   .= * = +.     |
|  .o +..S*. +    |
|....o o..+* *   |
|.E. o ...+.O    |
|..... o =.    |
|..oo. o.o    |
+----[SHA256]-----+
```

* 中间通过三次**回车键**确定

2、查看生成的 SSH 公钥和私钥：

```bash
ls ~/.ssh/
```

输出：

```bash
id_ed25519  id_ed25519.pub
```

* 私钥文件 `id_ed25519`
* 公钥文件 `id_ed25519.pub`

3、读取公钥文件 `~/.ssh/id_ed25519.pub`：

```bash
cat ~/.ssh/id_ed25519.pub
```

输出，如：

```bash
ssh-ed25519 AAAA***5B Gitee SSH Key
```

复制终端输出的公钥，根据远端仓库平台的说明，将公钥添加到平台。

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

### 分支合并

确保位于要合并更改的目标分支的最新状态。可以通过 `git checkout <branch>` 切换到目标分支，并执行 `git pull` 拉取最新更改。

切换回当前分支，执行 `git merge <branch>` 命令，将目标分支的更改合并到当前分支。

```
git checkout <current_branch> # 切换到当前分支
git merge <branch> # 执行merge操作
```

如果合并过程中出现冲突，您需要手动解决冲突。Git 会标记冲突的文件，并在文件中显示冲突的部分。您需要根据需要编辑文件，解决冲突。完成后，执行 `git add` 将文件标记为已解决冲突的状态，然后执行 `git commit` 完成合并提交。

```
# 解决冲突后
git add <conflicting_files>
git commit
```

合并完成后，您可以使用 `git branch -d <branch>` 删除不再需要的分支。

```
git branch -d <branch>
```

## 常用git命令

### **git status**

* 当前分支的名称：显示当前所在的分支。
* 未暂存的文件：列出在工作目录中已被修改但尚未添加到暂存区的文件。
* 暂存区的文件：列出已经添加到暂存区但尚未提交的文件。
* 未跟踪的文件：列出在工作目录中存在但尚未被 Git 跟踪的文件。
* 分支状态：如果本地分支落后于远程分支，将显示提示信息。

### git add

使用 `git add` 命令将要提交的文件添加到暂存区（也称为索引区）

```
git add <file> # 添加单个文件
git add <file1> <file2> ... # 添加多个文件
git add . # 添加所有文件
git add <directory> # 添加目录下所有文件
git add  *.c  # 通过模糊匹配添加某类文件
```

### git commit

```
git commit -m "Add new feature"  # 提交消息，简单记录本次修改的内容
git commit --amend # 修改最近一次提交的message。您可以编辑提交消息并保存，以修改该提交的消息内容。
```

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

### git show

```
git show: 显示最新的提交（HEAD）的详细信息。
git show <commit>: 显示指定提交的详细信息，其中 <commit> 可以是提交的哈希值、分支名、标签名等。
git show commitid --stat：查看某个commitid对应修改的文件，概览。
git show <commit>:<file>: 显示指定提交中某个文件的详细信息。
git show <object>: 显示指定对象的详细信息，其中 <object> 可以是提交、标签或树对象的哈希值。
```

### git branch

```
git branch # 查看所有本地分支
git branch -a # 查看所有分支（包括本地和远端）
git branch -r # 查看所有远端分支
git branch -vv # 查看本地分支所关联的远程分支
git branch -m old_branch new_branch # 修改本地分支名
git branch -d <分支名> # 删除分支
git branch --contains {commitid} # 查看commitid 出现的分支
```

### git clean

```
git clean: 移除工作目录中所有未跟踪的文件和目录（不包括被忽略的文件）。
git clean -n 或 git clean --dry-run: 显示将要执行的清理操作，但不实际移除文件和目录。
git clean -f 或 git clean --force: 强制执行清理操作，移除未跟踪的文件和目录。
git clean -d 或 git clean --directories: 移除未跟踪的目录。
git clean -x 或 git clean --force --ignored: 移除未跟踪的文件和目录，包括被忽略的文件。
```

* -n  clean的演习, 告诉你哪些文件将会被删除.不会真正的删除文件, 只是一个提醒
* -f  删除当前目录下所有没有track过的文件. 他不会删除.gitignore文件里面指定的文件夹和文件, 不管这些文件有没有被track过
* -e 文件名或目录：删除时需忽略的文件名或目录

### git remote

```
git remote: 显示当前仓库配置的所有远程仓库的简写名称。
git remote -v: 显示当前仓库配置的所有远程仓库的简写名称和对应的 URL。
git remote add <remote_name> <remote_url>: 添加一个新的远程仓库，指定远程仓库的简写名称和 URL。
git remote remove <remote_name>: 移除指定名称的远程仓库。
git remote rename <old_name> <new_name>: 重命名指定名称的远程仓库。
git remote set-url <远端仓名> <新的远端仓地址>: 修改远端仓地址
git remote update: 获取远程仓库中的最新提交和分支，并将这些信息更新到本地仓库中。
```

### git merge

```
git merge <branch> # 其中 <branch> 是您希望合并到当前分支的目标分支的名称。
```

> 合并过程会将目标分支的更改应用到当前分支上，并生成一个新的合并提交，将两个分支的更改整合在一起。如果没有冲突，Git 会尝试自动合并更改；如果存在冲突，您需要手动解决冲突后再进行提交。

### git rm

```
git rm <file> # 其中 `<file>` 是要删除的文件路径。这个命令将文件从 Git 仓库的版本历史记录中移除，并且也会将文件从工作目录中删除。该变更需要在提交后生效。
git rm --cached <file> # 这个命令会将文件从 Git 仓库的版本历史记录中移除，但是会保留文件在工作目录中的副本。该变更需要在提交后生效。
```

### git config

```
git config --global <key> <value> # 设置全局配置，例如，设置全局的用户名和邮箱地址：
```

> git config --global user.name "Your Name"
> git config --global user.email "[your@example.com](mailto:your@example.com)"

```
git config <key> <value> #设置仓库级别配置
git config --get <key> # 获取指定配置值
git config --list # 列出当前级别的所有配置
git config --global --list # 列出全局的所有配置
git config --global http.sslVerify false # 关闭ssl验证,对应报错信息

git credential-manager uninstall # 清除缓存的用户名和密码
```

Git 提供了凭据助手（credential helper）来方便地保存用户名和密码，以便在与远程仓库进行交互时自动提取凭据。凭据助手有两个常用的选项：`store` 和 `cache`。

```
git config --global credential.helper store
```

> ``store` 凭据助手将凭据以明文形式存储在本地计算机上的文件中。下次与远程仓库进行交互时，Git 将从该文件中提取凭据，而无需再次输入。这种方法简单明了，但安全性较低，因为凭据以明文形式存储。主要用于https，ssh使用秘钥不需要保存密码。

```
git config --global credential.helper cache
```

> ``cache` 凭据助手将凭据缓存在内存中一段时间，默认为 15 分钟。在此时间段内，Git 不会再次要求输入凭据。这种方法比明文存储更安全，因为凭据仅在内存中存储，并在一段时间后自动清除，减少了明文存储的风险。

```
git config --global credential.helper wincred #取消本地缓存用户名和密码的安全策略
```

> 需要注意的是，为了确保凭据的安全性，建议使用更安全的凭据助手（如 `cache` 或 `osxkeychain`）以及采取其他安全措施来保护您的凭据和存储设备。

### git reset

```
git reset <commit> # 将当前分支的指针移动到指定的提交，并且保留该提交之后的更改作为未暂存的更改。
```

可选项：

- `--soft`：仅移动分支指针，不更改暂存区和工作目录。
- `--mixed`：默认选项，移动分支指针并重置暂存区，但不更改工作目录。
- `--hard`：移动分支指针并重置暂存区和工作目录，丢弃所有更改。

```
git reset <file> # 将指定的文件从暂存区中移除，但保留在工作目录中的更改。
git reset HEAD~ # 将当前分支的指针移动到上一个提交，撤消最后一次提交的更改。工作目录和暂存区中的更改保持不变。
git reset --hard HEAD~ # 将当前分支的指针移动到上一个提交，撤消最后一次提交的更改，并丢弃工作目录和暂存区中的所有更改。
```

### git cherry-pick

```
git cherry-pick <commit-hash>
git cherry-pick abc123 def456   # 应用提交 abc123 和 def456 到当前分支
```

> 其中 `<commit-hash>` 是要应用的提交的哈希值（或短哈希），表示要从其他分支中选择的提交。可以使用 `git log` 命令查看提交历史，并获取相应的哈希值。

> 需要注意的是，复制提交到当前分支可能会导致提交历史的分叉和冲突。如果在应用提交时发生冲突，你需要手动解决冲突，并使用 `git cherry-pick --continue` 命令继续应用剩余的提交。

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

## 特殊操作

### git仓超大文件清理

当Git仓库中包含超大文件时，可以采取以下步骤来清理它们：

1. 检查超大文件：首先，使用以下命令检查Git仓库中的大文件：

   ```
   git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | awk '/^blob/ {print substr($0,6)}' | sort --numeric-sort --key=2 | cut --complement --characters=13-40 --stable | numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
   ```

   > 这个命令会列出Git仓库中的所有对象，并按照文件大小进行排序。您可以查看列表，找到超过您期望的文件大小的文件。
   >
2. 从历史记录中移除大文件：如果发现了超大文件，可以使用 `git filter-branch`命令从Git历史记录中完全移除它们。请注意，这将重新写入整个历史记录，因此请谨慎操作并备份仓库。

   ```
   git filter-branch --force --index-filter'git rm --cached --ignore-unmatch <file_path>' --prune-empty --tag-name-filtercat -- --all
   ```

   > 将 `<file_path>`替换为要移除的大文件的路径。这个命令将重新写入历史记录，并从每个提交中移除指定的文件。
   >
3. 清理Git对象：执行上述步骤后，仓库中的大文件已经从历史记录中移除，但它们仍然存在于Git对象数据库中。为了彻底清理它们，可以运行以下命令：

   ```
   git reflog expire --expire=now --all
   git gc --prune=now
   ```

   > 这些命令将清理不再可达的对象，并优化Git仓库的存储。
   >

请注意，执行这些操作可能会对Git仓库产生重大影响，因此在执行之前，请务必备份您的仓库以防万一。此外，如果仓库是多人协作的，还需要与团队成员进行协调和沟通。
