variable "cidr" {
	description = "The CIDR block for the VPC."
	default 	= ""
}

variable "cidr_blocks" {
	description = "The CIDR block for the SG."
	default 	= ["0.0.0.0/0"]
}

variable "public_subnet_cidr" {
	description = "The CIDR block for the public Subnet."
	default 	= "10.0.1.0/24"
}

variable "private_subnet_cidr" {
	description = "The CIDR block for the private Subnet."
	default 	= "10.0.2.0/24"
}

variable "ovpn_port" {
	description = "Port for the Open VPN."
	default 	= ""
}

variable "availability_zone" {
	description = "AZ for the resources"
	default 	= ""
}
