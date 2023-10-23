#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Block all incoming HTTP and HTTPS traffic
iptables -I INPUT -p tcp --dport 80 -j DROP
iptables -I INPUT -p tcp --dport 443 -j DROP

# Cloudflare IP ranges https://www.cloudflare.com/ips/
CLOUDFLARE_IP_RANGES=(
"173.245.48.0/20"
"103.21.244.0/22"
"103.22.200.0/22"
"103.31.4.0/22"
"141.101.64.0/18"
"108.162.192.0/18"
"190.93.240.0/20"
"188.114.96.0/20"
"197.234.240.0/22"
"198.41.128.0/17"
"162.158.0.0/15"
"104.16.0.0/13"
"104.24.0.0/14"
"172.64.0.0/13"
"131.0.72.0/22"
)

# Allow Cloudflare's IP ranges for HTTP and HTTPS
for ip_range in "${CLOUDFLARE_IP_RANGES[@]}"; do
    iptables -I INPUT -p tcp --dport 80 -s $ip_range -j ACCEPT
    iptables -I INPUT -p tcp --dport 443 -s $ip_range -j ACCEPT
done

# Optional: Save the iptables rules
# Uncomment the line below if you want to save the rules
# iptables-save > /etc/iptables/rules.v4

echo "iptables rules updated to allow only Cloudflare IP ranges for HTTP and HTTPS."

