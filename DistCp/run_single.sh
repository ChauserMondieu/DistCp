if [ $# -ne 1 ]
then
    echo "Usage: 需要1个参数，1:表路径的文件名tbl_000"
    exit 1
fi
file=$1
export HADOOP_HOME=/usr/local/hadoop-current
export HADOOP_USER_NAME=prod_bigdata_offline
export HADOOP_USER_PASSWORD=lV1CCCdHnTlF6wLnyT8PB3LyFoBBE7Fo
cat ${file} | while read line; do

    src=`echo ${line} | awk '{print $1}'`
    dst=`echo ${line} | awk '{print $2}'`
    if [[ $src != hdfs* ]]; then
        echo "${file}文件内容格式不对，原NS路径以hdfs开头"
        exit 1
    fi
    if [[ $dst != hdfs* ]]; then
        echo "${file}文件内容格式不对，目标NS路径以hdfs开头"
        exit 1
    fi
    time=`date +%Y%m%d_%H_%M`
    log_dir=log_${file}
    if [ ! -d ${log_dir} ];then
        mkdir ${log_dir}
    fi
    rand_num=`head -10 /dev/urandom | cksum | awk '{print $1}'`

    echo $rand_num
    echo $src
    echo $dst
    hadoop distcp \
    -D mapreduce.job.queuename=root.dashujujiagoubu_offline  \
    -D distcp.filters.class=org.apache.hadoop.tools.FileStatusFilter \
    -D dfs.checksum.combine.mode=COMPOSITE_CRC \
    -D mapreduce.task.timeout=1800000 \
    -D mapreduce.map.memory.mb=2048 \
    -D mapreduce.job.running.map.limit=2000 \
    -update -p -i -m 100 -bandwidth 100 \
    ${src} ${dst} > ${log_dir}/distcp_${file}_${time}_${rand_num}.log 2>&1
    sleep 0.1
done