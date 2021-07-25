output "public_ip" {
	value = aws_instance.terraform_vpn_ec2.public_ip
}