#!/bin/bash

# Generate SSL Certificate for Docker Registry
echo "Generating self-signed SSL certificate for Docker Registry..."

# Create SSL directory if it doesn't exist
mkdir -p ssl

# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/registry.key \
  -out ssl/registry.crt \
  -subj "/C=ID/ST=JawaTengah/L=Semarang/O=DockerRegistry/CN=localhost"

# Set proper permissions
chmod 600 ssl/registry.key
chmod 644 ssl/registry.crt

echo "SSL certificate generated successfully!"
echo "Certificate: ssl/registry.crt"
echo "Private key: ssl/registry.key"
echo ""
echo "Next steps:"
echo "1. Run: docker compose down"
echo "2. Run: docker compose up --build"
echo "3. Test: curl -k https://localhost/v2/_catalog"
echo "4. Login: docker login localhost (will now use HTTPS)" 