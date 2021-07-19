variable "ami" {
	description = "AMI for the EC2 instance."
	default     = "ami-00f22f6155d6d92c5"
}

variable "network_interface_id" {
	description = "network interface ID"
	type = any
	default = ""
}

variable "availability_zone" {
	description = "AZ for the resources"
	default = "eu-central-1a"
}


#####
variable "sg_id" {
	description = "security group ID"
	type = any
	default = ""
}

variable "subnet_id" {
	description = "subnet  ID"
	type = any
	default = ""
}

variable "iam_instance_profile_name" {
	description = "IAM instance profile Name"
	type = any
	default = ""
}



