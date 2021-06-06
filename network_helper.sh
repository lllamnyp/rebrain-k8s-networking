#!/bin/bash
docker rm -f router${number}
docker network rm router${number}
iptables -P FORWARD ACCEPT
arch=$(dpkg --print-architecture)
docker network create --subnet 172.18.${number}.0/24 router${number} || exit 1
docker run --rm -d --network=router${number} --name router${number} --platform=linux/${arch}  lllamnyp/rebrain-utils
