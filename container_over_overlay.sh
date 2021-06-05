# Container network manually across an overlay

# Some hosts may need this
iptables -P FORWARD ACCEPT

# Host on 192.168.1.0/24 network targeting containers
# on a machine on the 192.168.2.0/24 side
# Note, the "via" address must be local to the network.
# 192.168.1.74 is NOT the host of target containers here,
# but the ip-over-udp gateway
ip r a 172.18.0.0/24 via 192.168.1.74

# Forwarding setup on 192.168.1.74:
# Don't forget to select the right source as forwarding
# at router depends on correct src ip
172.18.0.0/24 via 192.168.2.212 src 192.168.1.74

# Host on 192.168.1.0/24 targeting containers on same side
# This time 172.18.1 containers are on 192.168.1.74
ip r a 172.18.1.0/24 via 192.168.1.74

# Host on 192.168.2.0/24 side target containers on
# 192.168.2.212
ip r a 172.18.0.0/24 via 192.168.2.212

# Host on 192.168.2.0 side target containers on
# 192.168.1.0 side
ip r a 172.18.2.0/24 via 192.168.2.212

# Routing table on 192.168.2.212 router
# (extra routes such as docker0 and link local omitted)
default via 192.168.2.1 dev eth0 proto dhcp metric 100 
172.18.0.0/24 dev br-23c1551d4516 proto kernel scope link src 172.18.0.1 
172.18.1.0/24 via 192.168.1.74 dev tunudp src 192.168.2.212 
172.18.2.0/24 via 192.168.1.81 dev tunudp src 192.168.2.212 
172.18.3.0/24 via 192.168.2.231 dev eth0 
192.168.1.0/24 dev tunudp scope link src 192.168.2.212 
192.168.2.0/24 dev eth0 proto kernel scope link src 192.168.2.212 metric 100 

# Routing table on 192.168.1.74 router
# (extra routes such as docker0 and link local and vagrant omitted)
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 # This is why we need to specify src in routes
172.18.0.0/24 via 192.168.2.212 dev tunudp src 192.168.1.74 
172.18.1.0/24 dev br-2d09294b4199 proto kernel scope link src 172.18.1.1 
172.18.2.0/24 via 192.168.1.81 dev eth1 src 192.168.1.74
172.18.3.0/24 via 192.168.2.212 dev tunudp src 192.168.1.74 
192.168.1.0/24 dev eth1 proto kernel scope link src 192.168.1.74 
192.168.2.0/24 dev tunudp scope link src 192.168.1.74 

# Routing table on 192.168.1.81 host
# (extra routes such as docker0 and link local omitted)
default via 192.168.1.254 dev enx106530baabcc proto dhcp metric 100 
172.18.0.0/24 via 192.168.1.74 dev enx106530baabcc # this route can be shorter
172.18.1.0/24 via 192.168.1.74 dev enx106530baabcc 
172.18.2.0/24 dev br-44be34d7cac5 proto kernel scope link src 172.18.2.1 
172.18.3.0/24 via 192.168.1.74 dev enx106530baabcc # and this route can be shorter -- see below
192.168.1.0/24 dev enx106530baabcc proto kernel scope link src 192.168.1.81 metric 100 
192.168.2.0/24 via 192.168.1.74 dev enx106530baabcc 

# Doing correct routing on one of the hosts on 192.168.2 side (not the router)
root@opi3-r1-1:~# ip r a 172.18.0.0/24 via 192.168.2.212 # OK
root@opi3-r1-1:~# ip r a 172.18.1.0/24 via 192.168.1.74 # ERROR
Error: Nexthop has invalid gateway.
root@opi3-r1-1:~# ip r a 172.18.2.0/24 via 192.168.1.81 # ERROR
Error: Nexthop has invalid gateway.
root@opi3-r1-1:~# # ip r a 172.18.3.0/24 via 192.168.1.81 # not necessary as 3.0/24 is local here
root@opi3-r1-1:~# ip r a 172.18.0.0/16 via 192.168.2.212 # This makes up for errors

