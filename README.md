# Terraform AWS Network Infrastructure

## Overview
This repository contains Terraform code for provisioning **AWS network and compute resources** in different environments (`dev`, `stage`, `prod`).  
It is integrated with **GitHub Actions** to enable CI/CD automation for Terraform workflows.

The project is structured to support **modular and environment-specific deployments**.

---

## Project Structure

# Terraform AWS Network Infrastructure

## Overview
This repository contains Terraform code for provisioning **AWS network and compute resources** in different environments (`dev`, `stage`, `prod`).  
It is integrated with **GitHub Actions** to enable CI/CD automation for Terraform workflows.

The project is structured to support **modular and environment-specific deployments**.

---

## Project Structure

# Terraform AWS Network Infrastructure

## Overview
This repository contains Terraform code for provisioning **AWS network and compute resources** in different environments (`dev`, `stage`, `prod`).  
It is integrated with **GitHub Actions** to enable CI/CD automation for Terraform workflows.

The project is structured to support **modular and environment-specific deployments**.

---

## Project Structure

terraform-aws-network-infra/
│
├── .github/
│   └── workflows/
│       └── terraform-dev.yml
│
├── env/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── provider.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── dev.tfvars
│   ├── stage/
│   └── prod/
│
├── modules/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── README.md
└── terraform-workspace/



---

## CI/CD Workflow

- GitHub Actions automatically runs Terraform workflows for the `dev` environment.
- Workflow triggers:
  - On **push to `env/dev/**`**
  - On **pull request to `dev`**
  - Manually via **workflow_dispatch** (`plan`, `apply`, `destroy`)
- Steps included:
  1. Checkout code  
  2. Setup Terraform  
  3. Configure AWS credentials  
  4. Terraform init, validate, plan, apply/destroy  

---

## Prerequisites

- Terraform >= 1.14.x
- AWS CLI configured with IAM user having appropriate permissions
- Git and GitHub access
- GitHub repository secrets for CI/CD:

| Secret Name | Description |
|------------|-------------|
| AWS_ACCESS_KEY_ID | AWS Access Key ID |
| AWS_SECRET_ACCESS_KEY | AWS Secret Access Key |
| AWS_REGION | AWS Region (e.g., ap-south-1) |

---

## How to Use

### 1. Clone the Repository

git clone https://github.com/<your-username>/terraform-aws-network-infra.git
cd terraform-aws-network-infra

### 2. Switch to dev branch
git checkout dev

### 3. Make changes in dev environment

Edit files in:

env/dev/

### 4. Stage, commit, and push
git add env/dev/*
git commit -m "feat(terraform): <your message>"
git push origin dev


This will trigger GitHub Actions CI/CD automatically.

### 5. Manual Workflow Trigger

Go to GitHub Actions → Terraform Dev CI/CD → Run workflow and choose:

plan

apply

destroy

## Terraform Backend

S3 bucket: terraform-statefile-swapnil

State file path: prod/terraform.tfstate

Encryption: Enabled

State locking: Disabled (no DynamoDB table)

## Modules

All reusable Terraform resources are inside modules/ folder.

Example: VPC, Subnets, Security Groups, EC2 instances.

Modules are called from environment-specific folders (env/dev/, env/stage/, env/prod/).

## Best Practices

Always work on feature branches → PR → merge to dev.

Do not push directly to dev.

Run terraform validate and terraform plan before applying changes.

Keep secrets out of code (use GitHub Actions secrets).

## Notes

Dev environment CI/CD runs automatically.

For stage/prod environments, set up separate pipelines.

Terraform version used: 1.14.3

AWS region: ap-south-1

## References

Terraform Documentation

AWS Provider

GitHub Actions Documentation