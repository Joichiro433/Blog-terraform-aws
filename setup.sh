#!/bin/bash

cd /opt
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
sh /opt/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
echo 'PATH=/opt/miniconda3/bin:$PATH' >> /home/ubuntu/.bashrc && source /home/ubuntu/.bashrc