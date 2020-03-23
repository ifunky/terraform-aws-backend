variable "namespace" {
  description = "Namespace - typically the company name (e.g. `ume`)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment or product (e.g.  `shared`, `organisation`)"
  type        = string
  default     = ""
}

variable "stage" {
  description = "Stage (e.g. `dev`, `test`, `prod`)"
  type        = string
  default     = ""
}

variable "delimiter" {
  type        = string
  default     = "."
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
}

variable "state_bucket_name" {
    description = "S3 state name to use. Required when not specifing `bucket_name` i.e `terraform`"
    default     = ""
}

variable "bucket_name" {
    description = "S3 bucket name i.e `mycompany.service.terraform`"
}

variable "kms_key_id" {
  description = "AWS KMS master key ID used for SSE-KMS encryption. The default aws/s3 AWS KMS master key is used if this element is absent"
  default     = ""
}

variable "write_access_arns" {
  type        = list
  description = "IAM arns that have write access to this backend, typically Terraform runners/service accounts" 
}

variable "readonly_access_arns" {
  type        = list
  description = "IAM arns that have readonly access to this backend, typically used for remote state access from other accounts within the organisation"
  default     = []
}