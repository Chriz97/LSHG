#!/bin/bash

# SSH 2FA Setup Script
# This script configures SSH with Google Authenticator-based 2FA and public key authentication.

echo "Starting SSH 2FA setup..."

# Step 1: Install Google Authenticator PAM Module
echo "Installing Google Authenticator PAM module..."
sudo apt update && sudo apt install libpam-google-authenticator -y

# Step 2: Configure Google Authenticator for the User
echo "Configuring Google Authenticator for the user..."
google-authenticator -t -d -f -r 3 -R 30 -W

# Step 3: Update PAM Configuration for SSH
echo "Updating PAM configuration for SSH..."
sudo bash -c 'cat << EOF > /etc/pam.d/sshd
# PAM configuration for SSH with Google Authenticator
auth required pam_google_authenticator.so
@include common-auth
@include common-account
@include common-session
@include common-password
EOF'

# Step 4: Update SSH Configuration
echo "Updating SSH configuration..."
sudo sed -i 's/#UsePAM yes/UsePAM yes/' /etc/ssh/sshd_config
sudo sed -i 's/UsePAM no/UsePAM yes/' /etc/ssh/sshd_config
sudo sed -i 's/#KbdInteractiveAuthentication yes/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config'

# Add AuthenticationMethods line if it doesn't exist
if ! grep -q "AuthenticationMethods" /etc/ssh/sshd_config; then
  echo "Adding AuthenticationMethods to sshd_config..."
  echo "AuthenticationMethods publickey,keyboard-interactive" | sudo tee -a /etc/ssh/sshd_config
fi

# Restart the SSH Service
echo "Restarting SSH service..."
sudo systemctl restart ssh

# Final Message
echo "SSH 2FA setup completed successfully!"
echo "Use your private key and TOTP code to log in."
echo "Ensure you have scanned the QR code using a TOTP app like Google Authenticator."

exit 0
