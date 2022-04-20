Launches a local docker regisstry with self signed certificates and username/password auth.

See `run.sh` 

Example usage

```
# Install registry
./run.sh

# Login to local registry
echo "$DOCKER_PASSWORD" | docker login --username $DOCKER_USERNAME --password-stdin "$HOSTNAME:$PORT"

# Push image to local registry
docker pull alpine:latest
docker tag alpine:latest "$HOSTNAME:$PORT/alpine:latest"
docker push "$HOSTNAME:$PORT/alpine:latest"
```
