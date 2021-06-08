ARG ARCH=
FROM ${ARCH}nginx

COPY get_kubectl.sh /usr/local/bin/get_kubectl.sh

RUN apt update && apt install -yqq \
    bridge-utils \
    iproute2 \
    iptables \
    curl \
    iputils-ping \
    iputils-arping \
    iputils-tracepath \
    tcpdump \
    jq \
    ca-certificates \
    wget && \
    get_kubectl.sh    
