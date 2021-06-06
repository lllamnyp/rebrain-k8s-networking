#!/bin/sh
set -x
iptables -A INPUT -i eth0.2 -p tcp -m tcp --dport 22 -j ACCEPT
iptables -t nat -I POSTROUTING -s 192.168.1.74/32 -d 192.168.2.212/32 -p udp -m udp --dport 9000 -j SNAT --to-source 192.168.2.1
iptables -t nat -A PREROUTING -p udp --dport 9000 -s 192.168.2.212 -d 192.168.2.1 -j DNAT --to-destination 192.168.1.74:9000
iptables -t nat -A PREROUTING -p udp --dport 9000 -s 192.168.1.74 -d 192.168.1.82 -j DNAT --to-destination 192.168.2.212:9000
iptables -D FORWARD -s 192.168.1.74/32 -d 192.168.2.212 -p udp --dport 9000 -j ACCEPT
