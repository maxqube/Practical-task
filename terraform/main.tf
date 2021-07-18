provider "aws" {
	region = var.region
	access_key = "AKIA3CR3D5LTL6LJL5ZT"
	secret_key = var.secret_key
}

module "networking" {
  source    = "./modules/networking"
}

module "ec2" {
  source     = "./modules/ec2"
  network_interface_id = module.networking.terraform_nic_id
}