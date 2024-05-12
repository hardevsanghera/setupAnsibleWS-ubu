#!/bin/bash
# Setup an ansible Workstation on Ubuntu 24.04
set -x
cd ~

#Some queries
lsb_release -a
cat /etc/os-release

#Start installing software
sudo apt-get update
sudo apt-get -y install open-vm-tools-desktop sshpass openssh-server openssh-client coreutils curl

#xrdp
wget https://www.c-nergy.be/downloads/xRDP/xrdp-installer-1.5.zip
unzip xrdp-installer-1.5.zip 
chmod +x  xrdp-installer-1.5.sh
./xrdp-installer-1.5.sh
#./xrdp-installer-1.5.sh -r     (to remove the xrdp packages)

#Configure ssh server
sudo cp /etc/ssh/ssh_config /etc/ssh_ssh_config_org
#Uncomment #.  Passwordauthentication no to yes
sudo sed -i "s/\#   Passwordauthentication no/    Passwordauthentication yes/" /etc/ssh/ssh_config
sudo systemctl restart ssh
sudo systemctl enable ssh

#install ansible
#https://www.youtube.com/watch?v=1LhV87kjHlo
#Some queries
sudo apt-cache search ansible
sudo apt list ansible
sudo apt list available ansible
sudo apt install -y ansible
ansible --version
sudo apt list available ansible-core
sudo apt upgrade -y ansible
#cd to home folder of user (which allows sudo)
# cd /etc/ansible
#Nosuch file or directory
sudo mkdir -pv /etc/ansible
#sudo cd /etc/ansible
#sudo ls
#sudo bash -c "ansible-config init –disabled > /etc/ansible/ansible.cfg"
#vi hosts
#sudo bash -c "echo localhost ansible_connection=local >> /etc/ansible/ansible.cfg"
ansible all -m ping

#Python3
cd ~
sudo apt install -y python3 python3-pip

sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED
#the .12 is version specific

#setup for VMware
pip install pyvmomi
pip install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git
ansible-galaxy collection install community.vmware

#setup for Nutanix
#https://www.nutanix.dev/2022/08/05/getting-started-with-the-nutanix-ansible-module/
#1. Clone the GitHub repository to a local directory
#git clone https://github.com/nutanix/nutanix.ansible.git
#2. Git checkout release version
#cd nutanix.ansible
#ver="1.9.0"
#git checkout v$ver -b v$ver
#3. Build the collection
#sudo ansible-galaxy collection build
#4. Install the collection
#Note add --force option for rebuilding or reinstalling to overwrite existing data
#sudo ansible-galaxy collection install nutanix-ncp-$ver.tar.gz --force
ansible-galaxy collection install nutanix.ncp

#Install vscode
echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" | sudo \ tee /etc/apt/sources.list.d/vs-code.list
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg

#Add code to allow passwordless sudo for ubuadmin
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
#sudo apt-get update
#sudo apt-get install code
sudo snap install code --classic
#You will need to install your extensions
