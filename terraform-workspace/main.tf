locals {
  env = terraform.workspace
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr[local.env]

  tags = {
    Name        = "vpc-${local.env}"
    Environment = local.env
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-${local.env}"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[local.env]
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "public-subnet-${local.env}"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[local.env]
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-subnet-${local.env}"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt-${local.env}"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-${local.env}"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt-${local.env}"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

# Your SSH public key
locals {
  ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7lYt0hFEM8FIRcVH6Gbb6buCOaAQ8xn4d5z47JIBus swapniluphade45@gmail.com"
}

# Public EC2
resource "aws_instance" "public_ec2" {
  ami                         = "ami-02b8269d5e85954ef"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
mkdir -p /home/ec2-user/.ssh
echo "${local.ssh_public_key}" >> /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys
EOF

  tags = {
    Name = "public-ec2-${local.env}"
    Env  = local.env
  }
}

# Private EC2
resource "aws_instance" "private_ec2" {
  ami                         = "ami-02b8269d5e85954ef"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false

  user_data = <<EOF
#!/bin/bash
mkdir -p /home/ec2-user/.ssh
echo "${local.ssh_public_key}" >> /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys
EOF

  tags = {
    Name = "private-ec2-${local.env}"
    Env  = local.env
  }
}


# Public EC2 Security Group

resource "aws_security_group" "public_sg" {
  name        = "public-sg-${local.env}"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg-${local.env}"
  }
}

# Attach Public SG to Public EC2
resource "aws_network_interface_sg_attachment" "public_sg_attach" {
  security_group_id    = aws_security_group.public_sg.id
  network_interface_id = aws_instance.public_ec2.primary_network_interface_id
}


# Private EC2 Security Group

resource "aws_security_group" "private_sg" {
  name        = "private-sg-${local.env}"
  description = "Allow SSH from Public EC2 only"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg-${local.env}"
  }
}

# Attach Private SG to Private EC2
resource "aws_network_interface_sg_attachment" "private_sg_attach" {
  security_group_id    = aws_security_group.private_sg.id
  network_interface_id = aws_instance.private_ec2.primary_network_interface_id
}


