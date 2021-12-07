variable "target-node" {
  default = "proxmox-node"
  type = string
}

resource "proxmox_virtual_environment_file" "debian-10-net-install-unattended" {
  provider = proxmoxdanitso

  content_type = "iso"
  datastore_id = "local"
  node_name    = var.target-node

  source_file {
    path = "../debian-11/debian-11.1.0-amd64-netinst-unattended.iso"
  }
  depends_on = [null_resource.build-iso]
}

resource "null_resource" "build-iso" {
  provisioner "local-exec" {
    command = "cd ../debian-11 && ./build-iso.sh"
  }
}

resource "null_resource" "packer-build-qemu-enabled-template" {
  provisioner "local-exec" {
    command = "packer build cloud-init.pkr.hcl"
  }
  depends_on = [proxmox_virtual_environment_file.debian-10-net-install-unattended]
}