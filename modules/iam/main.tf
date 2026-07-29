# 1. The IAM Role (The Identity / The Jacket)
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-ec2-ssm-role"

  # Trust Policy: Who is allowed to assume this role?
  # We use jsonencode() to safely convert Terraform format into the JSON that AWS requires.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ec2-ssm-role"
    Environment = var.environment
  }
}

# 2. The Permission Policy Attachment (What can the jacket do?)
# We are attaching a pre-built AWS managed policy for Systems Manager (SSM)
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 3. The Instance Profile (The wrapper that connects the role to the EC2 instance)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}