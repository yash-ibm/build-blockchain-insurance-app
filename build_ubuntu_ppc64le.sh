#!/bin/bash
cp ./binary_ubuntu_ppc64le/* .
export FABRIC_CFG_PATH=$PWD
sh ./ibm_fabric.sh
sh ./docker-images-ppc64le.sh
sleep 5
docker-compose -f docker-compose-ppc64le.yaml up -d