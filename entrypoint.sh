#!/bin/bash

set -eo pipefail

EULA_FILE=/minecraft/eula.txt
if [ "$EULA" == true ]; then
    if [ ! -f "$EULA_FILE" ]; then
        echo eula=$EULA > "$EULA_FILE"
    else
        if grep -q '^eula=' "$EULA_FILE" ; then
            sed -i "s/eula=.*/eula=$EULA/g" "$EULA_FILE"
        else
            echo eula=$EULA > "$EULA_FILE"
        fi
    fi
else
    echo "EULA not accepted"
    exit 1
fi

JAVA_OPTS=$(echo "$JAVA_OPTS" | tr -d '"')
chown -R minecraft: /minecraft
gosu minecraft:minecraft java -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3 $JAVA_OPTS -jar /opt/fabric-launcher.jar nogui
