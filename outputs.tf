output "s3_state_bucket_name" {
   value = join("", aws_s3_bucket.tf_state_bucket.*.id)
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = element(concat(aws_dynamodb_table.tf_lock_state.*.arn, [""]), 0)
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = element(concat(aws_dynamodb_table.tf_lock_state.*.id, [""]), 0)
}
