---
title: clang-format 使用手册
date: 2021-07-12 01:16:30
tags: vscode
---

# clang-format 使用手册

## 背景介绍

该程序能够自动化格式 C/C++/Obj-C 代码，支持多种代码风格：Google, Chromium, LLVM, Mozilla, WebKit，也支持自定义 style（通过编写 .clang-format 文件）。

## 安装

### ubuntu安装clang-format

```
sudo apt-get install clang-format
```

### 手动安装clang-format

- [下载](https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-sles12.4.tar.xz) 文件clang+llvm-11.0.0-x86_64-linux-sles12.4.tar.xz

  ```
  wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-sles12.4.tar.xz
  ```

- 解压文件

  ```text
  tar -xf clang+llvm-11.0.0-x86_64-linux-sles12.4.tar.xz
  ```

  解压目录如下

  ```
  .
  ├── bin
  ├── include
  ├── lib
  ├── libexec
  └── share
  ```

  bin 文件中有 clang-format 的可执行文件

- 将clang-format放入 `/usr/bin`目录下完成安装

  ```
  mv .clang-format /usr/bin
  ```

- 查看版本如下，安装成功

  ```
  root@dzh-pc:/# clang-format-10 -version
  clang-format version 10.0.0-4ubuntu1
  ```

## vscode中使用clang-format

### 部署 `.clang-format`文件

在工程根目录下新建 `.clang-format` 文件，填入规则，如下是基于google的格式进行修改的一个例子，仅供参考

```
# 语言: None, Cpp, Java, JavaScript, ObjC, Proto, TableGen, TextProto
Language: Cpp
# BasedOnStyle:	LLVM

# 访问说明符(public、private等)的偏移
AccessModifierOffset: -4

# 开括号(开圆括号、开尖括号、开方括号)后的对齐: Align, DontAlign, AlwaysBreak(总是在开括号后换行)
AlignAfterOpenBracket: Align

# 连续赋值时，对齐所有等号
AlignConsecutiveAssignments: false

# 连续声明时，对齐所有声明的变量名
AlignConsecutiveDeclarations: false

# 右对齐逃脱换行(使用反斜杠换行)的反斜杠
AlignEscapedNewlines: Right

# 水平对齐二元和三元表达式的操作数
AlignOperands: true

# 对齐连续的尾随的注释
AlignTrailingComments: true

# 不允许函数声明的所有参数在放在下一行
AllowAllParametersOfDeclarationOnNextLine: false

# 不允许短的块放在同一行
AllowShortBlocksOnASingleLine: true

# 允许短的case标签放在同一行
AllowShortCaseLabelsOnASingleLine: true

# 允许短的函数放在同一行: None, InlineOnly(定义在类中), Empty(空函数), Inline(定义在类中，空函数), All
AllowShortFunctionsOnASingleLine: None

# 允许短的if语句保持在同一行
AllowShortIfStatementsOnASingleLine: true

# 允许短的循环保持在同一行
AllowShortLoopsOnASingleLine: true

# 总是在返回类型后换行: None, All, TopLevel(顶级函数，不包括在类中的函数), 
# AllDefinitions(所有的定义，不包括声明), TopLevelDefinitions(所有的顶级函数的定义)
AlwaysBreakAfterReturnType: None

# 总是在多行string字面量前换行
AlwaysBreakBeforeMultilineStrings: false

# 总是在template声明后换行
AlwaysBreakTemplateDeclarations: true

# false表示函数实参要么都在同一行，要么都各自一行。 false时看是否超出ColumnLimit的限制
BinPackArguments: true

# false表示所有形参要么都在同一行，要么都各自一行
BinPackParameters: true

# 大括号换行，只有当BreakBeforeBraces设置为Custom时才有效
BraceWrapping:
  # class定义后面
  AfterClass: false
  # 控制语句后面
  AfterControlStatement: false
  # enum定义后面
  AfterEnum: false
  # 函数定义后面
  AfterFunction: false
  # 命名空间定义后面
  AfterNamespace: false
  # struct定义后面
  AfterStruct: false
  # union定义后面
  AfterUnion: false
  # extern之后
  AfterExternBlock: false
  # catch之前
  BeforeCatch: false
  # else之前
  BeforeElse: false
  # 缩进大括号
  IndentBraces: false
  # 分离空函数
  SplitEmptyFunction: false
  # 分离空语句
  SplitEmptyRecord: false
  # 分离空命名空间
  SplitEmptyNamespace: false

# 在二元运算符前换行: None(在操作符后换行), NonAssignment(在非赋值的操作符前换行), All(在操作符前换行)
BreakBeforeBinaryOperators: NonAssignment

# 在大括号前换行: Attach(始终将大括号附加到周围的上下文), Linux(除函数、命名空间和类定义，与Attach类似), 
#   Mozilla(除枚举、函数、记录定义，与Attach类似), Stroustrup(除函数定义、catch、else，与Attach类似), 
#   Allman(总是在大括号前换行), GNU(总是在大括号前换行，并对于控制语句的大括号增加额外的缩进), WebKit(在函数前换行), Custom
#   注：这里认为语句块也属于函数
BreakBeforeBraces: Custom

# 在三元运算符前换行
BreakBeforeTernaryOperators: false

# 在构造函数的初始化列表的冒号后换行
BreakConstructorInitializers: AfterColon

#BreakInheritanceList: AfterColon

BreakStringLiterals: false

# 每行字符的限制，0表示没有限制， 
ColumnLimit: 120

CompactNamespaces: true

# 构造函数的初始化列表要么都在同一行，要么都各自一行
ConstructorInitializerAllOnOneLineOrOnePerLine: false

# 构造函数的初始化列表的缩进宽度
ConstructorInitializerIndentWidth: 4

# 延续的行的缩进宽度
ContinuationIndentWidth: 4

# 去除C++11的列表初始化的大括号{后和}前的空格
Cpp11BracedListStyle: true

# 继承最常用的指针和引用的对齐方式
DerivePointerAlignment: false

# 固定命名空间注释
FixNamespaceComments: true

# 缩进case标签
IndentCaseLabels: false

IndentPPDirectives: None

# 缩进宽度
IndentWidth: 4

# 函数返回类型换行时，缩进函数声明或函数定义的函数名
IndentWrappedFunctionNames: false

# 保留在块开始处的空行
KeepEmptyLinesAtTheStartOfBlocks: false

# 连续空行的最大数量
MaxEmptyLinesToKeep: 1

# 命名空间的缩进: None, Inner(缩进嵌套的命名空间中的内容), All
NamespaceIndentation: None

# 指针和引用的对齐: Left, Right, Middle
PointerAlignment: Right

# 允许重新排版注释
ReflowComments: true

# 允许排序#include
SortIncludes: false

# 允许排序 using 声明
SortUsingDeclarations: false

# 在C风格类型转换后添加空格
SpaceAfterCStyleCast: false

# 在Template 关键字后面添加空格
SpaceAfterTemplateKeyword: true

# 在赋值运算符之前添加空格
SpaceBeforeAssignmentOperators: true

# SpaceBeforeCpp11BracedList: true

# SpaceBeforeCtorInitializerColon: true

# SpaceBeforeInheritanceColon: true

# 开圆括号之前添加一个空格: Never, ControlStatements, Always
SpaceBeforeParens: ControlStatements

# SpaceBeforeRangeBasedForLoopColon: true

# 在空的圆括号中添加空格
SpaceInEmptyParentheses: false

# 在尾随的评论前添加的空格数(只适用于//)
SpacesBeforeTrailingComments: 1

# 在尖括号的<后和>前添加空格
SpacesInAngles: false

# 在C风格类型转换的括号中添加空格
SpacesInCStyleCastParentheses: false

# 在容器(ObjC和JavaScript的数组和字典等)字面量中添加空格
SpacesInContainerLiterals: true

# 在圆括号的(后和)前添加空格
SpacesInParentheses: false

# 在方括号的[后和]前添加空格，lamda表达式和未指明大小的数组的声明不受影响
SpacesInSquareBrackets: false

# 标准: Cpp03, Cpp11, Auto
Standard: Cpp11

# tab宽度
TabWidth: 4

# 使用tab字符: Never, ForIndentation, ForContinuationAndIndentation, Always
UseTab: Never
```

### 开启自动格式化

在vscode配置文件目录中添加文件settings.json，保存文档时会触发自动格式化。内容填写如下（该设置仅针对该工程）：

```
{
	    "editor.formatOnSave": true
}
```

或者在设置中搜索 `format on save`，勾选对应选项即可（该设置针对全局）

### 指定clang-format位置

在settings中添加如下内容,填入clang-format的绝对路径，没有进行如下配置，clang-format

插件会尝试在PATH中查找：

```
{
    "clang-format.executable": "/usr/bin/clang-format"
}
```

> This extension will attempt to find clang-format on your `PATH`. Alternatively, the clang-format executable can be specified in your vscode settings.json file:

或者在vscode的设置中搜索 `clang-format.executable` ，显式指定clang-format的绝对路径即可。

### 格式化代码

- 手动：在代码中右键点击 `Format Document` 或者使用快捷键 `ctrl + shift + f` 


- 自动： `ctrl + s` 保存文档，触发自动格式化（前提是要开启自动化选，上文有提到开启方法）


- 批量格式化：find ./dirname  -iname "\*.h" -o -iname "\*.c" | xargs clang-format -style=file -i

  > 对文件夹下的文件一起进行格式化
  >
  > ./dirname 为文件夹目录
  >
  > -iname 指按名字匹配文件，且不区分大小写
  >
  > -o 同 -or，表示or的意思，这里指查找"\*.h" 和"\*.c"的文件。类似的还有 -a (meaning logical AND).
  >
  > xargs 是一个强有力的命令，它能够捕获一个命令的输出，然后传递给另外一个命令；xargs 也可以将单行或多行文本输入转换为其他格式，例如多行变单行，单行变多行；xargs 默认的命令是 echo，这意味着通过管道传递给 xargs 的输入将会包含换行和空白，不过通过 xargs 的处理，换行和空白将被空格取代。
  
  

# 参考文献

https://releases.llvm.org/download.html

[clang-format 插件使用说明](https://marketplace.visualstudio.com/items?itemName=xaver.clang-format)

https://clang.llvm.org/docs/ClangFormatStyleOptions.html

[find命令介绍](https://man7.org/linux/man-pages/man1/find.1.html)

