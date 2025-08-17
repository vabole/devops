# Ubuntu Server Setup Documentation

## Server Configuration for Go API Service
**Date**: August 17, 2025  
**OS**: Ubuntu (Linux 6.14.0-23-generic)  
**Purpose**: Secure server setup for hosting Go API with web and mobile app support

---

## 1. System Updates
- **Updated all system packages**: `apt update && apt upgrade`
- **Configured automatic security updates** via unattended-upgrades
  - Config: `/etc/apt/apt.conf.d/50unattended-upgrades`
  - Automatically installs security patches daily

---

## 2. Firewall Configuration (UFW)
- **Enabled UFW firewall** with strict default deny incoming policy
- **Allowed ports**:
  - SSH (22/tcp) - Remote administration
  - HTTP (80/tcp) - Web traffic
  - HTTPS (443/tcp) - Secure web traffic
- **Status check**: `ufw status verbose`

---

## 3. Intrusion Prevention (Fail2ban)
- **Installed fail2ban** for brute force attack protection
- **Configuration**: `/etc/fail2ban/jail.local`
- **Protected services**:
  - SSH - Max 3 attempts, 1-hour ban
  - Nginx - Rate limiting and bot protection
- **Monitor**: `fail2ban-client status`

---

## 4. Go Development Environment
- **Go Version**: 1.23.4
- **Installation path**: `/usr/local/go`
- **Environment variables**: `/etc/profile.d/go.sh`
  - PATH includes `/usr/local/go/bin`
  - GOPATH set to `$HOME/go`
- **Development tools**: build-essential, git, curl

---

## 5. Nginx Reverse Proxy
- **Purpose**: Reverse proxy for Go API on port 8080
- **Configuration files**:
  - `/etc/nginx/sites-available/api` - Main API configuration
  - `/etc/nginx/conf.d/security.conf` - Security hardening
- **Features**:
  - Rate limiting (10 requests/second per IP)
  - Security headers (X-Frame-Options, X-Content-Type-Options, etc.)
  - Request size limits (10MB max)
  - Connection limits (10 per IP)
- **API endpoint**: `http://server-ip/api`
- **Health check**: `http://server-ip/health`

---

## 6. Systemd Service for Go API
- **Service file**: `/etc/systemd/system/go-api.service`
- **Working directory**: `/var/www/api`
- **User**: www-data (non-privileged)
- **Features**:
  - Automatic restart on failure
  - Security sandboxing (PrivateTmp, ProtectSystem)
  - Resource limits configured
- **Service commands**:
  ```bash
  systemctl start go-api     # Start the service
  systemctl stop go-api      # Stop the service
  systemctl restart go-api   # Restart the service
  systemctl status go-api    # Check status
  systemctl enable go-api    # Enable on boot
  ```

---

## 7. System Security Hardening
### Kernel Parameters (`/etc/sysctl.d/99-security.conf`)
- IP spoofing protection enabled
- ICMP redirect protection
- TCP SYN cookies enabled
- Martian packet logging
- TCP optimization for API performance

### Resource Limits (`/etc/security/limits.d/99-api.conf`)
- File descriptor limits increased for www-data user
- Process limits configured for API service

---

## 8. Directory Structure
```
/var/www/api/              # API application directory
├── api-server             # Go binary (your compiled API)
└── data/                  # Data directory (writable by www-data)

/etc/nginx/                # Nginx configuration
├── sites-available/api    # API site configuration
├── sites-enabled/api      # Symlink to sites-available/api
└── conf.d/security.conf   # Security configurations

/root/doc/                 # Documentation directory
└── server-setup.md        # This file
```

---

## 9. Deployment Instructions

### To deploy your Go API:
1. Build your Go application:
   ```bash
   cd /path/to/your/api
   go build -o api-server
   ```

2. Copy the binary to the server:
   ```bash
   scp api-server root@server-ip:/var/www/api/
   chown www-data:www-data /var/www/api/api-server
   chmod +x /var/www/api/api-server
   ```

3. Start the service:
   ```bash
   systemctl enable go-api
   systemctl start go-api
   ```

4. Verify it's running:
   ```bash
   systemctl status go-api
   curl http://localhost:8080/health
   ```

---

## 10. Monitoring and Maintenance

### Log Files
- **Nginx access logs**: `/var/log/nginx/access.log`
- **Nginx error logs**: `/var/log/nginx/error.log`
- **Fail2ban logs**: `/var/log/fail2ban.log`
- **System logs**: `journalctl -u go-api`

### Regular Maintenance Tasks
1. **Check for updates**: `apt update && apt list --upgradable`
2. **Monitor fail2ban**: `fail2ban-client status sshd`
3. **Check firewall**: `ufw status verbose`
4. **API service logs**: `journalctl -u go-api -f`
5. **Nginx status**: `systemctl status nginx`

### Security Best Practices
1. **Regular updates**: System automatically updates security patches
2. **Monitor logs**: Check `/var/log/auth.log` for suspicious activity
3. **Backup configuration**: Keep copies of all config files
4. **SSL/TLS**: Consider adding Let's Encrypt SSL certificate for HTTPS
5. **API keys**: Store sensitive credentials in environment variables
6. **Database**: If using a database, ensure it's not exposed to the internet

---

## 11. Troubleshooting

### Common Issues and Solutions

**API not accessible**:
```bash
# Check if service is running
systemctl status go-api
# Check if port 8080 is listening
ss -tlnp | grep 8080
# Check Nginx proxy
curl http://localhost/api
```

**High load/Performance issues**:
```bash
# Check resource usage
htop
# Check connection count
ss -ant | grep :80 | wc -l
# Review rate limiting in Nginx
```

**Firewall blocking connections**:
```bash
# Check UFW rules
ufw status numbered
# Add new rule if needed
ufw allow from <IP> to any port <PORT>
```

---

## 12. Quick Reference Commands

```bash
# Service Management
systemctl start/stop/restart/status go-api
systemctl start/stop/restart/status nginx
systemctl start/stop/restart/status fail2ban

# Firewall
ufw status verbose
ufw allow <port>/<protocol>
ufw delete <rule-number>

# Logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
journalctl -u go-api -f
fail2ban-client status

# Go Development
go version
go build -o api-server
go run main.go
go test ./...

# System Info
df -h                    # Disk usage
free -h                  # Memory usage
htop                     # Process monitor
ss -tlnp                 # Network connections
```

---

## Notes
- Server requires reboot for kernel update (6.14.0-28-generic available)
- Consider setting up SSL/TLS certificates for production use
- Add monitoring solution (Prometheus, Grafana) for production
- Implement log rotation if not already configured
- Regular security audits recommended