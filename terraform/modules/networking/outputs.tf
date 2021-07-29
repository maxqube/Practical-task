output "public_subnet_id" {
  value = aws_subnet.terraform_public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.terraform_private_subnet.id
}

output "sg_id" {
  value = aws_security_group.terraform_allow_web.id
}

output "vpc_id" {
  value = aws_vpc.terraform_vpc.id
}
