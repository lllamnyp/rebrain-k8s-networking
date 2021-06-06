#!/bin/bash
echo "Run these commands to pull kubeconfig"
echo "====================================="
echo "ssh vagrant.vm 'kubectl --kubeconfig /etc/kubernetes/config/admin.kubeconfig config view --flatten --minify > /tmp/kubeconfig'"
echo "scp vagrant.vm:/tmp/kubeconfig  /home/lllamnyp/.kube/vagrant"
echo "export KUBECONFIG=~/.kube/vagrant"
echo "sed -i 's/vagrant\.vm/192.168.1.74/' ~/.kube/vagrant"
