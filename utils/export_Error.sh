IFS_OLD=$IFS
IFS=$'\n'

if [ $# -ne 2  ]
then
    echo "wrong input, first param is input second param is output"
    exit 1
fi

input=$1
output=$2

for line in $(cat ${input})
do
    init=${line:0:1}
    if [ "${init}" == "d" ]
    then
        echo "$(echo ${line} | awk -F"|" '{print $2}' )" >> ${output}
    else
        echo "nothing"
    fi
done

IFS=$IFS_OLD