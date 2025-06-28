#!/bin/bash

echo "Cloudflare Origin Certificate Setup"
echo "==================================="

# Check if SSL directory exists
if [ ! -d "ssl" ]; then
    echo "Creating ssl directory..."
    mkdir -p ssl
fi

echo ""
echo "Please follow these steps:"
echo "1. Go to Cloudflare Dashboard → SSL/TLS → Origin Server"
echo "2. Click 'Create Certificate'"
echo "3. Choose '15 years' validity"
echo "4. Add domains: mytishaina.web.id, hub.mytishaina.web.id"
echo "5. Download the Origin Certificate and Private Key"
echo ""

read -p "Enter path to your Origin Certificate file: " cert_path
read -p "Enter path to your Private Key file: " key_path

if [ -f "$cert_path" ] && [ -f "$key_path" ]; then
    echo "Copying certificates..."
    cp "$cert_path" ssl/cert.pem
    cp "$key_path" ssl/key.pem
    
    echo "Setting permissions..."
    chmod 600 ssl/key.pem
    chmod 644 ssl/cert.pem
    
    echo "✓ Certificates installed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Configure Cloudflare SSL/TLS mode to 'Full (strict)'"
    echo "2. Enable 'Always Use HTTPS' in Cloudflare"
    echo "3. Run: docker compose down"
    echo "4. Run: docker compose up --build -d"
    echo "5. Test: curl -k https://mytishaina.web.id/v2/_catalog"
else
    echo "✗ Error: Certificate files not found!"
    echo "Please check the file paths and try again."
    exit 1
fi 