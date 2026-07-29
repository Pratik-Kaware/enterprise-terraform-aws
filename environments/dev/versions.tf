terraform {
  # We require at least 1.10 to use the new native S3 state locking
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # The ~> operator means "allow any 5.x version, but do NOT upgrade to 6.0"
      version = "~> 5.0" 
    }
  }

  # This points Terraform to the bucket we just created
  backend "s3" {
    # REPLACE THIS with the exact bucket name you generated in Phase 2
    bucket       = "enterprise-tf-state-pratik"
    
    # This is the path inside the bucket where the state will live. 
    # Because this is the dev environment, we put it in a dev/ folder.
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    
    encrypt      = true
    
    # This single line replaces the need for DynamoDB!
    use_lockfile = true 
  }
}
