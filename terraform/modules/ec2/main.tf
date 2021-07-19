resource "aws_instance" "terraform_EC2" {
	ami           = var.ami
	availability_zone = var.availability_zone
	instance_type = "t2.micro"
	key_name = "terraform-key"

	#network_interface {
	#	device_index = 0
	#	network_interface_id = var.network_interface_id
	#}

#######
	associate_public_ip_address = true
	vpc_security_group_ids      = [var.sg_id]
	subnet_id                   = var.subnet_id
	iam_instance_profile = var.iam_instance_profile_name
	
	

	user_data = <<-EOF
				#!/bin/bash
				yum update -y
				sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64
				cd /home/ec2-user/
				curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
				unzip CloudWatchMonitoringScripts-1.2.2.zip
				rm -rf CloudWatchMonitoringScripts-1.2.2.zip
				EOF

	tags = {
		Name = "terraform_instance"
	}
}