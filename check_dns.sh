#!/bin/bash

# Function to check SSL certificate
check_ssl() {
    local domain="www.egohackers.com"
    echo "Checking SSL certificate for $domain..."
    
    # Use openssl to check certificate
    if echo | openssl s_client -connect ${domain}:443 -servername ${domain} 2>/dev/null | openssl x509 -noout -dates > /dev/null; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] SSL certificate is valid"
        return 0
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] SSL certificate check failed"
        return 1
    fi
}

# Function to check website availability
check_website() {
    local domain="www.egohackers.com"
    echo "Checking website availability for $domain..."
    
    if curl -s -I "https://${domain}" --max-time 10 > /dev/null; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Website is accessible"
        return 0
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Website is not accessible"
        return 1
    fi
}

# Function to check DNS records
check_dns() {
    local domain="egohackers.com"
    echo "Checking DNS records for ${domain}..."
    
    local result=$(dig TXT ${domain} +short)
    local www_result=$(dig www.${domain} CNAME +short)
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] DNS Results:"
    echo "TXT Record: $result"
    echo "WWW CNAME: $www_result"
    
    if [[ $www_result == *"ghs.googlehosted.com"* ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] DNS is correctly pointing to Google Sites"
        return 0
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] DNS configuration issue detected"
        return 1
    fi
}

# Main monitoring loop
echo "Starting monitoring for egohackers.com..."
echo "Checking SSL, website availability, and DNS every 60 seconds..."
echo "----------------------------------------"

while true; do
    echo "Running checks at $(date '+%Y-%m-%d %H:%M:%S')"
    echo "----------------------------------------"
    
    check_ssl
    check_website
    check_dns
    
    echo "----------------------------------------"
    echo "Waiting 60 seconds before next check..."
    sleep 60
done
