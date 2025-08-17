#!/bin/bash

# Deploy script for Go API
# This script builds and deploys the API with zero downtime

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
API_DIR="/home/developer/workspace/api"
DEPLOY_DIR="/var/www/api"
SERVICE_NAME="go-api"
BINARY_NAME="api-server"

echo -e "${GREEN}=== Go API Deployment Script ===${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "$API_DIR/go.mod" ] && [ ! -f "$API_DIR/main.go" ]; then
    echo -e "${RED}Error: No Go project found in $API_DIR${NC}"
    echo "Please ensure your Go project is in the workspace/api directory"
    exit 1
fi

cd "$API_DIR"

# Step 1: Run tests
echo -e "${YELLOW}Step 1: Running tests...${NC}"
if su - developer -c "cd $API_DIR && go test ./..." > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Tests passed${NC}"
else
    echo -e "${RED}✗ Tests failed. Aborting deployment.${NC}"
    echo "Debug: Running tests with output..."
    su - developer -c "cd $API_DIR && go test ./..."
    exit 1
fi

# Step 2: Build the binary
echo -e "${YELLOW}Step 2: Building binary...${NC}"
if su - developer -c "cd $API_DIR && go build -o $BINARY_NAME main.go"; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}✗ Build failed. Aborting deployment.${NC}"
    exit 1
fi

# Step 3: Backup current version
echo -e "${YELLOW}Step 3: Backing up current version...${NC}"
if [ -f "$DEPLOY_DIR/$BINARY_NAME" ]; then
    cp "$DEPLOY_DIR/$BINARY_NAME" "$DEPLOY_DIR/$BINARY_NAME.backup"
    echo -e "${GREEN}✓ Backup created${NC}"
else
    echo -e "${YELLOW}⚠ No existing binary to backup (first deployment)${NC}"
fi

# Step 4: Deploy new binary
echo -e "${YELLOW}Step 4: Deploying new binary...${NC}"
cp "$API_DIR/$BINARY_NAME" "$DEPLOY_DIR/$BINARY_NAME.new"
chmod +x "$DEPLOY_DIR/$BINARY_NAME.new"
chown www-data:www-data "$DEPLOY_DIR/$BINARY_NAME.new"

# Step 5: Atomic swap
mv "$DEPLOY_DIR/$BINARY_NAME.new" "$DEPLOY_DIR/$BINARY_NAME"
echo -e "${GREEN}✓ Binary deployed${NC}"

# Step 6: Restart service
echo -e "${YELLOW}Step 5: Restarting service...${NC}"
sudo systemctl restart "$SERVICE_NAME"
sleep 2

# Step 7: Health check
echo -e "${YELLOW}Step 6: Performing health check...${NC}"
if curl -f -s https://safronov.nl/health > /dev/null; then
    echo -e "${GREEN}✓ Health check passed${NC}"
else
    echo -e "${RED}✗ Health check failed. Rolling back...${NC}"
    
    # Rollback
    if [ -f "$DEPLOY_DIR/$BINARY_NAME.backup" ]; then
        mv "$DEPLOY_DIR/$BINARY_NAME.backup" "$DEPLOY_DIR/$BINARY_NAME"
        sudo systemctl restart "$SERVICE_NAME"
        echo -e "${YELLOW}Rollback completed${NC}"
    fi
    exit 1
fi

# Step 8: Cleanup
echo -e "${YELLOW}Step 7: Cleaning up...${NC}"
rm -f "$API_DIR/$BINARY_NAME"
echo -e "${GREEN}✓ Cleanup complete${NC}"

echo ""
echo -e "${GREEN}=== Deployment Successful! ===${NC}"
echo -e "API is now running at:"
echo -e "  ${GREEN}https://safronov.nl/api${NC} (Primary - HTTPS)"
echo -e "  ${GREEN}https://www.safronov.nl/api${NC} (WWW)"
echo -e "  ${GREEN}https://api.safronov.nl/api${NC} (API subdomain)"
echo -e "Health check: ${GREEN}https://safronov.nl/health${NC}"
echo ""

# Show service status
sudo systemctl status "$SERVICE_NAME" --no-pager | head -n 5