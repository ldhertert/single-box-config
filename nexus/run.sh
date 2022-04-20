export NEXUS_HOSTNAME="nexus-insecure.local"
export NEXUS_HTTP_PORT=8081
export NEXUS_DOCKER_PORT=8082
export NEXUS_DOCKER_REPO_NAME="docker"

export NGINX_INTERNAL_HOSTNAME="nexus.local"
export NGINX_EXTERNAL_HOSTNAME="nexus.local"
export NGINX_EXTERNAL_PORT=443

export NETWORK_NAME="nexus-network"

echo "Creating docker network..."
docker network create $NETWORK_NAME

./scripts/run-nexus.sh
./scripts/bootstrap-nexus.pwsh -hostname "http://$NEXUS_HOSTNAME:$NEXUS_HTTP_PORT" -reponame $NEXUS_DOCKER_REPO_NAME -dockerport $NEXUS_DOCKER_PORT

./scripts/create-certs.sh
./scripts/setup-proxy.sh
./scripts/start-delegate.sh


#cleanup command
# docker rm harness-delegate --force \
#     && docker rm nexus-proxy --force \
#     && docker rm nexus --force \
#     && docker network rm $NETWORK_NAME \
#     && rm -rf .config \
#     && rm -rf .data

