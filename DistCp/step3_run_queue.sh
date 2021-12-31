for i in {000..182};
do
 path="path_"$i
 echo $path
 sh -x run_single.sh  ${path} >${path}.log &
done