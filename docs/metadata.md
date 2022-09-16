# Module Specifics

Core Version Constraints:
* `>= 1.0`

Provider Requirements:
* **aws (`hashicorp/aws`):** `~> 4.0`

## Input Variables
* `attributes` (default `[]`): Additional attributes (e.g. `1`)
* `bucket_name` (required): S3 bucket name i.e `mycompany.service.terraform`
* `delimiter` (default `"."`): Delimiter to be used between `name`, `namespace`, `stage`, etc.
* `dynamo_db_table_name` (default `"terraform-locking"`): DynamoDB table name used for Terraform state locking
* `environment` (default `""`): Environment or product (e.g.  `shared`, `organisation`)
* `kms_key_id` (default `""`): AWS KMS master key ID used for SSE-KMS encryption. The default aws/s3 AWS KMS master key is used if this element is absent
* `namespace` (default `""`): Namespace - typically the company name (e.g. `ume`)
* `readonly_access_arns` (default `[]`): IAM arns that have readonly access to this backend, typically used for remote state access from other accounts within the organisation
* `stage` (default `""`): Stage (e.g. `dev`, `test`, `prod`)
* `state_bucket_name` (default `""`): S3 state name to use. Required when not specifing `bucket_name` i.e `terraform`
* `tags` (default `{}`): Additional tags (e.g. map('BusinessUnit`,`XYZ`)
* `write_access_arns` (required): IAM arns that have write access to this backend, typically Terraform runners/service accounts

## Output Values
* `dynamodb_table_arn`: ARN of the DynamoDB table
* `dynamodb_table_id`: ID of the DynamoDB table
* `s3_state_bucket`
* `s3_state_bucket_name`

## Managed Resources
* `aws_dynamodb_table.tf_lock_state` from `aws`
* `aws_s3_bucket.tf_state_bucket` from `aws`
* `aws_s3_bucket_public_access_block.tf_state_private` from `aws`

## Data Resources
* `data.aws_iam_policy_document.s3_terraform_policy` from `aws`

## Child Modules
* `terraform_state_s3_label` from `git::https://github.com/cloudposse/terraform-null-label.git?ref=0.22.0`

