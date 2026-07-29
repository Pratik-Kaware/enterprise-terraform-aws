variable "environment" {
  description = "The environment name (e.g., dev, stage, prod)"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to attach to the instance"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile to attach"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.micro" # Enterprise safeguard: Defaulting to a Free Tier eligible instance
}