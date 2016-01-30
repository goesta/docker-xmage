FROM ubuntu:14.04

RUN apt-get install -y software-properties-common \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && add-apt-repository ppa:webupd8team/java \
 && apt-get update && apt-get install -y \
    curl \
    jq \
    oracle-java8-installer \
    unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# XMage Defaults
ENV XMAGE_DOCKER_SERVER_ADDRESS="0.0.0.0" \
    XMAGE_DOCKER_SERVER_NAME="mage-server" \
    XMAGE_DOCKER_PORT="17171" \
    XMAGE_DOCKER_SECONDARY_BIND_PORT="17179"

WORKDIR /xmage

RUN curl http://xmage.de/xmage/config.json | jq '.XMage.location'  | xargs curl -L > xmage.zip ; unzip xmage.zip; rm xmage.zip

COPY dockerStartServer.sh /xmage/mage-server/

RUN chmod +x \
    /xmage/mage-server/startServer.sh \
    /xmage/mage-server/dockerStartServer.sh

ENV XMAGE_DOCKER_SERVER_ADDRESS="0.0.0.0" \
    XMAGE_DOCKER_SERVER_NAME="mage-server"

EXPOSE 17171 17179

WORKDIR /xmage/mage-server

CMD [ "./dockerStartServer.sh" ]