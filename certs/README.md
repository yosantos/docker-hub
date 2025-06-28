# SSL Setup for Docker Registry

## Option 1: Self-Signed Certificate (Development/Testing)

Generate a self-signed certificate:

```bash
# Create SSL directory
mkdir -p ssl

# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/registry.key \
  -out ssl/registry.crt \
  -subj "/C=ID/ST=JawaTengah/L=Semarang/O=DockerRegistry/CN=localhost"
```

## Option 2: Let's Encrypt Certificate (Production)

If you have a domain name pointing to your server:

```bash
# Install certbot
apt update && apt install certbot -y

# Get certificate
certbot certonly --standalone -d yourdomain.com

# Copy certificates to ssl directory
cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem ssl/registry.crt
cp /etc/letsencrypt/live/yourdomain.com/privkey.pem ssl/registry.key
```

## Option 3: Custom Certificate

Place your existing certificate files:
- `registry.crt` - Your certificate file
- `registry.key` - Your private key file

## After Setup

1. Update docker-compose.yaml to mount SSL certificates
2. Update nginx configuration for HTTPS
3. Restart containers: `docker compose down && docker compose up --build` 