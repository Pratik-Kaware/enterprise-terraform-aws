# 1. DATA SOURCE: Fetch the latest Amazon Linux 2023 AMI dynamically
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"] # Only trust official AMIs from AWS

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 2. The EC2 Instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  
  # Network placement
  subnet_id     = var.subnet_id
  
  # Firewall rules
  vpc_security_group_ids = [var.security_group_id]
  
  # Identity / Permissions (The jacket we built in Phase 6)
  iam_instance_profile = var.instance_profile_name

  tags = {
    Name        = "${var.environment}-app-server"
    Environment = var.environment
  }
}