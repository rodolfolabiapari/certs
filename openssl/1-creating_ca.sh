#!/bin/bash

# Application: Self-Signed Certificate
# Author: Rodolfo Labiapari Mansur
# Email: rodolfolabiapari@gmail.com
# Created: 12/15/2019
# Arguments: None
# Observations, Anotations:
#   - Every .crt is a .pem. It is the same file.


# Exit immediately if a command exits with a non-zero satus.
set -e


cat << EOF > ./ssl.conf
[ req ]
#default_bits           = 2048
#default_md             = sha256
#default_keyfile        = privkey.pem

# This will define the name of input forms
distinguished_name      = req_distinguished_name
# This will set a password and the alt_names with CA:FALSE and IP
attributes              = req_attributes

[ req_distinguished_name ]
countryName                     = Country Name (2 letter code)
countryName_min                 = 2
countryName_max                 = 2
stateOrProvinceName             = State or Province Name (full name)
localityName                    = Locality Name (eg, city)
0.organizationName              = Organization Name (eg, company)
organizationalUnitName          = Organizational Unit Name (eg, section)
commonName                      = Common Name (eg, fully qualified host name)
commonName_max                  = 64
emailAddress                    = Email Address
emailAddress_max                = 64

[ req_attributes ]
challengePassword               = A challenge password
challengePassword_min           = 4
challengePassword_max           = 20

req_extensions = v3_req

[ v3_req ]
subjectAltName = @alt_names
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
[alt_names]
# Example of ips for the certificate request
IP.1 = 10.0.0.20.
EOF






###  Generating the CA private key and the Certificate
# Generates a Private Key
openssl genrsa -out rootCA.key 4096

# Generates a CA (public certificate)
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 365 -out rootCA.crt

# Public key
# openssl rsa -in rootCA.key -pubout > rootCA.pub



### Generating the CSR (Certificate Sign Request) private key and request

#Generate a private key
openssl genrsa -out request.key 2048

# Generate a Certificate Sign Requist to CA sign the Cert
# The -new option indicates that a CSR is being generated.
openssl req -config ./ssl.conf -new -key request.key -out request.csr

# Showing the CSR
openssl req -text -verify -in request.csr

# Public key
# openssl rsa -in cert.key -pubout > rootCA.pub


# Does the Sign
openssl x509 -req -in request.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out cert.crt -days 365 -sha256 -extensions v3_req -extfile ssl.conf


# showing the certificate 
openssl x509 -text -in cert.crt

# Testing the validate of Certificate, if was Signed by a CA
openssl verify -verbose -CAFile rootCA.crt cert.crt
