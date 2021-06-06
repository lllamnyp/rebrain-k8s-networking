#!/bin/bash

ssh opi3-router ip r a 172.18.1.0/24 via 192.168.1.74 dev tunudp src 192.168.2.212
ssh opi3-router ip r a 172.18.2.0/24 via 192.168.1.81 dev tunudp src 192.168.2.212 
ssh opi3-router ip r a 172.18.3.0/24 via 192.168.2.231 dev eth0

ssh vagrant.vm ip r a 172.18.0.0/16 via 192.168.2.212 dev tunudp src 192.168.1.74
ssh vagrant.vm ip r a 172.18.2.0/24 via 192.168.1.81 dev eth1 src 192.168.1.74

ssh opi3-r1-1 ip r a 172.18.0.0/24 via 192.168.2.212
ssh opi3-r1-1 ip r a 172.18.1.0/24 via 192.168.2.212
ssh opi3-r1-1 ip r a 172.18.2.0/24 via 192.168.2.212

sudo ip r a 172.18.0.0/16 via 192.168.1.74
