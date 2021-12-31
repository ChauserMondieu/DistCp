for i in {000..010};
do
 path="path_"$i
 echo $path
 sh -x run_single.sh  ${path} ${path}.log > ${path}.log &
done

