#!/bin/bash

# Ensure the system is up to date
sudo apt-get update && sudo apt-get upgrade -y

# Function to validate hostname
validate_hostname() {
    local hostname=$1
    if [[ $hostname =~ ^[a-zA-Z0-9-]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Prompt user for hostname
while true; do
    read -p "Enter a hostname (without 'pb-'): " userinput
    hostname="pb-$userinput"
    if validate_hostname "$hostname"; then
        break
    else
        echo "Invalid hostname. Please try again."
    fi
done

# Set the system's hostname
sudo hostnamectl set-hostname "$hostname"
echo "127.0.1.1 $hostname" | sudo tee -a /etc/hosts

# Set up VLAN 41 in /etc/network/interfaces.d/vlan and disable native LAN
sudo mkdir -p /etc/network/interfaces.d
cat <<EOL | sudo tee /etc/network/interfaces.d/vlan
auto eth0.41
iface eth0.41 inet dhcp
    vlan-raw-device eth0
EOL

# Disable native LAN
sudo ifdown eth0

# Install and configure Samba
sudo apt-get install -y samba
sudo smbpasswd -a $(whoami)

# Configure Samba share
cat <<EOL | sudo tee -a /etc/samba/smb.conf
[devshare]
   comment = PiBox Development Share
   path = /mnt/devshare
   browseable = yes
   read only = no
   guest ok = yes
EOL

# Restart Samba service
sudo systemctl restart smbd

echo "Setup complete. You can now connect to '\\\\fs1\\devshare\\pibox'."