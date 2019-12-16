#!/bin/bash -

cat << EOF > ca.config.json
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF


#TODO To test
cat << EOF > ca.csr.json
{
  "CN": "test.local",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "BR",
      "L": "BH",
      "O": "LxP",
      "OU": "DEV",
      "ST": "MG"
    }
  ]
}
EOF



#TODO To finish 

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca.key.pem \
  -config=ca.config.json \
  -profile=myprofile \
  cert-csr.json | cfssljson -bare cert

