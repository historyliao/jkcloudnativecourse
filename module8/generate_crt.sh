#!/bin/sh

set -eu

hosts=$1
commonname=$2

cat > ${commonname}-csr.json <<EOF
{
    "CN": "${commonname}",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "China",
            "L": "Sh",
            "O": "${commonname}",
            "OU": "${commonname}",
            "ST": "Sh"
        }
    ]
}
EOF

cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -hostname=${hosts} \
    -profile=kubernetes \
    ${commonname}-csr.json | cfssljson -bare /crts/${commonname}

cp /workdir/*.pem /crts/   
cp /workdir/ca-config.json /crts/ 

set +eu