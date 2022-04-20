mkdir -p .data/etc

echo "nexus.scripts.allowCreation=true" > .data/etc/nexus.properties
echo "nexus.security.randompassword=false" >> .data/etc/nexus.properties

echo "Starting Nexus..."
docker run -d \
    --name nexus \
    --hostname "${NEXUS_HOSTNAME}" \
    --network nexus-network \
    -p "${NEXUS_HTTP_PORT}:8081" \
    -p "${NEXUS_DOCKER_PORT}:8082" \
    -v $(pwd)/.data:/nexus-data \
    --restart "on-failure" \
    sonatype/nexus3:3.38.1

echo "Waiting for nexus to be ready..."
(docker logs -f nexus &) | grep -q 'Started Sonatype Nexus'

echo "Nexus ready"

DEFAULT_PASSWORD=$(docker exec -it nexus cat /nexus-data/admin.password)
echo "The default Nexus admin password is ${DEFAULT_PASSWORD}"
echo "Host UI: http://localhost:${NEXUS_HTTP_PORT}/"
echo "Host Docker clients (insecure): http://localhost:${NEXUS_DOCKER_PORT}/"
echo "Internal container DNS:  http://${NEXUS_HOSTNAME}:8081, http://${NEXUS_HOSTNAME}:8082"
