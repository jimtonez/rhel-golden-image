# RHEL Golden Image Quick Start Guide

![RHEL](https://www.redhat.com/rhdc/managed-files/rhel-product-screen-v2-726x436.png)

This project provides instructions on how to build RHEL golden images using Packer and Ansible. For instructions on how to deploy RHEL 9 using the image builder, refer to the following documentation:

## RHEL Image Builder
[RHEL Image Builder](https://www.redhat.com/en/topics/linux/what-is-an-image-builder)

## Prerequisites
The following components are required for enabling programmatic access to the target environments:

### AWS
- Existing [AWS](https://aws.amazon.com/) account
- The `vpc_id` for an exisitng AWS VPC
- The `subnet_id` for the ec2 subnet
- IAM access / secret keypair
- IAM instance profile
