module "vpc" {
  source = "../../modules/vpc"

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az_public           = var.az_public
  az_private          = var.az_private
}

module "ec2" {
  source = "../../modules/ec2"

  environment       = var.environment
  ami_id            = var.ami_id
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
}

module "eks" {
  source = "../../modules/eks"

  cluster_name      = "${var.environment}-eks"
  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
}
