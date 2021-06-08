#!/bin/bash
set -x
ssh vagrant.vm number=1 bash -s <network_helper.sh
ssh opi3-router number=0 bash -s <network_helper.sh
ssh opi3-r1-1 number=3 bash -s <network_helper.sh
sudo number=2 bash -s <network_helper.sh

