# Day 19: Terraform Basics

## Core Concepts
- **Provider:** The plugin that connects Terraform to an API (Docker, AWS, GCP).
- **Resource:** The actual infrastructure object (a container, a server, a network).
- **State File (`terraform.tfstate`):** Terraform's memory. It keeps track of what it built. NEVER commit this to Git.

## The Workflow
1. `terraform init` — Downloads providers and sets up the directory.
2. `terraform plan` — Dry-run. Shows what WILL be created/changed/destroyed.
3. `terraform apply` — Executes the plan.
4. `terraform destroy` — Deletes everything in the state file.

## Idempotence
- Running `apply` multiple times with the same config does nothing.
- Changing the config causes Terraform to calculate the exact diff and update only what is needed.
- If a resource cannot be updated (like a Docker port), Terraform destroys and recreates it.

## Sanctions Workaround (Russia)
- Downloaded terraform binary from Yandex Mirror.
- Configured `~/.terraformrc` to use the Yandex provider registry:
```hcl
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
}
