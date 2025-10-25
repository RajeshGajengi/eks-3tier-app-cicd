resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}


# Create a public subnet inside the VPC
resource "aws_subnet" "public_subnet" {
    for_each = var.public_subnets
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = "true"
    tags = {
      Name = "${var.environment}-${each.key}"
    }
}

# Create a private subnet inside the VPC
resource "aws_subnet" "private_subnet" {
    for_each = var.private_subnets
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    tags = {
      Name = "${var.environment}-${each.key}"
    }
}


# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "${var.environment}-igw"
    }
}

# Create a route table for the public subnet with default route to Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

# Associate the public subnet with the public route table  
resource "aws_route_table_association" "public_rt_association" {
    for_each       = aws_subnet.public_subnet
    subnet_id      = each.value.id
    route_table_id = aws_route_table.public_rt.id
}


# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "elastic_ip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-eip"
  }

  # lifecycle {
  #   prevent_destroy = true    # Ensures that Terraform does not destroy this EIP, protecting it from accidental removal.
}

# Create a NAT Gateway in the public subnet for private subnet internet access
resource "aws_nat_gateway" "nat_gw" {
  allocation_id     = aws_eip.elastic_ip.allocation_id
  subnet_id         = values(aws_subnet.public_subnet)[0].id
  connectivity_type = "public"
  tags = {
    Name = "${var.environment}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}


# Create a route table for the private subnet with default route to NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

# Associate the private subnet with the private route table 
resource "aws_route_table_association" "private_rt_association" {
    for_each       = aws_subnet.private_subnet
    subnet_id      = each.value.id
    route_table_id = aws_route_table.private_rt.id
}
