#!/bin/bash
# Script to Install and Use AIDE (Advanced Intrusion Detection Environment)
# Tested on Fedora 41 and CentOS Stream 9

# Install AIDE
sudo dnf install -y aide

# Initialize the AIDE Database
sudo aide --init

# Move the AIDE Database to the Active Location
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# Configure AIDE with PERMS and FIPSR Rules
sudo bash -c 'cat << EOF >> /etc/aide.conf

# Define custom rules
PERMS = p+i+n+u+g+acl+selinux
FIPSR = p+i+n+u+g+s+m+c+acl+selinux+xattrs+sha256

# Apply rules to critical directories
/etc    PERMS
/var    FIPSR
EOF'

# Perform a System Integrity Check
sudo aide --check

# Update the AIDE Database
sudo aide --update
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# Set Up a Cron Job for Daily AIDE Checks
echo "0 3 * * * root /usr/sbin/aide --check" | sudo tee -a /etc/crontab

# Verify AIDE Configuration
sudo aide --config-check
