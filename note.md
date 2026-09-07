## TASK1

### 1.answer

grep "PROJECT_ID" workspace/.project/metadata

cat workspace/.project/metadata

echo LSR-2026-0831 >output/01_project_id.txt

 echo ../../.project/metadata > output/01_relative_path.txt

### 2.tips

pwd  : 显示路径

cd  : 切换目录

ls ：ls -a 显示全部文件；ls 列出普通文件

find workspace  -type f | xargs grep "PROJECT_ID"

* `find 目录 -type f`：递归遍历目录下所有文件,输出路径

grep   选项  “文件名”  地址：查找相关内容，结果输出这行完整内容

* -n 显示行号；-i 忽略大小写；-r 递归搜索目录；-l 打印文件路径
* find是搜索文件名，grep是搜索文件内容

cat 地址 ：打印文件全部内容

echo 内容 > 地址 ：写入文件

* `>>`追加写入，`>`覆盖写入
* 内容不加双引号
* 地址是相对路径

## TASK2

### 1.answer

ls -l tools/recruit-info

chmod +x tools/recruit-info

./tools/recruit-info

export PATH="$PATH:$(pwd)/tools"

which recruit-info

command -v recruit-info

### 2.tips

ls -l 相对路径 ：列出文件详细信息，有x就能执行

chmod +x 相对路径 ：修改权限，增加x

`export PATH="$PATH:$(pwd)/tools"`

* export导出环境变量
* `$PATH`：读取旧 PATH 的值，**千万不能丢**
* 多个目录：分割
* `$(pwd)`：执行 pwd 命令，拿到**当前项目根目录的绝对路径**，把 tools 目录追加到 PATH 的末尾

which recruit-info：模拟 shell 查找命令的逻辑，打印出这个命令对应的程序绝对路径。

command -v recruit-info：打印程序路径

## TASK3

### 1.answer

```
find workspace/project/ -type f -exec grep -l -E 'TODO|FIXME' {} \; | sort | uniq > output/03_code_search.txt
```

### 2.tips

find 路径 -type f ：从文件夹  开始往下递归遍历

-exec：把 find 找到的每一个文件，丢给后面 grep 命令处理

grep -l -E 'TODO|FIXME' {} 

* -E开启正则，使得tood后面的|表示或
* {}占位符，替换传过来的地址
* `\;`：语法结束标记，固定照抄

sort 地址：按**字母字典序**把全部路径重新排好顺序

uniq 地址 ：删除**相邻**重复的行

## TASK4

### 1.answer

```
#任务1
grep 'ERROR' logs/server.log | wc -l > output/04_error_count.txt

#任务2
grep 'ERROR' logs/server.log | tr -s ' ' | cut -d' ' -f4 | cut -d'=' -f2 | sort | uniq > output/04_error_users.txt

#任务3
grep 'ERROR' logs/server.log | tr -s ' ' | cut -d' ' -f5 | cut -d'=' -f2 | sort | uniq -c | sort -nr | head -n1 | tr -s ' ' | cut -d' ' -f3 > output/04_top_code.txt
```

### 2.tips

`wc -l`：统计**行数**

cut -d'分隔符' -fN :按分隔符切割，取第 N 列

tr -s ' ':把重复空格压缩为单个空格

sort -nr :`‑n`数字模式，`‑r`逆序，**数值从大到小排**

`uniq -c`：统计每行出现次数，输出格式：`  计数 内容`，行首自带大量空格,所以计数已经是压缩完的第二列了

## TASK5 -请求次数最多的 IP 地址

### 1.answer

 cut -d' ' -f1 logs/access.log | sort | uniq -c | sort -nr | head -n1 | tr -s ' ' | cut -d' ' -f3 > output/05_top_ip.txt

## TASK6-正错分流

### 1.answer

./tools/check-project > output/06_stdout.txt

./tools/check-project 2> output/06_stderr.txt

./tools/check-project | tee output/06_tee.txt

### 2.tips

stdin 标准输入:

stdout 标准输出:command (1)> file.txt

stderr 标准错误:command 2> err.txt

tee :command | tee out.txt ;一份打印到终端屏幕,一份写入指定文件

## TASK7-读取日志文件

### 1.answer

```
#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
  echo "Usage: ./scripts/analyze.sh FILE"
  exit 1
fi

f="$1"

if [[ ! -f "$f" ]]; then
  echo "Error: file $f does not exist"
  exit 1
fi

err_num=$(grep -c "ERROR" "$f")

if [[ "$err_num" -eq 0 ]]; then
  top_code=""
else
  top_code=$(grep "ERROR" "$f" | awk '{print $NF}' | sed 's/code=//' | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')
fi

echo "Total ERROR: $err_num"
echo "Top Code: $top_code"
exit 0
```

### 2.tips

awk '{print $NF}'`：打印每行**最后一列**，拿到`code=500

\#!/usr/bin/env bash ;写在第一行，告诉操作系统，这个脚本要用 bash 解释器来执行里面代码

`$0`脚本本身名字，`$2` = 第 2 个参数，以此类推

`if [[ $# -ne 1 ]]`：`$#`传给脚本的参数总量,-ne  not equal

结构：

```
if [[ 条件 ]]; then
    满足条件执行
else
    不满足条件执行
fi  #结束标记
```

echo $?  ：执行完一条命令，立刻读，拿到它成功 / 失败状态





nano scripts/analyze.sh-------打开脚本

编辑完成后ctrl+o保存，ctrl+x退出



## TASK8-