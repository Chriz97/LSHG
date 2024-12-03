#!/bin/bash
# This script is not an official tool provided by DISA or STIG Viewer.
# It is a custom implementation designed to help administrators verify compliance
# All commands tested on CentOS Stream 9,
# with STIG requirements for RHEL 9, based on information from:
# https://stigviewer.com/stig/red_hat_enterprise_linux_9/

# V-257879 RHEL-09-231190
# Verify the UUID and encryption type of a disk using blkid.
blkid
# Example output: Shows the UUID and TYPE, indicating encrypted partitions.

# V-257777 RHEL-09-211010
# Check the release version of the operating system.
cat /etc/redhat-release
# Expected output: Confirms the RHEL version. The RHEL version should still be within the maintenance period.

# V-257984 RHEL-09-255040
# Verify if empty passwords are allowed in the SSH configuration.
sudo /usr/sbin/sshd -dd 2>&1 | awk '/filename/ {print $4}' | tr -d '\r' | tr '\n' ' ' | xargs sudo grep -iH '^\s*permitemptypasswords'
# Expected result: `PermitEmptyPasswords no`. In case there is a different output which is not in compliance with STIG, the configuration file is at this location: etc/ssh/sshd_config

# V-257986 RHEL-09-255050
# Check if PAM is being used in the SSH configuration.
sudo /usr/sbin/sshd -dd 2>&1 | awk '/filename/ {print $4}' | tr -d '\r' | tr '\n' ' ' | xargs sudo grep -iH '^\s*usepam'
# Expected result: `UsePAM yes`. In case there is a different output which is not in compliance with STIG, the configuration file is at this location: etc/ssh/sshd_config

# V-258078 RHEL-09-431010
# Verify the current SELinux enforcement status.
getenforce
# Expected output: `Enforcing`. In case this output is: permissive, the SELINUX status has to be changed. This can be changed in the config file at this location: /etc/selinux/config

# V-258238 RHEL-09-672030
# Check the current cryptographic policy.
update-crypto-policies --show
# Expected output: `FIPS` if FIPS mode is enabled. If FIPS mode is not enabled (Output: Default). The command to change this is: sudo fips-mode-setup --enable

# V-257784 RHEL-09-211045
# Verify the Ctrl-Alt-Del action is disabled in the systemd configuration.
grep -i ctrl /etc/systemd/system.conf
# Expected result: `CtrlAltDelBurstAction=none`. Otherwise this can be changed in the configuration file: /etc/systemd/system.conf

# V-257785 RHEL-09-211050
# Check the status of the Ctrl-Alt-Del target.
sudo systemctl status ctrl-alt-del.target
# Expected result: `Loaded: masked`, meaning the target is disabled. In the case of another output, the following commands do the trick: sudo systemctl disable --now ctrl-alt-del.target and sudo systemctl mask --now ctrl-alt-del.target 

# V-258018 RHEL-09-271040
# Check if automatic login is disabled in GDM.
grep -i automaticlogin /etc/gdm/custom.conf
# Expected result: `AutomaticLoginEnable=false`. The line can be changed in the configuration file: /etc/gdm/custom.conf

# V-258059 RHEL-09-411100
# Verify if any non-root user has UID 0.
awk -F: '$3 == 0 {print $1}' /etc/passwd
# Expected output: Only `root`. If others are listed, this is a finding.

# V-257956 RHEL-09-252075
# Search for ".shosts" files, which should not exist.
sudo find / -name .shosts
# Expected output: No results. If found, this is a finding.

# V-257955 RHEL-09-252070
# Search for "shosts.equiv" files, which should not exist.
sudo find / -name shosts.equiv
# Expected output: No results. If found, this is a finding.

# V-257826 RHEL-09-215015
# Verify if the "ftp" package is installed.
sudo dnf list --installed | grep ftp
# Expected output: No results. If "ftp" is installed, this is a finding.

# V-257822 RHEL-09-214025
# Verify that `gpgcheck` is enabled in yum repository configurations.
grep gpgcheck /etc/yum.repos.d/*.repo | more
# Expected result: `gpgcheck=1` for all repositories. This option can be changed within repo configuration files.

# V-257821 RHEL-09-214020
# Check if local package GPG check is enabled in DNF configuration.
grep localpkg_gpgcheck /etc/dnf/dnf.conf
# Expected result: `localpkg_gpgcheck=1`. This option can be modified or added in the configuration file:  /etc/dnf/dnf.conf

# V-257820 RHEL-09-214015
# Verify that GPG check is enabled in DNF configuration.
grep gpgcheck /etc/dnf/dnf.conf
# Expected result: `gpgcheck=1`. This option can be modified or added in the configuration file:  /etc/dnf/dnf.conf

# V-258235 RHEL-09-672015
# Verify the integrity of the crypto-policies package.
rpm -V crypto-policies
# Expected output: No results. Any output indicates modified or missing files.

# V-257789 RHEL-09-212020
# Check GRUB superuser configurations.
sudo grep -A1 "superusers" /etc/grub2.cfg
# Expected result: Superuser configurations present.

# V-258230 RHEL-09-671010
# Verify if FIPS mode is enabled.
sudo fips-mode-setup --check
# Expected result: `FIPS mode is enabled`.

# V-257835 RHEL-09-215060
# Verify if the "tftp-server" package is installed.
sudo dnf list --installed | grep tftp-server
# Expected output: No results. If "tftp-server" is installed, this is a finding.

# V-258094 RHEL-09-611025
# Check PAM configurations for nullok, which allows empty passwords.
sudo grep -i nullok /etc/pam.d/system-auth /etc/pam.d/password-auth
# Expected output: No results. If "nullok" is present, this is a finding.
