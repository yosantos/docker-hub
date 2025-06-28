# Docker Registry with Nginx Reverse Proxy

This project sets up a private Docker Registry secured with HTTPS and fronted by an Nginx reverse proxy.

## 📦 Features

- Docker Registry running in Docker
- Nginx reverse-proxy with your own SSL certificate
- Configurable domain via environment variable
- Clean Docker Compose deployment

---

## 🚀 Project Structure

```
.
├── certs/
│   ├── fullchain.pem         # Your SSL certificate (from Cloudflare)
│   └── privkey.pem           # Your SSL private key
├── data/                     # Registry storage (created automatically)
├── docker-compose.yml        # Compose configuration
├── nginx.conf                # Nginx template with variable substitution
└── .env                      # Optional: domain variable (DOMAIN)
```

---

## ⚙️ Prerequisites

- Docker and Docker Compose installed
- DNS A record pointing `hub.mytishaina.web.id` to this server
- SSL certificate and key copied into `certs/`

---

## 🛠️ Configuration

### Option 1: Using `.env`

Create a file called `.env`:

```
DOMAIN=hub.mytishaina.web.id
```

Docker Compose will automatically read this file.

---

### Option 2: Using Shell Environment Variable

Instead of `.env`, export the variable before running:

```bash
export DOMAIN=hub.mytishaina.web.id
```

or inline:

```bash
DOMAIN=hub.mytishaina.web.id docker-compose up -d
```

---

## ▶️ Starting the Services

From the project directory:

```bash
docker-compose up -d
```

---

## 📝 Nginx Configuration

The `nginx.conf` uses `${DOMAIN}` placeholders:

```nginx
server {
    listen 443 ssl;
    server_name ${DOMAIN};

    ssl_certificate /etc/nginx/certs/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    client_max_body_size 0;

    location / {
        proxy_pass https://registry:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_ssl_verify off;
    }
}

server {
    listen 80;
    server_name ${DOMAIN};
    return 301 https://${DOMAIN}$request_uri;
}
```

Docker's `nginx` image renders this template automatically.

---

## 🧪 Testing Your Registry

Log in from your client machine:

```bash
docker login hub.mytishaina.web.id
```

Tag and push an image:

```bash
docker tag alpine hub.mytishaina.web.id/my-alpine:latest
docker push hub.mytishaina.web.id/my-alpine:latest
```

---

## 🛡️ Tips

- Protect your registry with authentication (e.g., htpasswd).
- Make sure firewall allows ports 80 and 443.
- Regularly back up the `data/` directory.

---

## 🧠 Troubleshooting

- **Variable not replaced:** Ensure `.env` exists or `DOMAIN` is exported.
- **Certificate errors:** Verify paths and permissions of cert files.
- **Nginx fails to start:** Check logs:  
  ```bash
  docker-compose logs nginx
  ```
- **Cannot login:** Docker client must trust your certificate if it is self-signed.

---

## 🙌 Credits

Based on Docker Registry and Nginx best practices.
