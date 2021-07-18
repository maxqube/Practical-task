output "public_ip" {
	value = aws_instance.terraform_EC2.public_ip
}