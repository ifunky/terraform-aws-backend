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

