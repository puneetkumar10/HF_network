

function createOrgTourist {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/orgTourist.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/orgTourist.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-orgTourist --tls.certfiles ${PWD}/organizations/fabric-ca/orgTourist/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgTourist.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgTourist.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgTourist.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgTourist.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/orgTourist.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-orgTourist --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/orgTourist/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-orgTourist --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgTourist/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orgTourist --id.name orgTouristadmin --id.secret orgTouristadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orgTourist/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/orgTourist.example.com/peers
  mkdir -p organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-orgTourist -M ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/msp --csr.hosts peer0.orgTourist.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/orgTourist/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-orgTourist -M ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgTourist.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orgTourist/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/orgTourist.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgTourist.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/orgTourist.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgTourist.example.com/tlsca/tlsca.orgTourist.example.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/orgTourist.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/peers/peer0.orgTourist.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/orgTourist.example.com/ca/ca.orgTourist.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/orgTourist.example.com/users
  mkdir -p organizations/peerOrganizations/orgTourist.example.com/users/User1@orgTourist.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-orgTourist -M ${PWD}/organizations/peerOrganizations/orgTourist.example.com/users/User1@orgTourist.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgTourist/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgTourist.example.com/users/User1@orgTourist.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/orgTourist.example.com/users/Admin@orgTourist.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orgTouristadmin:orgTouristadminpw@localhost:7054 --caname ca-orgTourist -M ${PWD}/organizations/peerOrganizations/orgTourist.example.com/users/Admin@orgTourist.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgTourist/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/orgTourist.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgTourist.example.com/users/Admin@orgTourist.example.com/msp/config.yaml

}


function createOrgToursChateau {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/orgToursChateau.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-orgToursChateau --tls.certfiles ${PWD}/organizations/fabric-ca/orgToursChateau/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgToursChateau.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgToursChateau.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgToursChateau.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgToursChateau.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-orgToursChateau --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/orgToursChateau/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-orgToursChateau --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgToursChateau/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orgToursChateau --id.name orgToursChateauadmin --id.secret orgToursChateauadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orgToursChateau/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/orgToursChateau.example.com/peers
  mkdir -p organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-orgToursChateau -M ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/msp --csr.hosts peer0.orgToursChateau.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/orgToursChateau/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-orgToursChateau -M ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgToursChateau.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orgToursChateau/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/tlsca/tlsca.orgToursChateau.example.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/peers/peer0.orgToursChateau.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/ca/ca.orgToursChateau.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/orgToursChateau.example.com/users
  mkdir -p organizations/peerOrganizations/orgToursChateau.example.com/users/User1@orgToursChateau.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-orgToursChateau -M ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/users/User1@orgToursChateau.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgToursChateau/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/users/User1@orgToursChateau.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/orgToursChateau.example.com/users/Admin@orgToursChateau.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orgToursChateauadmin:orgToursChateauadminpw@localhost:8054 --caname ca-orgToursChateau -M ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/users/Admin@orgToursChateau.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgToursChateau/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgToursChateau.example.com/users/Admin@orgToursChateau.example.com/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/example.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/example.com/orderers
  mkdir -p organizations/ordererOrganizations/example.com/orderers/example.com

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml


}
