# RHEL Golden Image Quick Start Guide

![RHEL](https://github.com/atriumgrid/knowledge-base/blob/dev/rhel.drawio.png)

This project provides instructions on how to build RHEL golden images using Packer and Ansible. For instructions on how to deploy RHEL using a no-code solution, refer to the following documentation: [RHEL Image Builder](https://www.redhat.com/en/topics/linux/what-is-an-image-builder)

## Prerequisites
The following components are required for enabling programmatic access to the target environments:

### AWS

- An existing [AWS](https://aws.amazon.com/) account
- A properly configured VPC and EC2 subnet
- A security group that allows temporary SSH connectivity from github
- An IAM access / secret keypair
- An IAM instance profile

## Workflow
This project allows for granular control over baseline and security relevant configurations through the use of certified ansible content. The ansible playbooks will harden a RHEL instance to meet industry compliance standards outlined in the CIS Benchmark for Red Hat Enterprise Linux:
[CIS Benchmark | Red Hat Enterprise Linux](https://www.cisecurity.org/benchmark/red_hat_linux)

![Packer Ansible Workflow](https://github.com/atriumgrid/knowledge-base/blob/dev/packer-ansible.drawio.png)

### Ansible roles
- [CIS Red Hat Enterprise Linux 9 Benchmark | Level 2 - Server](https://github.com/RedHatOfficial/ansible-role-rhel9-cis)

A RHEL golden image should include all of the relevant baseline, security, and application (optional) specific configurations and packages necessary to be secure by design in production and development environments. The use of ansible playbooks allows for graular control over these configurations.

### Playbook layering
Ansible playbooks enable consistant application of golden configurations throughout the lifecyle of the OS. There are three basic category of golden image ansible playbooks:

Category | Description
|:---|:-----
baseline | basic configurations common to all endpoints on the network inlcuding ssh, sudoers, local groups, authorized keys, proxy settings, endpoint protection, and logging agents.
security | OS accredidation and industry specific security configurations. For example, CIS, STIG, HIPAA, and other industry standard compliance automation and auditing tools.
application | Allow servers provisioned with the ami to join auto-scaling groups pre-configured with application components.

## Parameters
Key | Description | Required | Default
:---|:-----|:--------:|:-----------
`ami_image_id` | The Image ID of the rhel ami base image| `true` | `null`
`ami_prefix` | The prefix string for the golden image name | `true` | `rhel9-cis`
`aws_access_key` | The AWS Access Key ID of the IAM User  | `true` | `null`
`aws_region` | The AWS Region of the EC2 VPC Subnet | `true` | `us-east-2`
`aws_role_name` | The role name of the iam instance profile | `true` | `AWSPackerSSMRole`
`aws_secret_key` | The AWS Secret Access Key of the IAM User  | `true` | `null`
`aws_sg_id` | The Security Group ID for the EC2 private subnet | `true` | `null`
`aws_subnet_id` | The Subnet ID for the EC2 private subnet | `true` | `null`
`aws_vpc_id`| The VPC ID for the EC2 private subnet | `true` | `null`

## Examples
Example rhel ami source block as defined in rhel9_aws_cis.pkr.hcl
```hcl
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "rhel9_cis" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.small"
  region        = "${var.aws_region}"
  subnet_id     = "${var.aws_subnet_id}"
  vpc_id        = "${var.aws_vpc_id}"
  source_ami_filter {
    filters = {
      image-id            = "${var.ami_image_id}"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  security_group_id       = "${var.aws_sg_id}"
  ssh_username            = "ec2-user"
  temporary_key_pair_type = "ed25519"
  ssh_interface           = "public_ip"
  pause_before_ssm        = "2m"
  communicator            = "ssh"
  iam_instance_profile    = "${var.aws_role_name}"
}
```
Example rhel ami build block with the ansible provisioner as defined in rhel9_aws_cis.pkr.hcl
```hcl
build {
  name    = "rhel9-cis"
  sources = [
    "source.amazon-ebs.rhel9_cis"
  ]

  provisioner "shell" {
    inline = [
      "echo Provisioning RHEL 9 CIS AMI",
      "sudo dnf update -y"
    ]
  }

  provisioner "ansible" {
    playbook_file   = "./rhel9_aws_cis.yml"
    user            = "ec2-user"
    use_proxy       =  false
    extra_arguments = [ 
        "-vv",
    ]
  }

}
```