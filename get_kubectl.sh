#!/bin/bash

if grep arm <(dpkg --print-architecture)
then
	arch=arm64
elif grep amd <(dpkg --print-architecture)
then
	arch=amd64
fi

wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/${arch}/kubectl

chmod 755 kubectl
mv kubectl /usr/local/bin/kubectl
