terraform {
  required_version = ">= 1.4"

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

  backend "local" {}
}

provider "multipass" {
  command_timeout = 1000
}

variable "image" {
  type    = string
  default = "ghcr.io/eryngia/dd2482-project:latest"
}

variable "container_port" {
  type    = number
  default = 8080
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

resource "terraform_data" "image" {
  input = var.image
}

resource "multipass_instance" "project_vm" {
  name   = "project-vm"
  cpus   = 1
  memory = "1G"
  disk   = "5G"
  image  = "jammy" # Ubuntu 22.04 LTS
  cloud_init_file = local_file.cloud_init.filename

  lifecycle {
    replace_triggered_by = [terraform_data.image]
  }
}

output "api_url" {
  value = "http://${multipass_instance.project_vm.ipv4[0]}:${var.host_port}"
}