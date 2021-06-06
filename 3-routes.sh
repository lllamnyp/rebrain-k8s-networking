#!/bin/bash
echo You need routes to the udp tunnel before 
echo IP connectivity is fully established. Run this:
echo '-----------------------------------------------'
echo 'ssh opi3-r1-1 ip r a 192.168.1.0/24 via 192.168.2.212'
echo 'ssh opi3-r1-2 ip r a 192.168.1.0/24 via 192.168.2.212'
echo 'ssh opi3-r2-1 ip r a 192.168.2.0/24 via 192.168.1.74'
echo 'ssh opi3-r2-2 ip r a 192.168.2.0/24 via 192.168.1.74'
echo 'sudo ip r a 192.168.2.0/24 via 192.168.1.74'
