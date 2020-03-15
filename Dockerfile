FROM ubuntu:latest

RUN apt-get update && apt-get install -y software-properties-common \
 && add-apt-repository ppa:openjdk-r/ppa \
 && apt-get update && apt-get install -y \
    curl \
    jq \
    openjdk-11-jdk \
    unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# XMage Defaults
ENV XMAGE_DOCKER_SERVER_ADDRESS="0.0.0.0" \
    XMAGE_DOCKER_PORT="17171" \
    XMAGE_DOCKER_SEONDARY_BIND_PORT="17179" \
    XMAGE_DOCKER_SERVER_NAME="mage-server"

WORKDIR /xmage

RUN curl http://xmage.de/xmage/config.json | jq '.XMage.location' | xargs curl -L > xmage.zip \
  ; unzip xmage.zip \
  ; rm xmage.zip

COPY dockerStartServer.sh /xmage/mage-server/

RUN chmod +x \
    /xmage/mage-server/startServer.sh \
    /xmage/mage-server/dockerStartServer.sh

EXPOSE 17171 17179

WORKDIR /xmage/mage-server

CMD [ "./dockerStartServer.sh" ]
