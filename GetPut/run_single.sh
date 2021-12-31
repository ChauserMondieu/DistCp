#! /bin/bash
set -e

if [ $# -ne 2 ]
then
    echo "Usage: 需要2个参数，1:表路径的文件名tbl_000 2:crc checksum输出路径"
    exit 1
fi
path=$1
output=$2
cat ${path} | while read line; do
  echo $line
  a=`echo $line|awk -F " " '{print $1}'`
  echo $a
  b=`echo $line|awk -F " " '{print $2}'`
  echo $b
  file=`echo $a|awk -F "/" '{print $NF}'`
  echo $file
  hadoop fs -get $a ./
  hadoop fs -put $file $b
  checka=$(hadoop fs -Ddfs.checksum.combine.mode=COMPOSITE_CRC -checksum $a)
  checkb=$(hadoop fs -Ddfs.checksum.combine.mode=COMPOSITE_CRC -checksum $b)
  value1=`cat ${checka} |awk -F " " '{print $3}'`
  value2=`cat ${checkb} |awk -F " " '{print $3}'`
  if [ "$value1" == "$value2" ]
  then
    echo "$a == $b" >> ${output}
  else
    echo "$a not $b" >> ${output}
  fi
  rm -rf $file
done