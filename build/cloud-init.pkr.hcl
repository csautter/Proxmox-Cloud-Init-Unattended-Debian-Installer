source "proxmox" "cloud-init" {
  proxmox_url = "https://192.168.5.15:8006/api2/json"
  node = "proxmox-node"
  iso_file = "local:iso/debian-11.1.0-amd64-netinst-unattended.iso"
  insecure_skip_tls_verify = true
  pool = "proxmox-pool"
  vm_name = "cloud-init-template"
  vm_id = 1004
  memory = 2048
  cores = 2
  os = "l26"
  network_adapters {
    model = "e1000"
    bridge = "vmbr0"
  }
  disks {
    type = "scsi"
    disk_size = "10G"
    storage_pool = "local-zfs"
    storage_pool_type = "zfspool"
    format = "qcow2"
  }
  qemu_agent = true
  ssh_username = "root"
  ssh_password = "" # Set secure SSH Password!
  ssh_timeout = "1h"
  cloud_init = true
  cloud_init_storage_pool = "local"
  # unmount_iso = true
}

build {
  sources = [
    "source.proxmox.cloud-init"
  ]
}