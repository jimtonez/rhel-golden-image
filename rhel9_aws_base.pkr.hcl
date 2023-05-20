packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "rhel-9-base"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "rhel9_base" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.small"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      image-id            = "ami-0858136e05d24c9c8"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username         = "ec2-user"
  ssh_interface        = "session_manager"
  communicator         = "ssh"
  iam_instance_profile = "myinstanceprofile"
}

build {
  name    = "rhel9-base"
  sources = [
    "source.amazon-ebs.rhel9_base"
  ]

  provisioner "shell" {
    inline = [
      "echo Provisioning RHEL9 Base AMI",
      "sudo dnf update -y",
    ]
  }
}