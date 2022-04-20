echo "Generating SSL certificates..."
mkdir -p ./.config/certs
docker run -ti --rm -v $(pwd)/.config/certs:/apps -w /apps alpine/openssl \
    req  -newkey rsa:4096 -nodes -sha256 -x509 -days 365 \
        -keyout cert.key \
        -out cert.crt \
        -subj "/C=US/ST=CA/L=San Francisco/O=Harness/CN=${NGINX_INTERNAL_HOSTNAME}" \
        -addext "subjectAltName=DNS:${NGINX_INTERNAL_HOSTNAME},DNS:${NGINX_EXTERNAL_HOSTNAME}"

echo "Adding certificate to macos trust store"
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./.config/certs/cert.crt
