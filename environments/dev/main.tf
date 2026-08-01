# The AWS Provider
provider "aws" {
  region = "us-east-1"
}

# The Networking Module (VPC, Subnets, IGW, Route Tables)
module "networking" {
  source = "../../modules/networking"

  environment          = "dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.11.0/24", "10.0.12.0/24"]
}
# The Security Module
module "security" {
  source = "../../modules/security"

  environment = "dev"

  # Grabbing the output from the networking module above!
  vpc_id = module.networking.vpc_id
}

# The IAM Module
module "iam" {
  source = "../../modules/iam"

  environment = "dev"
}

# The Compute Module
module "compute" {
  source = "../../modules/compute"

  environment = "dev"

  # We use [0] to select the first private subnet from the list we created in Phase 4
  subnet_id = module.networking.private_subnet_ids[0]

  # Attaching the App Security Group from Phase 5
  security_group_id = module.security.app_sg_id

  # Attaching the IAM Identity from Phase 6
  instance_profile_name = module.iam.instance_profile_name
}


# The S3 Module (Application Storage)
module "s3_storage" {
  source = "../../modules/s3"

  environment = "dev"

  # REPLACE the identifier below to make this globally unique!
  bucket_name = "enterprise-app-data-pratik"
}

# The GitHub OIDC Module (For CI/CD Authentication)
module "github_oidc" {
  source = "../../modules/github-oidc"

  # REPLACE THIS with your exact GitHub username and repository name
  github_repo = "Pratik-Kaware/enterprise-terraform-aws"
}