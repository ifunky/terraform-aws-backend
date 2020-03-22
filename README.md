<!-- Auto generated file -->

# AWS Terraform backend
 [![Build Status](https://circleci.com/gh/ifunky/terraform-aws-backend.svg?style=svg)](https://circleci.com/gh/ifunky/terraform-aws-backend-ami) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This module has been separated to get around the chicken and the egg situation when creating a new Terraform root project where by the state backend does not exists
to begin with. 

## Features

### S3 Backend Bucket

- Creates a non public bucket for the Terraform state.  The full bucket name is built by concatenating namespace, environment and bucket name
- Creates an S3 default policy with restricted permissions

### Cross Account Access
- Backend can optionally be shared with read acccess to other accounts (useful when using `terraform_remote_state`)

### DynomoDB Locking Information

- NOT IMPLEMENTED YET

## Initialising a New Project

To start a new terraform project and set a new backend run the following commands:

    terraform init -backend=false -var-file="backend.tfvars"
    terraform plan -out=backend.plan -target=module.backend -var-file="backend.tfvars"
    terraform apply backend.plan

backend.tfvars

    bucket = "COMPANY.development.terraform"
    key    = "state/terraform.tfstate"

For more information on Terraform partial backends see [Terraform Partial Backend]

[Terraform Partial Backend]: https://www.terraform.io/docs/backends/config.html



## Usage
```hcl
data "aws_organizations_organization" "default" {}

module "aws_terraform_backend" {
  source = "git::https://github.com/ifunky/terraform-aws-backend.git?ref=master"

  namespace            = "iFunky"   
  environment          = "development" 
  bucket_name          = "mycompany.product.terraform"
  state_bucket_name    = "terraform"
  
  # Optional if run inside an AWS organisation
  write_access_arns    = [var.terraform_role_arn]
  readonly_access_arns = data.aws_organizations_organization.default.accounts[*].id

  tags = {
    Terraform = "true"
  }
}
```


## Makefile Targets
The following targets are available: 

```
createdocs/help                Create documentation help
polydev/createdocs             Run PolyDev createdocs directly from your shell
polydev/help                   Help on using PolyDev locally
polydev/init                   Initialise the project
polydev/validate               Validate the code
polydev                        Run PolyDev interactive shell to start developing with all the tools or run AWS CLI commands :-)
```
# Module Specifics

Core Version Constraints:
* `~> 0.12.6`

Provider Requirements:
* **aws:** `~> 2.40`

## Input Variables
* `attributes` (required): Additional attributes (e.g. `1`)
* `bucket_name` (required): S3 bucket name i.e `mycompany.service.terraform`
* `delimiter` (default `"."`): Delimiter to be used between `name`, `namespace`, `stage`, etc.
* `environment` (required): Environment or product (e.g.  `shared`, `organisation`)
* `kms_key_id` (required): AWS KMS master key ID used for SSE-KMS encryption. The default aws/s3 AWS KMS master key is used if this element is absent
* `namespace` (required): Namespace - typically the company name (e.g. `ume`)
* `readonly_access_arns` (required): IAM arns that have readonly access to this backend, typically used for remote state access from other accounts within the organisation
* `stage` (required): Stage (e.g. `dev`, `test`, `prod`)
* `state_bucket_name` (required): S3 state name to use i.e `terraform`
* `tags` (required): Additional tags (e.g. map('BusinessUnit`,`XYZ`)
* `write_access_arns` (required): IAM arns that have write access to this backend, typically Terraform runners/service accounts

## Output Values
* `s3_state_bucket_name`

## Managed Resources
* `aws_s3_bucket.tf_state_bucket` from `aws`
* `aws_s3_bucket_public_access_block.tf_state_private` from `aws`

## Data Resources
* `data.aws_iam_policy_document.s3_terraform_policy` from `aws`

## Child Modules
* `terraform_state_s3_label` from `git::https://github.com/cloudposse/terraform-null-label.git?ref=master`

