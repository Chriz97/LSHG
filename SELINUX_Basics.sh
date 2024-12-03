#!/bin/bash
# SELinux Essentials Script for RHEL-based Distributions
# Commands tested on Cent OS Stream 9 and Fedora 41
# This script includes essential commands for managing  SELinux.

# 1. Check SELinux Status
# Displays the current mode and policy of SELinux.
sestatus

# 2. Get the Current SELinux Mode
# Prints the mode SELinux is currently enforcing.
getenforce

# 3. Set SELinux Mode to Permissive
# Permissive mode logs policy violations without enforcing them.
sudo setenforce 0
getenforce

# 4. Set SELinux Mode to Enforcing
# Enforcing mode applies all SELinux policies.
sudo setenforce 1
getenforce

# 5. Check SELinux Context of a File or Directory
# Use ls with the -Z flag to view SELinux contexts.
ls -Z /var/www/html

# 6. Change SELinux Context Temporarily
# Temporarily change the SELinux context of a file or directory.
sudo chcon -t httpd_sys_content_t /var/www/html/index.html
ls -Z /var/www/html/index.html

# 7. Restore Default SELinux Context
# Restore the default SELinux context for a file or directory.
sudo restorecon -v /var/www/html/index.html
ls -Z /var/www/html/index.html

# 8. Relabel File System
# Relabel the entire file system (may require reboot).
# Useful when transitioning to a new SELinux policy or fixing label mismatches.
sudo touch /.autorelabel

# 9. Generate Audit Logs for Denied Actions
# Shows the latest audit logs for SELinux denials.
sudo ausearch -m AVC,USER_AVC -ts recent

# 10. Troubleshoot Denials Using audit2allow
# Generate a potential SELinux policy rule to allow a denied action.
sudo ausearch -m AVC,USER_AVC -ts recent | audit2allow -m custom_policy

# 11. Enable SELinux Persistent Configuration
# Modify SELinux mode permanently in the configuration file.
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
cat /etc/selinux/config

# 12. List All Available SELinux Policies
# List available SELinux policies installed on the system.
semanage policylist
