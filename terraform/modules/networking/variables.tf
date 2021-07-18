variable "cidr" {
	description = "The CIDR block for the VPC."
	default = "10.0.0.0/16"
}

variable "cidr_blocks" {
	description = "The CIDR block for the VPC."
	default = ["10.0.0.0/16"]
}

variable "subnet_cidr" {
	description = "The CIDR block for the Subnet."
	default = "10.0.1.0/24"
}

variable "availability_zone" {
	description = "AZ for the resources"
	default = "eu-central-1"
}


