output "subnet_id" {
  value = aws_subnet.terraform_subnet.id
}

output "sg_id" {
  value = aws_security_group.terraform_allow_web.id
}