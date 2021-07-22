provider "aws" {
	region = var.region
	access_key = "AKIA3CR3D5LTC5UNUG6J"
	secret_key = var.secret_key
}

module "networking" {
  source    = "./modules/networking"
}

module "ec2" {
  source     = "./modules/ec2"
  subnet_id = module.networking.subnet_id
  sg_id = module.networking.sg_id
  iam_instance_profile_name = module.iam.aws_iam_instance_profile_name
}

module "iam" {
  source     = "./modules/iam"
}