# Developer Environment Setup Proposal

## Overview
Create a secure yet productive development environment where developers can code, test, and deploy their Go API directly on the server.

---

## Proposed Architecture

### 1. User Structure
- **Developer User**: `developer` (non-root)
  - Home directory: `/home/developer`
  - Member of: `www-data` group (for API file access)
  - Shell: bash with Go environment configured
  
### 2. Directory Layout
```
/home/developer/
├── workspace/           # Development area
│   ├── api/            # API source code
│   ├── scripts/        # Deployment scripts
│   └── .env            # Development environment vars
│
/var/www/api/           # Production deployment
├── api-server          # Current live binary
├── api-server.backup   # Previous version backup
└── data/              # Persistent data
```

### 3. Development Workflow

#### Option A: Manual Deployment (Recommended for Production-like)
1. Developer codes in `/home/developer/workspace/api/`
2. Run tests: `go test ./...`
3. Build: `go build -o api-server`
4. Deploy: `./scripts/deploy.sh` (automated script)
5. Service automatically restarts with new binary

#### Option B: Hot Reload Development (For Active Development)
1. Use `air` or `gin` for auto-reload during development
2. Develop on port 8081 (development port)
3. Test via `http://server:8081/api`
4. When ready, deploy to production port 8080

### 4. Permissions Strategy

#### Sudo Permissions (Limited)
Developer can only run specific commands:
- `sudo systemctl restart go-api`
- `sudo systemctl stop go-api`
- `sudo systemctl start go-api`
- `sudo systemctl status go-api`
- `sudo journalctl -u go-api`

#### File Permissions
- Read/Write: `/home/developer/workspace/`
- Write (via group): `/var/www/api/`
- No access: System configuration files

### 5. Development Tools

#### Pre-installed Tools
- Go 1.23.4 (already installed)
- Git for version control
- Make for build automation
- Air for hot-reload development
- Vim/Nano for quick edits
- htop for monitoring

#### Helper Scripts
1. **deploy.sh** - Build and deploy with zero downtime
2. **rollback.sh** - Restore previous version
3. **logs.sh** - View API and system logs
4. **test.sh** - Run tests before deployment

### 6. Security Measures

#### Access Control
- SSH key-only authentication (no passwords)
- Fail2ban monitors developer account
- Limited sudo access via sudoers file
- Cannot modify system configs

#### Deployment Safety
- Automatic backup before deployment
- Health check after deployment
- Automatic rollback on failure
- Git integration for version tracking

### 7. Environment Management

#### Development vs Production
- Development: `.env.development` (port 8081, debug mode)
- Production: `.env.production` (port 8080, release mode)
- Easy switching via environment scripts

### 8. Monitoring & Debugging

#### Available Tools
- Real-time logs: `tail -f` on API logs
- Debug mode for development
- Performance profiling with pprof
- Request tracing capabilities

---

## Benefits of This Setup

### For Developers
✅ Full development environment without root access  
✅ Easy deployment with single command  
✅ Hot-reload for rapid development  
✅ Version control integration  
✅ Rollback capability  

### For Security
✅ No root access required  
✅ Limited sudo permissions  
✅ Audit trail of deployments  
✅ Isolated development environment  
✅ Automatic backups  

### For Operations
✅ Zero-downtime deployments  
✅ Health checks built-in  
✅ Easy rollback mechanism  
✅ Centralized logging  
✅ Resource monitoring  

---

## Implementation Steps

1. Create developer user with proper groups
2. Set up directory structure
3. Configure limited sudo access
4. Install development tools (air, make)
5. Create deployment scripts
6. Set up Git repository
7. Configure environment files
8. Create documentation for developers
9. Test the complete workflow

---

## Alternative Considerations

### CI/CD Pipeline (Future Enhancement)
- GitHub/GitLab webhook for auto-deployment
- Automated testing before deployment
- Multiple environment support (dev/staging/prod)

### Container-Based (Docker)
- Develop in containers
- More isolation but added complexity
- Better for multiple projects

### Multiple Developers
- Each developer gets their own user
- Shared git repository on server
- Branch-based deployments

---

## Questions to Consider

1. **How many developers will use this server?**
   - Single: Simple setup as proposed
   - Multiple: Need user management strategy

2. **Deployment frequency?**
   - Frequent: Hot-reload is valuable
   - Occasional: Manual deployment sufficient

3. **Rollback requirements?**
   - Critical: Need multiple backup versions
   - Simple: Single backup sufficient

4. **Development style?**
   - Active development: Need hot-reload
   - Deploy-only: Simple scripts sufficient

---

## Recommendation

Implement the **Manual Deployment with Helper Scripts** approach:
- Balanced security and convenience
- Clear separation of development and production
- Easy to understand and maintain
- Suitable for small to medium teams

This setup allows developers to be productive while maintaining security best practices.