# Cloudflare SSL Setup for Docker Registry

## Option 1: Cloudflare Origin Certificates (Recommended)

1. **Get Origin Certificate from Cloudflare Dashboard:**
   - Go to Cloudflare Dashboard → SSL/TLS → Origin Server
   - Click "Create Certificate"
   - Choose "15 years" validity
   - Add your domain(s)
   - Download the certificate and private key

2. **Place the certificates:**
   ```bash
   # Copy your Cloudflare origin certificate
   cp /path/to/your/origin-cert.pem ssl/registry.crt
   
   # Copy your Cloudflare private key
   cp /path/to/your/private-key.pem ssl/registry.key
   
   # Set proper permissions
   chmod 600 ssl/registry.key
   chmod 644 ssl/registry.crt
   ```

## Option 2: Cloudflare Full (Strict) SSL Mode

If you're using Full (strict) SSL mode with Cloudflare:

1. **Generate a self-signed certificate for origin server:**
   ```bash
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout ssl/registry.key \
     -out ssl/registry.crt \
     -subj "/C=ID/ST=JawaTengah/L=Semarang/O=DockerRegistry/CN=yourdomain.com"
   ```

2. **Configure Cloudflare:**
   - Set SSL/TLS mode to "Full (strict)"
   - Upload your self-signed certificate to Cloudflare

## Option 3: Cloudflare Proxy with HTTP Origin

If you want to use Cloudflare's proxy with HTTP backend:

1. **Update nginx config to only use HTTP** (remove SSL from nginx)
2. **Configure Cloudflare:**
   - Set SSL/TLS mode to "Flexible"
   - Enable "Always Use HTTPS" in SSL/TLS settings

## Current Configuration

Your current setup expects:
- `ssl/registry.crt` - Certificate file
- `ssl/registry.key` - Private key file

## Next Steps

1. Place your Cloudflare certificates in the `ssl/` directory
2. Update your domain in the nginx configuration
3. Restart the containers: `docker compose down && docker compose up --build` 