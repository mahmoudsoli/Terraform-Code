module "vpc" {
  source = "./modules/VPC"

  vpc_cidr              = var.vpc_cidr
  cluster_name          = var.cluster_name
  private_subnet_cidrs  = var.private_subnet_cidrs
  az_for_private_subnet = var.az_for_private_subnet
  public_subnet_cidrs   = var.public_subnet_cidrs
  az_for_public_subnet  = var.az_for_public_subnet

}