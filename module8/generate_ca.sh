#!/bin/sh

set -eu

version=1.6.4 # cfssl version
arch=linux_amd64 # cfssl binary arch

install_cfssl() {
    if [ ! -f /usr/local/bin/cfssl ]; then
            if [ ! -f cfssl_${version}_${arch} ]; then
                curl -LO https://github.com/cloudflare/cfssl/releases/download/v${version}/cfssl_${version}_${arch}
            fi
            mv cfssl_${version}_${arch} /usr/local/bin/cfssl
            chmod +x /usr/local/bin/cfssl
    fi

    if [ ! -f /usr/local/bin/cfssljson ]; then
            if [ ! -f cfssljson_${version}_${arch} ]; then
                curl -LO https://github.com/cloudflare/cfssl/releases/download/v${version}/cfssljson_${version}_${arch}
            fi
            mv cfssljson_${version}_${arch} /usr/local/bin/cfssljson
            chmod +x /usr/local/bin/cfssljson
    fi
}


create_ca() {
    # config file define usages and expiry
    cat > ca-config.json <<EOF
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

    cat > ca-csr.json <<EOF
    {
        "CN": "Kubernetes",
        "key": {
            "algo": "rsa",
            "size": 2048
        },
        "names": [
            {
                "C": "China",
                "L": "Sh",
                "O": "Kubernetes",
                "OU": "CA",
                "ST": "Sh"
            }
        ]
    }
EOF

    # generate ca certificate
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca
}


install_cfssl
create_ca

set +eu
