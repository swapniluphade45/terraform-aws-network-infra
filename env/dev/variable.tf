variable "environment" {
  description = "Environment name"
}

variable "region" {
  description = "AWS region"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
}

variable "az_public" {
  description = "Availability zone for public subnet"
}

variable "az_private" {
  description = "Availability zone for private subnet"
}
