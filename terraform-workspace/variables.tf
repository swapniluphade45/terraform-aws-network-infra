variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR per environment"
  type        = map(string)
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR per environment"
  type        = map(string)
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR per environment"
  type        = map(string)
}
