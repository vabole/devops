# Developer Guide - Go API Server

Welcome to the Go API development environment! This guide will help you get started with developing and deploying your API on this server.

---

## 🚀 Quick Start

### First Time Setup
1. **SSH into the server** using your SSH key:
   ```bash
   ssh developer@your-server-ip
   ```

2. **Navigate to your workspace**:
   ```bash
   api  # This takes you to /home/developer/workspace/api
   ```

3. **Start developing**:
   ```bash
   # Check the sample API
   go run main.go
   
   # Or use hot reload for development
   make dev
   ```

---

## 📁 Directory Structure

```
/home/developer/workspace/
├── api/                    # Your main API code
│   ├── main.go            # Sample API application
│   ├── go.mod             # Go module file
│   ├── Makefile           # Build automation
│   ├── .air.toml          # Hot reload configuration
│   ├── .env.development   # Development environment vars
│   ├── .env.production    # Production environment vars
│   ├── .gitignore         # Git ignore rules
│   └── data/              # SQLite database files
│
├── scripts/               # Deployment scripts
│   ├── deploy.sh          # Deploy to production
│   ├── rollback.sh        # Rollback to previous version
│   └── logs.sh            # View various logs
│
└── DEVELOPER_GUIDE.md     # This file
```

---

## 🛠️ Development Workflow

### Option 1: Hot Reload Development (Recommended)
Perfect for active development with instant feedback:

```bash
# Navigate to API directory
api

# Start development server with hot reload (port 8081)
make dev
# or
air

# Test your API
curl http://localhost:8081/api
curl http://localhost:8081/health
```

**Benefits:**
- ✅ Automatic restart on code changes
- ✅ Fast iteration cycle
- ✅ Debug mode enabled
- ✅ Separate from production

### Option 2: Manual Build & Test
For testing production builds:

```bash
# Build the binary
make build
# or
go build -o api-server main.go

# Run the built binary
./api-server

# Test
curl http://localhost:8080/api
```

---

## 🚀 Deployment

When you're ready to deploy your changes to production:

### One-Command Deployment
```bash
# From anywhere in your workspace
deploy

# This runs:
# 1. Tests your code
# 2. Builds the binary
# 3. Creates backup of current version
# 4. Deploys new version
# 5. Restarts the service
# 6. Performs health check
# 7. Rolls back if deployment fails
```

### Manual Deployment
```bash
# Run the deployment script directly
~/workspace/scripts/deploy.sh
```

### Rollback (if needed)
```bash
rollback
# or
~/workspace/scripts/rollback.sh
```

---

## 📊 Monitoring & Debugging

### View Logs
```bash
# API service logs (live)
api-logs

# Interactive log viewer
~/workspace/scripts/logs.sh

# Specific log types
sudo journalctl -u go-api -f          # API logs (live)
sudo journalctl -u go-api -n 100      # Last 100 API log entries
sudo tail -f /var/log/nginx/access.log # Nginx access logs
```

### Service Management
```bash
# Check API status
api-status

# Control the service
api-restart
api-stop
api-start

# Manual service control
sudo systemctl status go-api
sudo systemctl restart go-api
```

---

## 🔧 Available Commands & Aliases

### Quick Navigation
```bash
ws          # Go to workspace (/home/developer/workspace)
api         # Go to API directory (/home/developer/workspace/api)
```

### Development
```bash
gobuild     # Build the binary (go build -o api-server)
gotest      # Run tests (go test -v ./...)
gorun       # Run main.go (go run main.go)
```

### Deployment
```bash
deploy      # Deploy to production
rollback    # Rollback to previous version
```

### Service Management
```bash
api-status  # Check API service status
api-restart # Restart API service
api-logs    # View API logs (live)
api-stop    # Stop API service
api-start   # Start API service
```

### Git
```bash
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gl          # git log --oneline -10
```

---

## 📝 Makefile Targets

The included Makefile provides convenient development commands:

```bash
make help           # Show all available commands
make dev            # Start with hot reload
make build          # Build the binary
make run            # Run the application
make test           # Run tests
make test-coverage  # Run tests with coverage
make deploy         # Deploy to production
make rollback       # Rollback to previous version
make logs           # View API logs
make status         # Check service status
make clean          # Clean build artifacts
make deps           # Download dependencies
make tidy           # Tidy go modules
make fmt            # Format code
make init           # Initialize new project with Gin
```

---

## 🔄 Environment Management

### Development Environment
- **Port**: 8081 (separate from production)
- **Mode**: Debug mode with verbose logging
- **Database**: SQLite at `./data/api_dev.db`
- **Config**: `.env.development`

### Production Environment
- **Port**: 8080 (served via Nginx reverse proxy)
- **Mode**: Release mode
- **Database**: SQLite at `/var/www/api/data/api_prod.db`
- **Config**: `.env.production`
- **Access**: Available at `http://your-server-ip/api`

---

## 💾 Database (SQLite)

### Development Database
- **Location**: `/home/developer/workspace/api/data/api_dev.db`
- **Access**: Direct file access for development

### Production Database
- **Location**: `/var/www/api/data/api_prod.db`
- **Access**: Through deployed application only
- **Backup**: Automatically backed up during deployments

### Database Tools
```bash
# Install SQLite tools if needed
sudo apt install sqlite3

# Access development database
sqlite3 data/api_dev.db

# View production database (read-only)
sudo sqlite3 /var/www/api/data/api_prod.db
```

---

## 🔐 Security & Permissions

### What You Can Do
✅ Develop and test code in your workspace  
✅ Deploy to production using deployment scripts  
✅ View logs and monitor the API  
✅ Manage the go-api service (start/stop/restart)  
✅ Access development and production databases  

### What You Cannot Do
❌ Modify system configurations  
❌ Access other users' files  
❌ Install system packages (use Go modules instead)  
❌ Modify Nginx or firewall settings  

### File Permissions
- **Your workspace**: Full read/write access
- **Production deployment**: Write access via group membership
- **System configs**: Read-only access
- **Logs**: Read access via sudo

---

## 🧪 Testing Your API

### Sample Endpoints
The included `main.go` provides these endpoints:

```bash
# Development (hot reload)
curl http://localhost:8081/health
curl http://localhost:8081/api

# Production (HTTPS)
curl https://safronov.nl/health
curl https://safronov.nl/api
curl https://www.safronov.nl/api
curl https://api.safronov.nl/api
```

### Response Format
```json
{
  "status": "success",
  "message": "Welcome to the Go API",
  "timestamp": "2025-08-17T09:15:30.123Z",
  "version": "1.0.0"
}
```

---

## 🔧 Customizing Your API

### Adding Dependencies
```bash
# Add Go modules
go get github.com/gin-gonic/gin
go get github.com/mattn/go-sqlite3
go mod tidy
```

### Environment Variables
Edit `.env.development` and `.env.production` for your needs:

```bash
# Development
nano .env.development

# Production  
nano .env.production
```

### Database Schema
Create your database schema in the development environment:

```bash
# Create/modify your database
sqlite3 data/api_dev.db
```

---

## 📋 Best Practices

### Development
1. **Always test locally first** using `make dev` or `air`
2. **Run tests before deploying** using `make test`
3. **Use environment variables** for configuration
4. **Commit changes to git** before deploying
5. **Check logs after deployment** using `api-logs`

### Deployment
1. **Deploy frequently** with small changes
2. **Monitor health checks** after deployment
3. **Keep rollback ready** - deployment script handles this
4. **Check logs immediately** after deployment
5. **Test endpoints** after each deployment

### Security
1. **Never commit secrets** to git
2. **Use environment variables** for sensitive data
3. **Test with non-privileged access** - your user has limited permissions
4. **Monitor logs** for suspicious activity

---

## 🆘 Troubleshooting

### Common Issues

**"Permission denied" errors**
```bash
# Check file ownership
ls -la

# Fix ownership if needed (for your workspace files)
sudo chown -R developer:developer /home/developer/workspace/
```

**"Port already in use"**
```bash
# Check what's using the port
sudo ss -tlnp | grep :8080

# Stop the service if needed
api-stop
```

**Deployment fails**
```bash
# Check the logs
api-logs

# Try rollback
rollback

# Check service status
api-status
```

**Can't access API externally**
```bash
# Check if service is running
api-status

# Check if Nginx is running
sudo systemctl status nginx

# Check firewall
sudo ufw status
```

### Getting Help

**View logs for errors:**
```bash
~/workspace/scripts/logs.sh  # Interactive log viewer
api-logs                     # Live API logs
```

**Check system status:**
```bash
api-status                   # API service status
sudo systemctl status nginx  # Nginx status
df -h                        # Disk usage
free -h                      # Memory usage
```

---

## 📚 Useful Resources

### Go Development
- [Go Documentation](https://golang.org/doc/)
- [Gin Web Framework](https://gin-gonic.com/)
- [SQLite Driver](https://github.com/mattn/go-sqlite3)

### Server Management
- [Systemd Service Management](https://www.freedesktop.org/software/systemd/man/systemctl.html)
- [Nginx Documentation](https://nginx.org/en/docs/)

### Tools
- [Air (Hot Reload)](https://github.com/air-verse/air)
- [Make Documentation](https://www.gnu.org/software/make/manual/)

---

## 🎯 Next Steps

1. **Explore the sample API** in `main.go`
2. **Try hot reload development** with `make dev`
3. **Deploy your first change** with `deploy`
4. **Monitor logs** with `api-logs`
5. **Customize the API** for your needs

Happy coding! 🚀