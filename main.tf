module "terraform_state_s3_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.22.0"
  namespace  = var.namespace
  environment= var.environment
  stage      = var.stage
  name       = var.state_bucket_name
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

locals {
  full_bucket_name = var.bucket_name != "" ? var.bucket_name : module.terraform_state_s3_label.id
}

data "aws_iam_policy_document" "s3_terraform_policy" {
  statement {
    sid     = "ListOnlyBuckets"
    actions = ["s3:ListBucket"]

    principals {
      type        = "AWS"
      identifiers = var.write_access_arns
    }

    resources = ["arn:aws:s3:::${local.full_bucket_name}"]
  }

  statement {
    sid     = "WriteAccess"
    actions = ["s3:GetObject", 
               "s3:PutObject"]

    principals {
      type        = "AWS"
      identifiers = var.write_access_arns
    }

    resources = ["arn:aws:s3:::${local.full_bucket_name}/*"]
  }  

  dynamic "statement" {
    for_each = var.readonly_access_arns
    iterator = arn
    content {
      actions = [
                "s3:GetBucketLocation", 
                "s3:ListBucket",
                "s3:GetObject"
                ]

      principals {
        type        = "AWS"
        identifiers = [arn.value]
      }

      resources = [
        "arn:aws:s3:::${local.full_bucket_name}",
        "arn:aws:s3:::${local.full_bucket_name}/*"
      ]
    }
  }
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = local.full_bucket_name
  policy = data.aws_iam_policy_document.s3_terraform_policy.json

  #logging {
  #  target_bucket = var.audit_access_bucket
  #  target_prefix = "log/"
  #}
  
  tags = {
    Description     = "Terraform S3 state backend bucket."
    Terraform       = "true"
  }
    
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_id
        sse_algorithm     = var.kms_key_id == "" ? "AES256" : "aws:kms"
      }
    }
  }
  
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_acl" "tf_state_bucket" {
  bucket = aws_s3_bucket.tf_state_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tf_state_bucket" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state_private" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  block_public_acls   = true
  block_public_policy = true

  ignore_public_acls  = true
  
}

resource "aws_dynamodb_table" "tf_lock_state" {
  name = var.dynamo_db_table_name

  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = var.dynamo_db_table_name
  }
}
