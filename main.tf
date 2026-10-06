terraform {
  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = "~> 1.4.2"
    }
  }
}

provider "multipass" {}

resource "multipass_instance" "springboot_vm" {
  name   = "springboot-vm"
  cpus   = 2
  memory = "2G"
  disk   = "15G"
  image  = "jammy" # Ubuntu 22.04 LTS

  # Injects the configuration to install Docker inside the VM
  cloudinit_file = "${path.module}/cloud_init.cfg"
}

output "vm_ip" {
  value       = multipass_instance.springboot_vm.ipv4
  description = "The IP address of the actual VM"
}