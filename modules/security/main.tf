# 1. The Web Security Group (Public-facing)
resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-web-sg"
  description = "Security group for web servers allowing public HTTP/HTTPS"
  vpc_id      = var.vpc_id

  # Inbound HTTP from anywhere
  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTPS from anywhere
  ingress {
    description = "HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: Allow all traffic to leave the instance (AWS standard practice)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-web-sg"
    Environment = var.environment
  }
}

# 2. The Application Security Group (Internal only)
resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app-sg"
  description = "Security group for app servers allowing traffic only from Web SG"
  vpc_id      = var.vpc_id

  # Inbound: ONLY allow traffic on port 8080 from the Web Security Group
  ingress {
    description     = "Traffic from Web Tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    # ENTERPRISE PATTERN: Referencing another Security Group instead of an IP
    security_groups = [aws_security_group.web_sg.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-sg"
    Environment = var.environment
  }
}