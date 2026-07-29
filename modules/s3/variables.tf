variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique across all of AWS."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, stage, prod)"
  type        = string
}