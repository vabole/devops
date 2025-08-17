# DevOps Documentation - Go API Server

**Complete documentation for a secure, production-ready Go API server with developer environment**

---

## 🚀 Project Overview

This repository contains comprehensive documentation for setting up and managing a production Go API server with:

- **Secure Ubuntu Server** with hardened security
- **Go Development Environment** with hot-reload and deployment automation  
- **HTTPS/SSL** with Let's Encrypt and Cloudflare
- **Developer-Friendly Workflow** with one-command deployment
- **Production Monitoring** and logging

## 📋 Quick Start

### For Server Administrators
1. **[Server Setup](docs/server-setup/server-setup.md)** - Complete Ubuntu server configuration
2. **[Quick Start Guide](docs/server-setup/quick-start.md)** - Fast deployment instructions
3. **[HTTPS Setup](docs/ssl-https/https-setup-complete.md)** - SSL/TLS configuration

### For Developers  
1. **[Developer Guide](docs/developer-environment/DEVELOPER_GUIDE.md)** - Complete development workflow
2. **[SSH Setup](docs/developer-environment/SSH_SETUP.md)** - Access configuration
3. **[Environment Setup](docs/developer-environment/developer-setup-complete.md)** - Development environment details

---

## 📁 Documentation Structure

```
docs/
├── server-setup/           # Server administration
│   ├── server-setup.md     # Complete server setup guide
│   └── quick-start.md      # Quick deployment guide
│
├── developer-environment/  # Developer workflow
│   ├── DEVELOPER_GUIDE.md  # Complete development guide
│   ├── SSH_SETUP.md        # SSH access configuration
│   ├── developer-setup-proposal.md       # Original design
│   └── developer-setup-complete.md       # Implementation summary
│
├── ssl-https/              # HTTPS/SSL configuration
│   ├── https-setup-complete.md           # Complete HTTPS setup
│   └── cloudflare-ssl-setup.md          # Cloudflare SSL options
│
└── scripts/                # Deployment automation
    ├── deploy.sh           # Zero-downtime deployment
    ├── rollback.sh         # Automatic rollback
    └── logs.sh             # Log management utility
```

---

## 🎯 What's Documented

### ✅ Server Security & Hardening
- **UFW Firewall** configuration
- **Fail2ban** brute force protection  
- **Automatic security updates**
- **System optimization** (sysctl, limits)
- **User permission management**

### ✅ Go Development Environment
- **Go 1.23.4** installation and configuration
- **Hot-reload development** with Air
- **Build automation** with Make
- **Environment management** (dev/prod configs)
- **SQLite database** setup

### ✅ Web Infrastructure
- **Nginx reverse proxy** configuration
- **Rate limiting** and security headers
- **HTTPS/SSL** with Let's Encrypt
- **Cloudflare integration** (CDN, DDoS protection)
- **Domain configuration** (safronov.nl)

### ✅ Developer Workflow
- **One-command deployment** (`deploy`)
- **Automatic testing** before deployment
- **Zero-downtime updates** with health checks
- **Automatic rollback** on failures
- **Log monitoring** and debugging tools

### ✅ Production Operations
- **Systemd service** management
- **Automatic certificate renewal**
- **Resource monitoring**
- **Security log analysis**
- **Backup strategies**

---

## 🔧 Technology Stack

### Infrastructure
- **OS**: Ubuntu Server (latest)
- **Web Server**: Nginx (reverse proxy)
- **SSL/TLS**: Let's Encrypt + Cloudflare
- **Firewall**: UFW + Fail2ban
- **Process Manager**: Systemd

### Development
- **Language**: Go 1.23.4
- **Hot Reload**: Air
- **Build Tool**: Make
- **Database**: SQLite
- **Version Control**: Git

### Security
- **SSL Certificates**: Let's Encrypt (auto-renewal)
- **CDN/Security**: Cloudflare (Full Strict mode)
- **Headers**: HSTS, X-Frame-Options, CSP
- **Access Control**: SSH keys, limited sudo
- **Monitoring**: Fail2ban, system logs

---

## 🌐 Live Environment

### Production Endpoints
- **Main API**: https://safronov.nl/api
- **WWW**: https://www.safronov.nl/api
- **API Subdomain**: https://api.safronov.nl/api
- **Health Check**: https://safronov.nl/health

### Development
- **Hot Reload**: http://localhost:8081 (when developing)
- **SSH Access**: `ssh developer@safronov.nl`
- **Workspace**: `/home/developer/workspace/`

---

## 🚀 Deployment Process

### Automated Deployment
```bash
# One command deployment
deploy

# What it does:
# 1. Runs tests
# 2. Builds Go binary  
# 3. Creates backup
# 4. Deploys atomically
# 5. Restarts service
# 6. Health check
# 7. Auto-rollback if failure
```

### Manual Operations
```bash
# Service management
api-status    # Check service status
api-restart   # Restart API service
api-logs      # View live logs

# Monitoring
sudo systemctl status go-api
sudo journalctl -u go-api -f
curl https://safronov.nl/health
```

---

## 📊 Features Implemented

### 🔒 Security Features
- ✅ **End-to-end HTTPS** (Browser ↔ Cloudflare ↔ Server)
- ✅ **Automatic SSL renewal** (90-day Let's Encrypt certificates)
- ✅ **Firewall protection** (UFW + Fail2ban)
- ✅ **Security headers** (HSTS, XSS protection, etc.)
- ✅ **Non-root development** (limited permissions)

### 🛠️ Developer Experience  
- ✅ **Hot reload development** (instant code changes)
- ✅ **One-command deployment** (fully automated)
- ✅ **Environment isolation** (dev vs production)
- ✅ **Automatic testing** (before deployment)
- ✅ **Zero-downtime updates** (atomic deployment)

### 🚀 Production Features
- ✅ **High availability** (automatic restart on failure)
- ✅ **Performance optimization** (HTTP/2, compression)
- ✅ **Global CDN** (Cloudflare)
- ✅ **DDoS protection** (Cloudflare)
- ✅ **Rate limiting** (API protection)

### 📈 Monitoring & Operations
- ✅ **Health monitoring** (automated checks)
- ✅ **Log aggregation** (centralized logging)
- ✅ **Performance metrics** (via Cloudflare)
- ✅ **Security monitoring** (Fail2ban alerts)
- ✅ **Certificate monitoring** (auto-renewal alerts)

---

## 🎓 Learning Resources

### Documentation Deep Dives
- **[Complete Server Setup](docs/server-setup/server-setup.md)** - Step-by-step server configuration
- **[Developer Workflow](docs/developer-environment/DEVELOPER_GUIDE.md)** - Complete development guide
- **[HTTPS Implementation](docs/ssl-https/https-setup-complete.md)** - SSL/TLS setup details

### Scripts & Automation
- **[Deployment Script](docs/scripts/deploy.sh)** - Zero-downtime deployment
- **[Rollback Script](docs/scripts/rollback.sh)** - Automatic rollback
- **[Log Viewer](docs/scripts/logs.sh)** - Log management utility

---

## 🔧 Customization

### Adapting for Your Use Case
1. **Change domain**: Update Nginx configs and SSL certificates
2. **Different database**: Modify environment variables and dependencies
3. **Additional services**: Add new systemd services and Nginx locations
4. **Scaling**: Add load balancer and multiple servers
5. **Monitoring**: Integrate Prometheus, Grafana, or other tools

### Environment Variables
```bash
# Development (.env.development)
PORT=8081
DB_PATH=./data/api_dev.db
GIN_MODE=debug

# Production (.env.production)  
PORT=8080
DB_PATH=/var/www/api/data/api_prod.db
GIN_MODE=release
```

---

## 🆘 Troubleshooting

### Common Issues
- **SSL certificate problems**: Check renewal logs and Cloudflare settings
- **Deployment failures**: Review test output and service logs
- **Access issues**: Verify SSH keys and firewall rules
- **Performance problems**: Check resource usage and Cloudflare analytics

### Support Resources
- **Server logs**: `sudo journalctl -u go-api -f`
- **SSL logs**: `sudo journalctl -u certbot.service`
- **Security logs**: `sudo tail -f /var/log/auth.log`
- **Nginx logs**: `sudo tail -f /var/log/nginx/error.log`

---

## 📝 Contributing

### Documentation Updates
1. Make changes to relevant markdown files
2. Test any script modifications
3. Update version numbers and dates
4. Commit with descriptive messages

### Environment Replication
This documentation allows you to replicate the entire environment on any Ubuntu server by following the guides in sequence.

---

## 🏷️ Version Information

- **Created**: August 2025
- **Server OS**: Ubuntu (Linux 6.14.0-23-generic)
- **Go Version**: 1.23.4
- **Domain**: safronov.nl
- **SSL Provider**: Let's Encrypt + Cloudflare

---

## 📞 Quick Reference

### Essential Commands
```bash
# Deployment
deploy          # Deploy API to production
rollback        # Rollback to previous version

# Monitoring  
api-status      # Service status
api-logs        # Live logs
api-restart     # Restart service

# Development
make dev        # Hot reload development
make test       # Run tests
make build      # Build binary

# SSL Management
sudo certbot certificates              # View certificates
sudo systemctl status certbot.timer   # Check auto-renewal
```

### Important Paths
```
/var/www/api/                    # Production deployment
/home/developer/workspace/       # Development environment  
/etc/nginx/sites-available/api-https    # Nginx HTTPS config
/etc/letsencrypt/live/safronov.nl/      # SSL certificates
```

---

**This documentation represents a complete, production-ready Go API server with enterprise-grade security, developer productivity tools, and operational excellence.** 🚀

For questions or issues, refer to the detailed guides in the `docs/` directory or check the troubleshooting sections.