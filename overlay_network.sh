# Setting up a foo-over-udp (IPIP) tunnel
# OrangePI3 router
modprobe fou
ip fou add port 9000 ipproto 4
ip link add name tunudp type ipip remote 192.168.2.1 local 192.168.2.212 encap fou encap-sport auto encap-dport 9000
ip link set tunudp up
ip link set tunl0 up
ip r a 192.168.1.0/24 dev tunudp scope link src 192.168.2.212
sysctl -w  net.ipv4.conf.tunudp.rp_filter=0
sysctl -w  net.ipv4.conf.wlan0.rp_filter=0
sysctl -w  net.ipv4.conf.tunl0.rp_filter=0
sysctl -w  net.ipv4.conf.default.rp_filter=0
sysctl -w  net.ipv4.conf.all.rp_filter=0

# Vagrant machine
modprobe fou
ip fou add port 9000 ipproto 4
ip link add name tunudp type ipip remote 192.168.1.82 local 192.168.1.74 ttl 225 encap fou encap-sport auto encap-dport 9000
ip link set tunudp up
ip link set tunl0 up
ip r a 192.168.2.0/24 dev tunudp scope link src 192.168.1.74
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0
sysctl -w net.ipv4.conf.eth0.rp_filter=0
sysctl -w net.ipv4.conf.eth1.rp_filter=0
sysctl -w net.ipv4.conf.tunl0.rp_filter=0
sysctl -w net.ipv4.conf.tunudp.rp_filter=0

# Forwarding for packets (on both vagrant and opi router)
sysctl -w net.ipv4.ip_forward=1

# Routes for clients on 192.168.2.0/24 side of network (but not on router)
ip r a 192.168.1.0/24 via 192.168.2.212

# Routes on 192.168.1.0/24 side of network (but not vagrant)
ip r a 192.168.2.0/24 via 192.168.1.74

# Routing on router
iptables -A INPUT -i eth0.2 -p tcp -m tcp --dport 22 -j ACCEPT
iptables -t nat -I POSTROUTING -s 192.168.1.74/32 -d 192.168.2.212/32 -p udp -m udp --dport 9000 -j SNAT --to-source 192.168.2.1
iptables -t nat -A PREROUTING -p udp --dport 9000 -s 192.168.2.212 -d 192.168.2.1 -j DNAT --to-destination 192.168.1.74:9000
iptables -t nat -A PREROUTING -p udp --dport 9000 -s 192.168.1.74 -d 192.168.1.82 -j DNAT --to-destination 192.168.2.212:9000
iptables -D FORWARD -s 192.168.1.74/32 -d 192.168.2.212 -p udp --dport 9000 -j ACCEPT
