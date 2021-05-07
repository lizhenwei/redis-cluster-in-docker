#!/bin/sh
if [ $# != 1 ] ; then
    echo "USAGE: bash $0 host-ip"
    echo " e.g.: bash $0 192.168.0.154"
    exit 1;
fi

sed -ri "/cluster-announce-ip [0-9]{1,3}(\.[0-9]{1,3}){3}$/ccluster-announce-ip ${1}" ./conf/redis1.conf
sed -ri "/cluster-announce-ip [0-9]{1,3}(\.[0-9]{1,3}){3}$/ccluster-announce-ip ${1}" ./conf/redis2.conf
docker-compose up -d