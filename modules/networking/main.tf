# 1. DATA SOURCE: Dynamically fetch healthy Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# 2. The VPC Resource
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  # Enterprise Standard: Always enable DNS hostnames for internal resolution
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# 3. Public Subnets (Iterating with 'count')
resource "aws_subnet" "public" {
  # count creates multiple subnets based on how many CIDRs we pass in
  count = length(var.public_subnets_cidr)

  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnets_cidr[count.index]

  # Distribute subnets across available AZs automatically
  availability_zone = data.aws_availability_zones.available.names[count.index]

  # Resources here get a public IP automatically (e.g., Load Balancers)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# 4. Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  # Notice map_public_ip_on_launch is missing here. These are completely private.

  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# 5. Internet Gateway (The door to the internet for the VPC)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# 6. Public Route Table (The traffic cop directing traffic to the IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0" # All internet-bound traffic
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

# 7. Route Table Association (Attaching the public subnets to the public route table)
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}