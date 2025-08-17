#!/bin/bash

# Log viewer script for Go API
# Provides easy access to various logs

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== API Log Viewer ===${NC}"
echo ""
echo -e "${BLUE}Select log type:${NC}"
echo "1) API Service logs (live)"
echo "2) API Service logs (last 100 lines)"
echo "3) Nginx access logs (live)"
echo "4) Nginx error logs (live)"
echo "5) System logs (auth/security)"
echo "6) Fail2ban logs"
echo ""
read -p "Enter choice [1-6]: " choice

case $choice in
    1)
        echo -e "${YELLOW}Showing live API logs (Ctrl+C to exit)...${NC}"
        sudo journalctl -u go-api -f
        ;;
    2)
        echo -e "${YELLOW}Last 100 lines of API logs:${NC}"
        sudo journalctl -u go-api -n 100 --no-pager
        ;;
    3)
        echo -e "${YELLOW}Showing live Nginx access logs (Ctrl+C to exit)...${NC}"
        sudo tail -f /var/log/nginx/access.log
        ;;
    4)
        echo -e "${YELLOW}Showing live Nginx error logs (Ctrl+C to exit)...${NC}"
        sudo tail -f /var/log/nginx/error.log
        ;;
    5)
        echo -e "${YELLOW}Last 50 lines of auth logs:${NC}"
        sudo tail -n 50 /var/log/auth.log
        ;;
    6)
        echo -e "${YELLOW}Fail2ban status:${NC}"
        sudo fail2ban-client status
        echo ""
        echo -e "${YELLOW}Fail2ban SSH jail status:${NC}"
        sudo fail2ban-client status sshd
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac