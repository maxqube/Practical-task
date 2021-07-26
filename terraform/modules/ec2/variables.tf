variable "ami" {
	description = "AMI for the EC2 instance."
	default     = "ami-00f22f6155d6d92c5"
}

variable "key_name" {
	description = "Key to SSH to the EC2 instance."
	default     = "terraform-key"
}

variable "availability_zone" {
	description = "AZ for the resources"
	default = ""
}

variable "sg_id" {
	description = "security group ID"
	type = any
	default = ""
}

variable "cidr" {
	description = "The CIDR block for the VPC."
	default = ""
}

variable "public_subnet_id" {
	description = "Public subnet ID"
	type = any
	default = ""
}

variable "iam_instance_profile_name" {
	description = "IAM instance profile Name"
	type = any
	default = ""
}

variable "region" {
	description = "Region to create resources in."
	default = ""
}

variable "ovpn_port" {
	description = "Port for the Open VPN."
	default = ""
}