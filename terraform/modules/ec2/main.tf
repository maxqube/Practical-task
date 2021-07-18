resource "aws_instance" "terraform_EC2" {
	ami           = var.ami
	associate_public_ip_address = true
	instance_type = "t2.micro"
	
	network_interface {
		device_index = 0
		network_interface_id = var.network_interface_id
	}
}