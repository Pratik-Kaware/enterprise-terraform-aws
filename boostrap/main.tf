provider "aws" {
  region = "us-east-1"
}

# 1. The S3 Bucket for State Storage and Native Locking
resource "aws_s3_bucket" "terraform_state" {
  bucket = "enterprise-tf-state-pratik" 
}

# 2. Enable Versioning (Crucial for rollbacks if state gets corrupted)
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Enable Server-Side Encryption (State files contain sensitive data!)
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}