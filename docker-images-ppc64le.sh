#!/bin/bash
set -eu

dockerFabricPull() {
  local FABRIC_TAG=$1
  for IMAGES in peer orderer ccenv; do
      echo "==> FABRIC IMAGE: $IMAGES"
      echo
      docker pull hyperledger/fabric-$IMAGES:$FABRIC_TAG
      docker tag hyperledger/fabric-$IMAGES:$FABRIC_TAG hyperledger/fabric-$IMAGES
  done
}

dockerCaPull() {
      local CA_TAG=$1
      echo "==> FABRIC CA IMAGE"
      echo
      docker pull hyperledger/fabric-ca:$CA_TAG
      docker tag hyperledger/fabric-ca:$CA_TAG hyperledger/fabric-ca
}

BUILD=
DOWNLOAD=
DOWNLOAD_CA_BUILD=
if [ $# -eq 0 ]; then
    BUILD=true
    PUSH=true
    DOWNLOAD=true
    DOWNLOAD_CA_BUILD=false
else
    for arg in "$@"
        do
            if [ $arg == "build" ]; then
                BUILD=true
            fi
            if [ $arg == "download" ]; then
                DOWNLOAD=true
            fi
	    if [ $arg == "cabuild" ]; then
		DOWNLOAD_CA_BUILD=true
		BUILD=true
	    fi
    done
fi

if [ $DOWNLOAD ]; then
    : ${CA_TAG:="ppc64le-1.1.0"}
    : ${FABRIC_TAG:="ppc64le-1.1.0"}

    echo "===> Pulling fabric Images"
    dockerFabricPull ${FABRIC_TAG}

    echo "===> Pulling fabric ca Image"
    dockerCaPull ${CA_TAG}
    echo
    echo "===> List out hyperledger docker images"
    docker images | grep hyperledger*
fi

if [ $DOWNLOAD_CA_BUILD ]; then
    : ${CA_TAG:="ppc64le-1.1.0"}
    echo "===> Pulling fabric ca Image"
    dockerCaPull ${CA_TAG}
fi

if [ $BUILD ];
    then
    echo '############################################################'
    echo '#                 BUILDING CONTAINER IMAGES                #'
    echo '############################################################'
    docker build -t orderer:latest -f orderer/Dockerfile.ppc64le orderer/
    docker build -t insurance-peer:latest -f insurancePeer/Dockerfile.ppc64le insurancePeer/
    docker build -t police-peer:latest -f policePeer/Dockerfile.ppc64le policePeer/
    docker build -t shop-peer:latest -f shopPeer/Dockerfile.ppc64le shopPeer/
    docker build -t repairshop-peer:latest -f repairShopPeer/Dockerfile.ppc64le repairShopPeer/
    docker build -t web:latest -f web/Dockerfile.ppc64le web/
    docker build -t insurance-ca:latest -f insuranceCA/Dockerfile.ppc64le insuranceCA/
    docker build -t police-ca:latest -f policeCA/Dockerfile.ppc64le policeCA/
    docker build -t shop-ca:latest -f shopCA/Dockerfile.ppc64le shopCA/
    docker build -t repairshop-ca:latest -f repairShopCA/Dockerfile.ppc64le repairShopCA/
fi
