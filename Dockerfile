FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN <<EOF
apt-get update -qq
apt-get install -yq --no-install-recommends \
    build-essential \
    openssl
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

USER ubuntu
WORKDIR /home/ubuntu/app

CMD ["/usr/bin/make"]
