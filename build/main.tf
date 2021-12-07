variable "proxmox_url" {
  default = "https://192.168.5.15:8006"
  type = string
}

provider "proxmoxdanitso" {
  virtual_environment {
    endpoint = var.proxmox_url
    insecure = true
  }
}