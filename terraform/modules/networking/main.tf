# 1. Create VPC

resource "aws_vpc" "terraform_vpc" {
	cidr_block = var.cidr

	tags = {
		Name = "terraform_vpc"
	}
}

# 2. Create Internet Gataway

resource "aws_internet_gateway" "terraform_gw" {
	vpc_id = aws_vpc.terraform_vpc.id

	tags = {
		Name = "terraform_igw"
	}
}

# 3. Create Route Tables

resource "aws_default_route_table" "terraform_public_route_table" {
	default_route_table_id = aws_vpc.terraform_vpc.default_route_table_id

	route {
		cidr_block = "0.0.0.0/0" # Send all trafic
		gateway_id = aws_internet_gateway.terraform_gw.id
	}

	tags = {
		Name = "terraform_public_route_table"
	}
}

resource "aws_route_table" "terraform_private_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_private_route_table"
  }
}

# 4. Create Subnet

resource "aws_subnet" "terraform_public_subnet" {
	vpc_id 					= aws_vpc.terraform_vpc.id
	cidr_block				= var.public_subnet_cidr
	map_public_ip_on_launch = false
	availability_zone 		= var.availability_zone

	tags = {
		Name = "terraform_public_subnet"
	}
}

resource "aws_subnet" "terraform_private_subnet" {
	vpc_id 					= aws_vpc.terraform_vpc.id
	cidr_block 				= var.private_subnet_cidr
	map_public_ip_on_launch = false
	availability_zone 		= var.availability_zone

	tags = {
		Name = "terraform_private_subnet"
	}
}

# 5. Associate Subnet with Route Table

resource "aws_route_table_association" "terraform_vpc_public_assoc" {
	subnet_id 	   = aws_subnet.terraform_public_subnet.id
	route_table_id = aws_default_route_table.terraform_public_route_table.id
}


resource "aws_route_table_association" "terraform_vpc_private_assoc" {
	subnet_id	   = aws_subnet.terraform_private_subnet.id
	route_table_id = aws_route_table.terraform_private_route_table.id
}

# 6. Create Security Groups

resource "aws_security_group" "terraform_allow_web" {
	name        = "terraform_allow_web"
	description = "Allow TCP inbound traffic on ports 22,80,443 and VPN connection."
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

	ingress {
		description = "Allow VPN"
    	from_port   = var.ovpn_port
    	to_port     = var.ovpn_port
    	protocol    = "udp"
    	cidr_blocks = ["0.0.0.0/0"]
    }

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = var.cidr_blocks
	}

	tags = {
		Name = "terraform_sg"
	}
}