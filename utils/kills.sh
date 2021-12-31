IFS_OLD=$IFS
IFS=$'\n'

path=$1
for line in $(cat ${path})
do
    job=$(echo ${line} | awk -F" " '{print $1}')
    kill -9 ${job}
done


IFS=$IFS_OLD