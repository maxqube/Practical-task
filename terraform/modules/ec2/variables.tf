variable "ami" {
	description = "AMI for the EC2 instance."
	default     = "ami-00f22f6155d6d92c5"
}

variable "network_interface_id" {
	description = "network interface ID"
	type = any
	default = ""
}

