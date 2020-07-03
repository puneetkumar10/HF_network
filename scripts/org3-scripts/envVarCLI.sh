#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
PEER0_OrgTourist_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/ca.crt
PEER0_OrgToursChateau_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/ca.crt
PEER0_ORG3_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  CORE_PEER_LOCALMSPID="OrdererMSP"
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  ORG=$1
  if [ $ORG -eq 1 ]; then
    CORE_PEER_LOCALMSPID="OrgTouristMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_OrgTourist_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgTourist.example.com/users/Admin@orgTourist.example.com/msp
    CORE_PEER_ADDRESS=peer0.orgTourist.example.com:7051
  elif [ $ORG -eq 2 ]; then
    CORE_PEER_LOCALMSPID="OrgToursChateauMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_OrgToursChateau_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgToursChateau.example.com/users/Admin@orgToursChateau.example.com/msp
    CORE_PEER_ADDRESS=peer0.orgToursChateau.example.com:9051
  elif [ $ORG -eq 3 ]; then
    CORE_PEER_LOCALMSPID="Org3MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    CORE_PEER_ADDRESS=peer0.org3.example.com:11051
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}
