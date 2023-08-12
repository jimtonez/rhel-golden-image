# RHEL Golden Image Quick Start Guide

![RHEL](https://www.redhat.com/rhdc/managed-files/rhel-product-screen-v2-726x436.png)

This project provides instructions on how to build RHEL golden images using Packer and Ansible. For instructions on how to deploy RHEL using the image builder, refer to the following documentation:

## RHEL Image Builder
[RHEL Image Builder](https://www.redhat.com/en/topics/linux/what-is-an-image-builder)

## Prerequisites
The following components are required for enabling programmatic access to the target environments:

### AWS

- An existing [AWS](https://aws.amazon.com/) account
- A properly configured VPC
- A properly configured EC2 subnet
- A security group that allows temporary SSH connectivity from github
- An IAM access / secret keypair
- An IAM instance profile

## Workflow
This project allows for granular control over baseline and security relevant configurations through the use of certified ansible content. The ansible playbooks will harden a RHEL instance to meet industry compliance standards outlined in the CIS Benchmark for Red Hat Enterprise Linux:
[CIS Benchmark | Red Hat Enterprise Linux](https://www.cisecurity.org/benchmark/red_hat_linux)

### Ansible roles
- [CIS Red Hat Enterprise Linux 9 Benchmark | Level 2 - Server](https://github.com/RedHatOfficial/ansible-role-rhel9-cis)

The desired state for a secure by design RHEL golden image consists of a standard baseline pre-configured with organizational, security, and application (optional) specific configurations:

## Parameters
Key | Description | Required | Default
:---:|:-----:|:--------:|:-----------:
`ami_image_id` | The Image ID of the rhel ami base image| `true` | `null`
`ami_prefix` | The prefix string for the golden image name | `true` | `rhel9-cis`
`aws_access_key` | The AWS Access Key ID of the IAM User  | `true` | `null`
`aws_region` | The AWS Region of the EC2 VPC Subnet | `true` | `us-east-2`
`aws_role_name` | The role name of the iam instance profile | `true` | `AWSPackerSSMRole`
`aws_secret_key` | The AWS Secret Access Key of the IAM User  | `true` | `null`
`aws_sg_id` | The Security Group ID for the EC2 private subnet | `true` | `null`
`aws_subnet_id` | The Subnet ID for the EC2 private subnet | `true` | `null`
`aws_vpc_id`| The VPC ID for the EC2 private subnet | `true` | `null`