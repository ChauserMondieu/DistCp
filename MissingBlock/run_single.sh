IFS_OLD=$IFS
IFS=$'\n'

set -e

if [ $# -ne 2 ]
then
    echo "wrong input, please input 2 params; 1: file path 2: output file"
    exit 1
fi

path=$1
output=$2

export HADOOP_USER_NAME=prod_bigdata_offline
export HADOOP_USER_PASSWORD=lV1CCCdHnTlF6wLnyT8PB3LyFoBBE7Fo

for line in $(cat ${path})
do
    raw_path=$(echo ${line} | awk -F" " '{print $2}')
    wh_path=hdfs://DClusterWh${raw_path}
    echo ${wh_path}
    wh_file=$(echo ${wh_path} |awk -F "/" '{print $NF}')
    echo ${wh_file}
    check_before=$(hadoop fs -Ddfs.checksum.combine.mode=COMPOSITE_CRC -checksum ${wh_path})
    hdfs dfs -get ${wh_path}
    hdfs dfs -mv ${wh_path} ${wh_path}.bak
    hdfs dfs -put ${wh_file} ${wh_path}
    check_after=$(hadoop fs -Ddfs.checksum.combine.mode=COMPOSITE_CRC -checksum ${wh_path})
    value1=$(echo ${check_before} |awk -F " " '{print $3}')
    value2=$(echo ${check_after} |awk -F " " '{print $3}')
    if [ "$value1" == "$value2" ]
    then
        echo "success|${wh_path}"
	echo "success|${wh_path}" >> ${output}
        hdfs dfs -rm ${wh_path}.bak
        rm -rf ${wh_file}
    else
        echo "error|${wh_path}"
	echo "error|${wh_path}" >> ${output}
	hdfs dfs -mv ${wh_path}.bak ${wh_path}
	rm -rf ${wh_file}
    fi
    echo "${wh_path} done"
done

IFS=$IFS_OLD