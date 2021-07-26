resource "aws_instance" "terraform_vpn_ec2" {
	ami           = var.ami
	availability_zone = var.availability_zone
	instance_type = "t2.micro"
	key_name                    = var.key_name
	associate_public_ip_address = true
	vpc_security_group_ids      = [var.sg_id]
	subnet_id                   = var.public_subnet_id

	tags = {
		Name = "terraform_VPN_EC2"
	}
}

resource "aws_instance" "terraform_nginx" {
	ami           = var.ami
	availability_zone = var.availability_zone
	instance_type = "t2.micro"
	key_name                    = var.key_name
	associate_public_ip_address = true
	vpc_security_group_ids      = [var.sg_id]
	subnet_id                   = var.public_subnet_id
	iam_instance_profile = var.iam_instance_profile_name

	user_data = <<-EOF
				#!/bin/bash
				yum update -y
				sudo yum install mailx
				EOF

	tags = {
		Name = "terraform_Nginx_and_monitoring"
	}
}

# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  content = <<EOF
[vpn_public]
${aws_instance.terraform_vpn_ec2.public_ip}

[vpn_public:vars]
aws_region=${var.region}
public_ip=${aws_instance.terraform_vpn_ec2.public_ip}
vpn_gateway=${aws_instance.terraform_vpn_ec2.private_ip}
ovpn_port=${var.ovpn_port}
vpc_cidr=${var.cidr}
hostname=vpn

[webserver]
${aws_instance.terraform_nginx.public_ip} 
ansible_connection=ssh 

EOF

  filename = "../ansible/inventory"
}