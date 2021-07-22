resource "aws_instance" "terraform_EC2" {
	ami           = var.ami
	availability_zone = var.availability_zone
	instance_type = "t2.micro"
	key_name = "terraform-key"
	associate_public_ip_address = true
	vpc_security_group_ids      = [var.sg_id]
	subnet_id                   = var.subnet_id
	iam_instance_profile = var.iam_instance_profile_name

#	provisioner "file" {
#	source      = "~/metrics.sh"
#    destination = "/home/ec2-user/metrics.sh"
#		connection {
#      		type        = "ssh"
#    		user        = "ec2-user"
#     		private_key = "${file("C:/aws/terraform-key.pem")}"
#     		host        = "${aws_instance.terraform_EC2.public_ip}"
#		}
#	}
	

	user_data = <<-EOF
				#!/bin/bash
				yum update -y
				sudo yum install mailx
				cd /home/ec2-user/
				chmod +x metrics.ssh
				EOF
	tags = {
		Name = "terraform_instance"
	}
}