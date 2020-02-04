To test client connection to document layer:

mongo --ssl --sslPEMKeyFile client.pem --sslCAFile ca.crt --sslPEMKeyPassword 1234 --verbose localhost:27016

