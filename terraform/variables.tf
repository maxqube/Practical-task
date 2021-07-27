variable "region" {
	description = "Region to create resources in."
	default 	= "eu-central-1"
}

variable "availability_zone" {
	description = "AZ for the resources"
	default 	= "eu-central-1a"
}

variable "ovpn_port" {
	description = "Port for the Open VPN."
	default 	= "1194"
}

variable "cidr" {
	description = "The CIDR block for the VPC."
	default 	= "10.0.0.0/16"
}