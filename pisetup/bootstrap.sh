# Ensure apt is up to date and latest packages are installed
echo "Updating apt and upgrading packages"
sudo apt update
sudo apt upgrade -y

# Setup vlan
echo "Setting up vlan"      
sudo apt install vlan -y
echo "Copying vlan config to /etc/network/interfaces.d"
sudo cp vlan /etc/network/interfaces.d/vlan



# Install Debian package
echo "Installing any Debian packages in pisetup/ directory"
sudo dpkg -i setupfiles/*.deb

# Copy config.txt to /boot/firmware
# print message that we are copying config.txt
echo "Copying raspberry config.txt to /boot/firmware"
sudo cp config.txt /boot/firmware/config.txt

# copy mount-data.mount to /etc/systemd/system
echo "Copying pishare.mount to /etc/systemd/system"
sudo cp pishare.mount /etc/systemd/system/pishare.mount
echo Mounting pishare network folder to /pishare
sudo systemctl enable pishare.mount
sudo systemctl start pishare.mount

# activate pigpio daemon
echo "Activating pigpio daemon"
sudo systemctl enable pigpiod
sudo systemctl start pigpiod
