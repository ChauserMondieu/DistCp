curdir=$(pwd)
src_path=$1
jar_dir=/home/bigdata_offline/work/distcp_manual/jar
log=${src_path}"_diff.log"

/usr/local/hadoop-current/bin/hadoop jar ${jar_dir}/hdfs-diff.jar ${src_path}>${src_path}"_diff"
if [ $? -eq 0 ]; then
  echo "${src_path} num:"`cat ${src_path}|wc -l` >${log}
  echo "${src_path} same num:"`cat ${src_path}"_diff"|grep "same|"|wc -l` >>${log}
  echo "${src_path} diff num:"`cat ${src_path}"_diff"|grep "diff|"|wc -l` >>${log}
  echo "${src_path} error num:"`cat ${src_path}"_diff"|grep "Error|"|wc -l` >>${log}
fi