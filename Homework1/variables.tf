variable "region" {
  description = "AWS region for VMs"
  default = "us-east-1"
}

resource "tls_private_key" "annaops_consul_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "annaops_consul_key" {
  key_name   = "annaops_consul_key"
  public_key = tls_private_key.annaops_consul_key.public_key_openssh
}

resource "null_resource" "chmod_400_key" {
  provisioner "local-exec" {
    command = "chmod 400 ${path.module}/${local_file.private_key.filename}"
  }
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.annaops_consul_key.private_key_pem
  filename          = var.pem_key_name
}


variable "pem_key_name" {
  description = "name of ssh key to attach to hosts genereted during apply"
  default     = "annaops_consul.pem"
}

variable "key_name" {
  default     = "annaops_consul.pem"
  description = "name of ssh key to attach to hosts"
}


variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet" {
  default = "10.0.4.0/24"
}

variable "consul_version" {
  default = "1.8.5"
}
