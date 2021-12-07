# Unattended Debian installation for proxmox cloud-init templates
If you like to setup a cloud-init template in Proxmox you can use this unattended installer.
## Create unattended .iso
````bash
cd ./debian-11/
./build-iso.sh
````
## Use unattended .iso
Upload ``debian-${version}-netinst-unattended.iso`` to your Proxmox storage and install your cloud-init template.   
I recommend an automated .iso upload with the Terraform module ``danitso/proxmox`` and VM build with the proxmox Packer module. 