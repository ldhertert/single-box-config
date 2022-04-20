echo "Customizing nginx configuration"
cp nginx.conf .config/nginx.conf
pushd ./.config
sed -i.bak "s/nexus-internal/${NEXUS_HOSTNAME}/" nginx.conf && rm nginx.conf.bak 
sed -i.bak "s/8081/${NEXUS_HTTP_PORT}/" nginx.conf && rm nginx.conf.bak 
sed -i.bak "s/8090/${NGINX_EXTERNAL_PORT}/" nginx.conf && rm nginx.conf.bak 
sed -i.bak "s/docker-repo/${NEXUS_DOCKER_REPO_NAME}/" nginx.conf && rm nginx.conf.bak 
popd

echo "Starting NGINX Proxy..."
docker run -d \
    --name nexus-proxy \
    --hostname "${NGINX_INTERNAL_HOSTNAME}" \
    --network nexus-network \
    -p "${NGINX_EXTERNAL_PORT}:${NGINX_EXTERNAL_PORT}" \
    -v $(pwd)/.config/certs:/etc/nginx/tls \
    -v $(pwd)/.config/nginx.conf:/etc/nginx/nginx.conf \
    --restart "on-failure" \
    nginx:latest

echo "You can view the Nexus UI here: https://${NGINX_EXTERNAL_HOSTNAME}:${NGINX_EXTERNAL_PORT}"
echo "Login via docker CLI by running 'docker login -u admin -p password \"${NGINX_EXTERNAL_HOSTNAME}:${NGINX_EXTERNAL_PORT}\"" 