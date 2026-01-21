region = "ap-south-1"

vpc_cidr = {
  dev  = "10.10.0.0/16"
  qa   = "10.20.0.0/16"
  prod = "10.30.0.0/16"
}

public_subnet_cidr = {
  dev  = "10.10.1.0/24"
  qa   = "10.20.1.0/24"
  prod = "10.30.1.0/24"
}

private_subnet_cidr = {
  dev  = "10.10.2.0/24"
  qa   = "10.20.2.0/24"
  prod = "10.30.2.0/24"
}
