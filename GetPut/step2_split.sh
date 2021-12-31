if [ $# -ne 2 ]
then
    echo "Usage: 需要2个参数，1:所有表路径的文件名如all_tbl_path.txt, 2:分隔的行数"
    exit 1
fi
file=$1
count=$2
split -l ${count} ${file} -d -a 3 path_