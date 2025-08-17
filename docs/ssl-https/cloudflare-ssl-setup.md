# Cloudflare SSL Setup Guide

## Current Setup Options

### Option 1: Cloudflare Only (NOT RECOMMENDED)
- Browser → Cloudflare: HTTPS ✅
- Cloudflare → Server: HTTP ❌
- **Risk**: Unencrypted data between Cloudflare and server

### Option 2: Full End-to-End Encryption (RECOMMENDED)
- Browser → Cloudflare: HTTPS ✅  
- Cloudflare → Server: HTTPS ✅
- **Benefit**: Complete security

## Easy Setup: Cloudflare Origin Certificate

### Steps:

1. **In Cloudflare Dashboard**:
   - Go to SSL/TLS → Origin Server
   - Click "Create Certificate"
   - Select RSA (2048)
   - Add domains: safronov.nl, www.safronov.nl
   - Set validity: 15 years
   - Download certificate files

2. **Set SSL Mode**:
   - Go to SSL/TLS → Overview
   - Set to "Full (strict)"

3. **Server Configuration**:
   - Install the Origin Certificate on server
   - Configure Nginx for HTTPS

## Alternative: Skip Server SSL (Simpler)

If you prefer simplicity:

1. **In Cloudflare Dashboard**:
   - Set SSL mode to "Full" (not strict)
   - Keep server on HTTP only

2. **Benefits**:
   - ✅ Users get HTTPS (encrypted to Cloudflare)
   - ✅ Simple server setup
   - ✅ Cloudflare handles SSL complexity

3. **Trade-offs**:
   - ⚠️ Server-to-Cloudflare not encrypted
   - ⚠️ Less secure for sensitive data

## Current Server Status

Your API is accessible at:
- http://safronov.nl/api (via Cloudflare)
- https://safronov.nl/api (via Cloudflare SSL)

Cloudflare automatically provides HTTPS for visitors!