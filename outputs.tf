output "s3_state_bucket_name" {
  value = join("", aws_s3_bucket.tf_state_bucket.*.id)
}