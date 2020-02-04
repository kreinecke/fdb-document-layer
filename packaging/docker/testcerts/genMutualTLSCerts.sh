#! /usr/bin/env bash

echo "Create the CA Key and Certificate for signing Client Certs"
openssl genrsa -des3 -out ca.key 4096
openssl req -new -x509 -days 365 -key ca.key -out ca.crt

echo "Create the Server Key, CSR, and Certificate"
openssl genrsa -des3 -out server.key 1024
openssl req -new -key server.key -out server.csr

echo "We're self signing our own server cert here.  This is a no-no in production."
openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

echo "Create the Client Key and CSR"
openssl genrsa -des3 -out client.key 1024
openssl req -new -key client.key -out client.csr

echo " Sign the client certificate with our CA cert.  Unlike signing our own server cert, this is what we want to do."
echo " Serial should be different from the server one, otherwise curl will return NSS error -8054"
openssl x509 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt

echo "Verify Server Certificate"
openssl verify -purpose sslserver -CAfile ca.crt server.crt

echo "Verify Client Certificate"
openssl verify -purpose sslclient -CAfile ca.crt client.crt

#all this is taken from https://github.com/nategood/sleep-tight/blob/master/scripts/create-certs.sh
#also see: https://gist.github.com/komuW/5b37ad11a320202c3408

