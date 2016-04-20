#! /bin/bash

tmp_fifo="fifofile"                         # 管道文件名
thr_number=10                               # 线程数
task_number=100                             # 任务数

mkfifo ${tmp_fifo}                          # 创建管道文件
exec 6<>${tmp_fifo}                         # 将fd6指向该管道文件
rm ${tmp_fifo}

for ((i=0; i<${thr_number}; ++i));
do
    echo  "\n" >& 6                         # 向fd6写入回车符号
done

for ((i=0; i<${task_number}; ++i));
do
    read -u 6                               # 从管道读出回车符后启动子进程 
    {
        echo ${i}
        sleep 3
        echo  "\n" >&6                      # 子进程结束时向管道写入回车符
    }&
done

wait                                        # 等待后台进程执行完毕

exec 6>&-

exit 0
