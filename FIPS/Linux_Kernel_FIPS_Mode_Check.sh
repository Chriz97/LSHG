#!/bin/bash
# Script to check if Kernel FIPS mode is enabled

echo "Checking Kernel FIPS Mode Status..."

# Check the FIPS mode status from /proc/sys/crypto/fips_enabled
if [[ $(cat /proc/sys/crypto/fips_enabled) -eq 1 ]]; then
    echo "Kernel FIPS mode is ENABLED."
else
    echo "Kernel FIPS mode is DISABLED."
fi

# Check kernel boot parameters for fips=1
echo "Checking Kernel Boot Parameters for FIPS..."
grep -i fips /proc/cmdline > /dev/null
if [[ $? -eq 0 ]]; then
    echo "FIPS is configured in kernel boot parameters."
else
    echo "FIPS is NOT configured in kernel boot parameters."
fi

# Optional: Add a helpful note for further actions
echo "Note: If Kernel FIPS mode is required, ensure 'fips=1' is present in kernel boot parameters and reboot the system."
