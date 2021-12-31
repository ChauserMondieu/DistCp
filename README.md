# DistCp 流程
## 1 准备工作
1. 首先确定需要拷贝的文件夹 - 需要拷贝的文件夹输出的文件每一行应该满足如下格式：<br>
``src dst``
2. 使用hdfs-ls工具对文件夹进行切分，具体指令为<br>
``hadoop jar /hdfs-ls-1.1.1.jar``
<br>hdfs-ls 工具所在git repo<br>
   https://git.xiaojukeji.com/liubotao/hdfs-ls
<br>注意，切分有三种方式，第一种是只切分到下一级文件夹；第二种是切分到叶子文件夹；最后一种是直接切分到文件<br>
## 2 DistCp
1. 首先使用``step2_split.sh``切分全部path的文件
<br>``sh step2_split.sh ${path} ${num_each_queue}``<br>
2. 其次修改``step3_run_queue.sh``中队列的循环数量
3. 最后后台运行批量队列
<br>``nohup sh step3_run_queue > ${your_name}.log 2>&1 &``<br>
4. 队列运行结束后，使用``step4_diff.sh``进行判断
<br>``sh step4_diff.sh ${path}``<br>
该方法输出两个文件，一个是``${path}_diff``文件，一个是``${path}_diff.log``文件
## 3 Get｜Put
1. 方法与DistCp相类似，只不过首先通过get方法将文件下载到本地，然后通过put方法将文件上传回去
2. 不同的脚本是``run_single.sh``
## 4 diff 重跑步骤
1. 首先判断出现diff的原因
   1. ``hdfs dfs -count ${path}`` 有可能是文件未拷贝
   2. ``hdfs dfs -ls -d ${path}`` 有可能是文件拷贝出错
   3. 有可能是存在临时文件，删除指令``hdfs dfs -rm -skipTrash */.distcp.tmp.*``
2. 判断出现Error的原因
   1. 空文件夹
   2. 文件夹复制失败
3. 首先从diff文件中输出diff和Error的所有路径，使用``export.sh``脚本
4. 接下来进行重跑步骤，步骤同DistCp

## 5 删除Missing Block
1. 方法与DistCp相类似，首先需要手动导入missing block文件
2. 不同的脚本是``run_single.sh``

## 6 kill掉运行时间过长的mapred job
1. ``mapred job -list > tmp``
2. ``tail -n +3 > jobs``
3. 使用``kills.sh``脚本
