#output "terraform_nic_id" {
#  value = aws_network_interface.terraform_nic.id
#}

######
output "subnet_id" {
  value = aws_subnet.terraform_subnet.id
}

output "sg_id" {
  value = aws_security_group.terraform_allow_web.id
}