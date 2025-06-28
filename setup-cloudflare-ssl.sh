#!/bin/bash

# Cloudflare SSL Setup Script for Docker Registry
echo "Cloudflare SSL Setup for Docker Registry"
echo "========================================"

# Check if SSL directory exists
if [ ! -d "ssl" ]; then
    echo "Creating ssl directory..."
    mkdir -p ssl
fi

echo ""
echo "Please choose your Cloudflare SSL setup:"
echo "1. Cloudflare Origin Certificates (Recommended)"
echo "2. Cloudflare Full (Strict) SSL Mode"
echo "3. Cloudflare Proxy with HTTP Origin"
echo ""

read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo "=== Cloudflare Origin Certificates Setup ==="
        echo ""
        echo "1. Go to Cloudflare Dashboard → SSL/TLS → Origin Server"
        echo "2. Click 'Create Certificate'"
        echo "3. Choose '15 years' validity"
        echo "4. Add your domain(s)"
        echo "5. Download the certificate and private key"
        echo ""
        read -p "Enter path to your Cloudflare origin certificate: " cert_path
        read -p "Enter path to your Cloudflare private key: " key_path
        
        if [ -f "$cert_path" ] && [ -f "$key_path" ]; then
            cp "$cert_path" ssl/registry.crt
            cp "$key_path" ssl/registry.key
            chmod 600 ssl/registry.key
            chmod 644 ssl/registry.crt
            echo "✓ Certificates copied successfully!"
        else
            echo "✗ Error: Certificate files not found!"
            exit 1
        fi
        ;;
    2)
        echo ""
        echo "=== Cloudflare Full (Strict) SSL Mode Setup ==="
        echo ""
        read -p "Enter your domain name: " domain
        
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
          -keyout ssl/registry.key \
          -out ssl/registry.crt \
          -subj "/C=ID/ST=JawaTengah/L=Semarang/O=DockerRegistry/CN=$domain"
        
        chmod 600 ssl/registry.key
        chmod 644 ssl/registry.crt
        
        echo "✓ Self-signed certificate generated for $domain"
        echo "Now upload this certificate to Cloudflare SSL/TLS → Origin Server"
        ;;
    3)
        echo ""
        echo "=== Cloudflare Proxy with HTTP Origin Setup ==="
        echo "This option will remove SSL from nginx and use Cloudflare's proxy"
        echo ""
        read -p "Continue? (y/n): " confirm
        if [ "$confirm" = "y" ]; then
            # Create HTTP-only configuration
            cat > conf.d/default.conf << 'EOF'
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    location / {
      proxy_pass        http://registry:5000;
      proxy_set_header  Host $http_host;
      proxy_set_header  X-Real-IP $remote_addr;
      proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header  X-Forwarded_Proto $scheme;
      proxy_read_timeout 900;
    }
}
EOF
            echo "✓ HTTP-only configuration created"
            echo "Configure Cloudflare SSL/TLS mode to 'Flexible'"
        fi
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

echo ""
echo "Next steps:"
echo "1. Update your domain in conf.d/default.conf (replace 'your-domain.com')"
echo "2. Run: docker compose down"
echo "3. Run: docker compose up --build"
echo "4. Test: curl -k https://your-domain.com/v2/_catalog"
echo "5. Login: docker login your-domain.com" 