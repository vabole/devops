# SSH Setup for Developer Access

## SSH Key Authentication Setup

### For the Developer (Local Machine)

1. **Generate SSH Key Pair** (if you don't have one):
```bash
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
```

2. **Copy Public Key to Server**:
```bash
# Option 1: Using ssh-copy-id (recommended)
ssh-copy-id developer@your-server-ip

# Option 2: Manual copy
cat ~/.ssh/id_rsa.pub | ssh root@your-server-ip "sudo -u developer mkdir -p /home/developer/.ssh && sudo -u developer cat >> /home/developer/.ssh/authorized_keys"
```

3. **Test SSH Connection**:
```bash
ssh developer@your-server-ip
```

### For the Server Administrator (This Server)

If you need to manually add SSH keys:

1. **Create SSH directory**:
```bash
sudo -u developer mkdir -p /home/developer/.ssh
sudo chmod 700 /home/developer/.ssh
```

2. **Add public key**:
```bash
sudo -u developer nano /home/developer/.ssh/authorized_keys
# Paste the developer's public key here
```

3. **Set permissions**:
```bash
sudo chmod 600 /home/developer/.ssh/authorized_keys
sudo chown developer:developer /home/developer/.ssh/authorized_keys
```

## Security Configuration

### SSH Server Configuration
The SSH server is configured with these security settings:

- **Password authentication**: Enabled (but key authentication preferred)
- **Root login**: PermitRootLogin yes (for initial setup)
- **Key authentication**: Enabled
- **Fail2ban protection**: Active

### Recommended: Disable Password Authentication (After Key Setup)
Once SSH keys are working, consider disabling password authentication:

```bash
# Edit SSH config
sudo nano /etc/ssh/sshd_config

# Set these values:
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

# Restart SSH service
sudo systemctl restart ssh
```

## Multiple Developers

To add multiple developers:

1. **Create additional users**:
```bash
sudo useradd -m -s /bin/bash -G www-data developer2
sudo mkdir -p /home/developer2/.ssh
sudo chmod 700 /home/developer2/.ssh
```

2. **Add their SSH keys**:
```bash
sudo nano /home/developer2/.ssh/authorized_keys
sudo chmod 600 /home/developer2/.ssh/authorized_keys
sudo chown developer2:developer2 /home/developer2/.ssh/authorized_keys
```

3. **Copy developer environment**:
```bash
sudo cp -r /home/developer/workspace /home/developer2/
sudo cp /home/developer/.bashrc /home/developer2/
sudo chown -R developer2:developer2 /home/developer2/
```

## SSH Client Configuration

### Recommended ~/.ssh/config (on developer's machine):
```
Host api-server
    HostName your-server-ip
    User developer
    Port 22
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

Now you can connect with:
```bash
ssh api-server
```

## Troubleshooting SSH

### Permission Issues
```bash
# On server - fix SSH directory permissions
sudo chmod 700 /home/developer/.ssh
sudo chmod 600 /home/developer/.ssh/authorized_keys
sudo chown -R developer:developer /home/developer/.ssh
```

### Connection Issues
```bash
# Check SSH service status
sudo systemctl status ssh

# Check SSH logs
sudo tail -f /var/log/auth.log

# Test SSH connection with verbose output
ssh -v developer@your-server-ip
```

### Fail2ban Issues
```bash
# Check if IP is banned
sudo fail2ban-client status sshd

# Unban IP if needed
sudo fail2ban-client set sshd unbanip YOUR_IP
```

## Current Credentials

**Temporary password for testing**: `Dev@2025Temp!`

⚠️ **Important**: Change this password or disable password authentication after setting up SSH keys!