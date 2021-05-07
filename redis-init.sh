#!/bin/bash
#docker exec -it redis-cluster-1 bash
if [ $# <2 ] ; then
    echo "USAGE: bash $0 ipaddress1 ipaddress2 ipaddress3"
    echo " e.g.: bash $0 192.168.0.154 192.168.0.155 192.168.0.156"
    exit 1;
fi

output=""
for((i=1;i<=$#;i++)); do 
    j="${!i}:7000 ${!i}:7001"
    output="${output} $j "
done
echo ${output}
docker exec -it redis-cluster-1 redis-cli -a 92F1q99f9CnrkAuwJPItdj8brqeMtN3r --cluster create ${output} --cluster-replicas 1
