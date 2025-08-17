# Quick Start Guide - Go API Deployment

## Prerequisites Completed
✅ Go 1.23.4 installed  
✅ Nginx configured as reverse proxy  
✅ Systemd service ready  
✅ Security hardening applied  
✅ Firewall configured  

---

## Deploy Your Go API in 5 Steps

### Step 1: Build Your Go Application
On your development machine:
```bash
# Example for a simple Go API
go mod init myapi
go build -o api-server main.go
```

### Step 2: Upload to Server
```bash
scp api-server root@your-server-ip:/var/www/api/
```

### Step 3: Set Permissions
On the server:
```bash
chown www-data:www-data /var/www/api/api-server
chmod +x /var/www/api/api-server
```

### Step 4: Start the Service
```bash
systemctl start go-api
systemctl enable go-api
```

### Step 5: Verify
```bash
# Check service status
systemctl status go-api

# Test the API
curl http://your-server-ip/api
```

---

## Sample Go API Code

Create a simple `main.go` for testing:

```go
package main

import (
    "encoding/json"
    "log"
    "net/http"
    "os"
)

type Response struct {
    Status  string `json:"status"`
    Message string `json:"message"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(Response{
        Status:  "healthy",
        Message: "API is running",
    })
}

func apiHandler(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(Response{
        Status:  "success",
        Message: "Welcome to the Go API",
    })
}

func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    http.HandleFunc("/health", healthHandler)
    http.HandleFunc("/api", apiHandler)
    http.HandleFunc("/api/", apiHandler)

    log.Printf("Server starting on port %s", port)
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        log.Fatal(err)
    }
}
```

---

## Environment Variables

Add custom environment variables to the service:

1. Edit the service file:
```bash
nano /etc/systemd/system/go-api.service
```

2. Add under `[Service]` section:
```ini
Environment="DB_HOST=localhost"
Environment="DB_USER=apiuser"
Environment="API_KEY=your-secret-key"
```

3. Reload and restart:
```bash
systemctl daemon-reload
systemctl restart go-api
```

---

## SSL/TLS Setup (Recommended)

For production, add HTTPS support:

```bash
# Install Certbot
apt install certbot python3-certbot-nginx

# Get SSL certificate
certbot --nginx -d your-domain.com

# Auto-renewal is configured automatically
```

---

## Monitoring

Check your API status:
```bash
# Service logs
journalctl -u go-api -f

# Nginx access logs
tail -f /var/log/nginx/access.log

# System resources
htop
```

---

## Useful Aliases

Add to `~/.bashrc` for convenience:
```bash
alias api-status='systemctl status go-api'
alias api-restart='systemctl restart go-api'
alias api-logs='journalctl -u go-api -f'
alias nginx-logs='tail -f /var/log/nginx/access.log'
```

---

## Support Ports

- **API runs on**: Port 8080 (internal)
- **Public access via**: Port 80 (HTTP) / 443 (HTTPS)
- **Nginx proxies**: /api/* → localhost:8080

---

## Next Steps

1. **Add database**: PostgreSQL, MySQL, or MongoDB
2. **Add caching**: Redis or Memcached
3. **Add monitoring**: Prometheus + Grafana
4. **Add CI/CD**: GitHub Actions or GitLab CI
5. **Add backup strategy**: Regular data backups