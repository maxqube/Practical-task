provider "aws" {
	region = var.region
}

module "networking" {
  source            = "./modules/networking"
  cidr              = var.cidr
  availability_zone = var.availability_zone
  ovpn_port         = var.ovpn_port
}

module "ec2" {
  source                    = "./modules/ec2"
  public_subnet_id          = module.networking.public_subnet_id
  sg_id                     = module.networking.sg_id
  cidr                      = var.cidr
  region                    = var.region
  ovpn_port                 = var.ovpn_port
  iam_instance_profile_name = module.iam.aws_iam_instance_profile_name
}

module "iam" {
  source = "./modules/iam"
}