#!/bin/bash

echo Current network namespaces are:
echo ==========================================================================
lsns -t net
echo ==========================================================================
echo
printf "Press enter to launch a container and see the difference..."
read
echo "Starting container with no network... "
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> container_id=$(docker run --platform $(dpkg --print-architecture) \'
echo '      --rm -d --network=none --name=netless lllamnyp/rebrain-utils'
echo '--> container_pid=$(docker inspect ${container_id} \'
echo "	-f '{{ .State.Pid }}')"
echo ----------------------------------RESULT----------------------------------
container_id=$(docker run --platform $(dpkg --print-architecture) --rm -d --network=none --name=netless lllamnyp/rebrain-utils)
echo container id is $container_id
container_pid=$(docker inspect ${container_id} -f '{{ .State.Pid }}')
echo container pid is $container_pid
echo ==========================================================================
echo
echo The container network namespace:
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> lsns -t net -p ${container_pid}'
echo ----------------------------------RESULT----------------------------------
lsns -t net -p ${container_pid}
echo ==========================================================================
echo
printf "Press enter to examine the host and container network interfaces..."
read
echo Host interfaces:
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> ifconfig'
echo ----------------------------------RESULT----------------------------------
ifconfig
echo ==========================================================================
echo
echo Container interfaces:
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> nsenter -t ${container_pid} -n ifconfig'
echo ----------------------------------RESULT----------------------------------
nsenter -t ${container_pid} -n ifconfig
echo ==========================================================================
echo
echo Docker0 bridge info:
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> brctl show docker0'
echo ----------------------------------RESULT----------------------------------
brctl show docker0
echo ==========================================================================
echo
echo Press enter to set up networking for the container...
read
echo Creating veth pair
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> ip link add manual-a type veth peer name manual-b'
echo '--> ip link set up manual-a'
echo '--> ip link set up manual-b'
echo '--> ip link show manual-a'
echo '--> ip link show manual-b'
echo ----------------------------------RESULT----------------------------------
ip link add manual-a type veth peer name manual-b
ip link set up manual-a
ip link set up manual-b
ip link show manual-a
ip link show manual-b
echo ==========================================================================
echo
echo Press enter to connect veth to bridge...
read
echo Attaching one end of veth pair to bridge
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> brctl addif docker0 manual-a'
echo '--> brctl show docker0'
echo ----------------------------------RESULT----------------------------------
brctl addif docker0 manual-a
brctl show docker0
echo ==========================================================================
echo
echo Press enter to get a reference to the net ns...
read
echo Symlinking the network namespace from procfs to /var/run/netns...
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '-->mkdir -p /var/run/netns/'
echo '-->ln -sfT /proc/${container_pid}/ns/net /var/run/netns/netless'
echo '-->ls -al /var/run/netns/netless'
echo ----------------------------------RESULT----------------------------------
mkdir -p /var/run/netns/
ln -sfT /proc/${container_pid}/ns/net /var/run/netns/netless
ls -al /var/run/netns/netless
echo ==========================================================================
echo
echo Press enter to connect the veth to the container...
read
echo Connecting other end of veth pair to container network namespace...
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> ip link set manual-b netns netless'
echo '--> ip netns exec netless ip a list'
echo '--> ip netns exec netless ip link set up manual-b'
echo '--> ip netns exec netless ip addr add 172.17.0.100/16 dev manual-b'
echo '--> ip netns exec netless ip a show manual-b'
echo ----------------------------------RESULT----------------------------------
ip link set manual-b netns netless
ip netns exec netless ip a list
ip netns exec netless ip link set up manual-b
ip netns exec netless ip addr add 172.17.0.100/16 dev manual-b
ip netns exec netless ip a show manual-b
echo ==========================================================================
echo
echo Press enter to configure the default route for the container...
read
echo Setting up routes...
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> ip netns exec netless ip route add default via 172.17.0.1'
echo '--> ip netns exec netless ip r'
echo ----------------------------------RESULT----------------------------------
ip netns exec netless ip route add default via 172.17.0.1
ip netns exec netless ip r
echo ==========================================================================
echo
echo Press enter to test TCP connectivity...
read
echo Testing from host ns...
echo ==========================================================================
echo ---------------------------------COMMANDS---------------------------------
echo '--> curl 172.17.0.100'
echo ----------------------------------RESULT----------------------------------
curl 172.17.0.100
echo ==========================================================================
echo "It works! Press enter to clean up..."
read
echo Cleaning up...
rm /var/run/netns/netless
docker rm -f netless
