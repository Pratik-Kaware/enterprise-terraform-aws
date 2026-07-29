variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, stage, prod) used for tagging"
  type        = string
}