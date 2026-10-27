# Day 20: Terraform Variables and AWS

## Variables
- Defined in `variables.tf` using `variable "name" {}`
- Used in code as `var.name`
- Can be overridden at runtime: `terraform apply -var="name=value"`

## AWS Provider
- The syntax for AWS is identical to Docker (Provider -> Resources).
- `aws_instance` provisions an EC2 VM.
- `aws_security_group` provisions a firewall.
- Requires `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables to actually deploy.

## Modules (Next Step)
- Instead of copy-pasting code, Terraform Modules let you package and reuse infrastructure code.
