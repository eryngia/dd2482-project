terraform {
  required_providers {
    multipass = {
      source  = "todoroff/multipass"
      version = "~> 2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "multipass" {
  command_timeout = 1000
}

variable "image" {
  type    = string
  default = "ghcr.io/stefanprodan/podinfo:latest"
}

variable "container_port" {
  type    = number
  default = 9898
}

variable "host_port" {
  type    = number
  default = 8080
}

resource "local_file" "cloud_init" {
  filename = "${path.module}/.rendered_cloud_init.cfg"
  content = templatefile("${path.module}/cloud_init.tftpl", {
    image          = var.image
    container_port = var.container_port
    host_port      = var.host_port
  })
}

resource "multipass_instance" "springboot_vm" {
  name   = "springboot-vm"
  cpus   = 1
  memory = "1G"
  disk   = "5G"
  image  = "jammy" # Ubuntu 22.04 LTS
  cloud_init_file = local_file.cloud_init.filename
}

output "api_url" {
  value = "http://${one(multipass_instance.springboot_vm.ipv4)}:${var.host_port}"
}