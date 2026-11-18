# EC2 Nginx Deployment with Terraform

This project provisions an Ubuntu 20.04 LTS EC2 instance in the AWS account's
existing default VPC, installs Nginx with `user_data`, and serves the assessment's
required welcome message. Terraform creates only the security group and EC2
instance; the VPC and default subnet are looked up, not created.

## Resources

- One `t2.micro` EC2 instance using the latest matching Ubuntu 20.04 LTS AMI
  published by Canonical for the selected region.
- One security group allowing HTTP (TCP port 80) from the internet and SSH
  (TCP port 22) only from the configured trusted CIDR.
- One Terraform output containing the instance's public IPv4 address.
- The EC2 instance and security group are tagged with `Name` and `ManagedBy`.

## Project files

- `main.tf`: AWS provider, default VPC/subnet and Ubuntu AMI lookups, security
  group, EC2 instance, and Nginx startup script.
- `variables.tf`: AWS region, instance type, and trusted SSH CIDR inputs.
- `outputs.tf`: instance public IP.
- `README.md`: setup, deployment, verification, submission, and cleanup steps.

## Prerequisites

- An AWS account and credentials for a non-root identity with permission to
  describe VPCs, subnets, and AMIs and to create, describe, and delete EC2
  instances and security groups.
- The default region is `ap-south-1` (Asia Pacific, Mumbai). The configuration
  uses the existing default VPC and selects its default subnet in
  `ap-south-1a`.
- In this AWS account, EC2 rejected `t2.micro` in `ap-south-1c` as unsupported.
  The subnet lookup is therefore restricted to `ap-south-1a`, an Availability
  Zone supported for this instance type in this account. If you change regions,
  update the Availability Zone filter in `main.tf` to a supported zone that has
  a default subnet; do not create a subnet or VPC for this assessment.
- Terraform CLI 1.5.0 or later and AWS CLI installed locally.
- Your public IPv4 address in CIDR notation for the SSH rule, usually `/32`.

Do not use root credentials, put credentials in Terraform files, or commit
credentials. Configure AWS CLI with a dedicated IAM Identity Center profile or
an appropriate course-provided identity. For a named AWS CLI profile, for
example:

```powershell
aws configure --profile terraform-assessment
$env:AWS_PROFILE = "terraform-assessment"
aws sts get-caller-identity
```

Run Terraform in the same PowerShell window where `AWS_PROFILE` is set. If you
configured the AWS CLI default profile instead, omit the `AWS_PROFILE` command.

## Configure SSH access

Create a local `terraform.tfvars` file in this directory (it is ignored by Git)
and set `ssh_allowed_cidr` to your public IPv4 address followed by `/32`:

```hcl
ssh_allowed_cidr = "YOUR_PUBLIC_IPV4/32"
```

Replace `YOUR_PUBLIC_IPV4` with your actual public IPv4 address before running
Terraform. Do not use `0.0.0.0/0` for SSH. The security-group rule only allows
network access; this project does not create an SSH key pair or configure SSH
login.

## Deploy

From this directory, run the assessment's Terraform commands:

```powershell
terraform init
terraform plan
terraform apply
```

Read the plan before applying. It should create only one security group and one
EC2 instance; it must not create a VPC, subnet, or internet gateway. Confirm the
`apply` prompt only after reviewing the proposed changes.

After deployment, Terraform displays `instance_public_ip`. Open
`http://<instance_public_ip>` in a browser. The page should show:

> Welcome to the Terraform-managed Nginx Server on Ubuntu

The Nginx installation runs during instance startup, so the page may take a few
minutes to become available. After verifying the page, save a screenshot as
`screenshots/nginx-working.png`. The image below is a submission placeholder
until that screenshot is added:

![Deployed Nginx welcome page](screenshots/nginx-working.png)

## Submission

Create a Git repository containing the Terraform files, `.terraform.lock.hcl`,
README, and deployment screenshot. Push it to GitHub and submit the repository
URL through the course portal.

## Destroy

When verification and screenshot capture are complete, remove the resources
created by this project:

```powershell
terraform destroy
```

Review the destroy plan and confirm the prompt. Verify in the AWS Console that
the instance and security group created by this project have been removed.

## Repository notes

Commit the Terraform configuration, README, and `.terraform.lock.hcl` after
running `terraform init`. Do not commit `.terraform/`, Terraform state files,
`terraform.tfvars`, AWS credentials, or other secrets. The deployment screenshot
should be added after you have successfully deployed and verified the site.