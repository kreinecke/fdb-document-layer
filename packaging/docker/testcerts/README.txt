To test client connection to document layer:

mongo --tls --tlsCertificateKeyFile client.pem --tlsCAFile ca.crt --verbose localhost:27016

To start the doc-layer with TLS, mount a host volume containing the certs

docker create -e FDB_CLUSTER_FILE_CONTENTS=docker:docker@172.18.0.2:4500 --name fdb-doc-layer --network fdb-net -p 27016:27016 -v ~/dev/git/fdb-doclayer-fork/packaging/docker/testcerts:/etc/secrets foundationdb/fdb-document-layer:1.7.2-testtls
docker start -a fdb-doc-layer
