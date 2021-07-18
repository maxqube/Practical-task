data "aws_availability_zones" "available" {}

# 1. Create VPC

resource "aws_vpc" "terraform_vpc" {
	cidr_block = var.cidr
}

# 2. Create Internet Gataway

resource "aws_internet_gateway" "terraform_gw" {
	vpc_id = aws_vpc.terraform_vpc.id
}

# 3. Create Route Table

resource "aws_route_table" "terraform_route_table" {
	vpc_id = aws_vpc.terraform_vpc.id
	route {
		cidr_block = "0.0.0.0/24" # Send all trafic
		gateway_id = aws_internet_gateway.terraform_gw.id
	}
}

# 4. Create Subnet

resource "aws_subnet" "terraform_subnet" {
	vpc_id = aws_vpc.terraform_vpc.id
	cidr_block = var.subnet_cidr
	availability_zone = var.availability_zone
}

# 5. Associate Subnet with Rout Table

resource "aws_route_table_association" "terraform" {
	subnet_id = aws_subnet.terraform_subnet.id
	route_table_id = aws_route_table.terraform_route_table.id
}

# 6. Create Security Groups

resource "aws_security_group" "terraform_allow_web" {
	name        = "terrafowm_allow_web"
	description = "Allow TCP inbound traffic on ports 22,80,443"
	vpc_id      = aws_vpc.terraform_vpc.id

	ingress {
		description = "Allow HTTPS"
		from_port   = "443"
		to_port     = "443"
		protocol    = "tcp"
		cidr_blocks = var.cidr_blocks
	}

	ingress {
		description = "Allow HTTP"
		from_port   = "80"
		to_port     = "80"
		protocol    = "tcp"
		cidr_blocks = var.cidr_blocks
	}

	ingress {
		description = "Allow SSH"
		from_port   = "22"
		to_port     = "22"
		protocol    = "tcp"
		cidr_blocks = var.cidr_blocks
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_vpc" "myVPC" {
	cidr_block = var.cidr
}

# 7. Create Network Interface with a Subnet from step 4

resource "aws_network_interface" "terraform_nic" {
  subnet_id       = aws_subnet.terraform_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.terraform_allow_web.id]
}