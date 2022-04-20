HOSTNAME="docker.127.0.0.1.nip.io"
DOCKER_USERNAME="admin"
DOCKER_PASSWORD="password"
PORT=5000

# Generate self signed certs
mkdir -p ./certs
docker run -ti --rm -v $(pwd)/certs:/apps -w /apps alpine/openssl \
    req  -newkey rsa:4096 -nodes -sha256 -x509 -days 365 \
    -keyout cert.key \
    -out cert.crt \
    -subj "/C=US/ST=CA/L=San Francisco/O=Harness/CN=${HOSTNAME}"


# add cert to trust store
# sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./certs/cert.crt

# Use htpasswd to create username and associated password 
mkdir -p ./auth
docker run --rm --entrypoint htpasswd httpd:2 -Bbn $DOCKER_USERNAME $DOCKER_PASSWORD > ./auth/htpasswd

# Start registry
mkdir -p ./data
docker run -d \
    -p 5000:5000 \
    --restart=always \
    --name registry \
    -v $PWD/certs:/certs \
    -v $PWD/auth:/auth \
    -v $PWD/data:/var/lib/registry \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/cert.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/cert.key \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    -e REGISTRY_AUTH=htpasswd \
    registry:2

# Login to local registry
# echo "$DOCKER_PASSWORD" | docker login --username $DOCKER_USERNAME --password-stdin "$HOSTNAME:$PORT"

# Push image to local registry
# docker pull alpine:latest
# docker tag alpine:latest "$HOSTNAME:$PORT/alpine:latest"
# docker push "$HOSTNAME:$PORT/alpine:latest"
