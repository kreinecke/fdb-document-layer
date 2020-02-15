#####################################
Testing FDB with mutual TLS enabled:
#####################################

######
Main FDB Container
######

Make sure main fdb container is started:
#Create network
docker network create fdb-net

docker create --name fdb --network fdb-net foundationdb/foundationdb:6.0.18
docker start -a fdb

#Attach with bash, then run "fdbcli"
docker exec -it fdb /bin/bash
fdbcli
#then from cli tool run "configure new single ssd" to init a new database

#open bash inside and cat contents of fdb.cluster.
#Pass this to the doc db layer container when creating it, using the FDB_CLUSTER_FILE_CONTENTS env variable (see below)

#####
Document Layer
####

To start the doc-layer with TLS, mount a host volume containing the certs

docker create -e FDB_CLUSTER_FILE_CONTENTS=docker:docker@172.18.0.2:4500 --name fdb-doc-layer --network fdb-net -p 27016:27016 -v ~/dev/git/fdb-doclayer-fork/packaging/docker/testcerts:/etc/secrets docker.io/kreinecke/fdb-document-layer-tls
docker start -a fdb-doc-layer

####
Client connection
####

To test client connection to document layer:
  
mongo --tls --tlsCertificateKeyFile client.pem --tlsCAFile ca.crt --verbose localhost:27016

