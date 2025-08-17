#!/bin/bash

# Rollback script for Go API
# This script restores the previous version of the API

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DEPLOY_DIR="/var/www/api"
SERVICE_NAME="go-api"
BINARY_NAME="api-server"

echo -e "${YELLOW}=== Go API Rollback Script ===${NC}"
echo ""

# Check if backup exists
if [ ! -f "$DEPLOY_DIR/$BINARY_NAME.backup" ]; then
    echo -e "${RED}Error: No backup found at $DEPLOY_DIR/$BINARY_NAME.backup${NC}"
    echo "Cannot rollback without a backup"
    exit 1
fi

echo -e "${YELLOW}Rolling back to previous version...${NC}"

# Step 1: Restore backup
cp "$DEPLOY_DIR/$BINARY_NAME.backup" "$DEPLOY_DIR/$BINARY_NAME"
echo -e "${GREEN}✓ Previous version restored${NC}"

# Step 2: Restart service
echo -e "${YELLOW}Restarting service...${NC}"
sudo systemctl restart "$SERVICE_NAME"
sleep 2

# Step 3: Health check
echo -e "${YELLOW}Performing health check...${NC}"
if curl -f -s https://safronov.nl/health > /dev/null; then
    echo -e "${GREEN}✓ Health check passed${NC}"
else
    echo -e "${RED}✗ Health check failed after rollback${NC}"
    echo "Manual intervention may be required"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Rollback Successful! ===${NC}"
echo ""

# Show service status
sudo systemctl status "$SERVICE_NAME" --no-pager | head -n 5