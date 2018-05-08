#!/bin/bash
cp ./binary_ubuntu_ppc64le/* .
export FABRIC_CFG_PATH=$PWD
sh ./ibm_fabric.sh
./docker-images-ppc64le.sh $1
sleep 5
docker-compose -f docker-compose-ppc64le.yaml up -d
