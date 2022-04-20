#!/bin/bash -e

echo "Starting Harness delegate..."
docker run -d --restart unless-stopped \
    --name "harness-delegate" \
    --hostname="$(hostname -f | head -c 63)" \
    --network nexus-network \
    -v $(pwd)/.config/certs/cert.crt:/usr/local/share/ca-certificates/nginx.crt \
    -e ACCOUNT_ID=7pgBmsbaSYK5ojDzpLv3pQ \
    -e ACCOUNT_SECRET=$(HARNESS_ACCOUNT_SECRET) \
    -e MANAGER_HOST_AND_PORT=https://app.harness.io/gratis \
    -e WATCHER_STORAGE_URL=https://app.harness.io/public/free/freemium/watchers \
    -e WATCHER_CHECK_LOCATION=current.version \
    -e DELEGATE_STORAGE_URL=https://app.harness.io \
    -e DELEGATE_CHECK_LOCATION=delegatefree.txt \
    -e DELEGATE_NAME=nexus-test \
    -e DELEGATE_PROFILE=18WRW9BgTNKdijbubcx1XA \
    -e DELEGATE_TYPE=DOCKER \
    -e DEPLOY_MODE=KUBERNETES \
    -e PROXY_MANAGER=true \
    -e POLL_FOR_TASKS=false \
    -e REMOTE_WATCHER_URL_CDN=https://app.harness.io/public/shared/watchers/builds \
    -e CDN_URL=https://app.harness.io \
    -e JRE_VERSION=1.8.0_242 \
    harness/delegate:latest

echo "Adding self signed cert to the delegate java key store..."
# Add certificate mounted to /usr/local/share/ca-certificates/nginx.crt to java trust store
# This should instead be performed in a delegate profile
JAVA_HOME=$(docker exec harness-delegate find /opt/harness-delegate -name 'jdk*' | tr -d '\r')
docker exec -w "$JAVA_HOME" harness-delegate bin/keytool -import -trustcacerts \
    -keystore lib/security/cacerts \
    -storepass changeit \
    -alias nexus \
    -file /usr/local/share/ca-certificates/nginx.crt \
    -noprompt