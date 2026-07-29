variable "vpc_cidr" {
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16)"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, stage, prod) used for tagging"
  type        = string
}

variable "public_subnets_cidr" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "A list of CIDR blocks for private subnets"
  type        = list(string)
}