FROM ibm-semeru-runtimes:open-17-jre-focal
RUN apt-get update && apt-get upgrade -y && apt-get install -y tini gosu && apt-get clean
RUN yes | keytool -import -cacerts -trustcacerts -file /etc/ssl/certs/ca-certificates.crt -storepass changeit
ARG UID=1000
ARG GID=1000
COPY entrypoint.sh /
RUN curl -J https://meta.fabricmc.net/v2/versions/loader/1.18.1/0.12.12/0.10.2/server/jar -o /opt/fabric-launcher.jar
RUN groupadd -g $GID minecraft && useradd -r -u $UID -g $GID minecraft
VOLUME /minecraft
WORKDIR /minecraft

EXPOSE 25565 25575

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
