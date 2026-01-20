module "network" {
  source = "../terraform-module"

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  ami_id              = var.ami_id
  az_public           = var.az_public
  az_private          = var.az_private
}
