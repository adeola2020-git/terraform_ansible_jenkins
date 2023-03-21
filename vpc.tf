locals {
  public_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  #private_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
}

resource "aws_vpc" "demo_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "demo_vpc"
  }
}

resource "aws_subnet" "public1" {

  cidr_block              = local.public_cidr_blocks[0]
  vpc_id                  = aws_vpc.demo_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = var.azs[0]

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public2" {

  cidr_block              = local.public_cidr_blocks[1]
  vpc_id                  = aws_vpc.demo_vpc.id
  map_public_ip_on_launch = true

  availability_zone = var.azs[1]

  tags = {
    Name = "public-subnet-2"
  }
}

# resource "aws_subnet" "private1" {

#   cidr_block = local.private_cidr_blocks[0]
#   vpc_id     = aws_vpc.demo_vpc.id

#   availability_zone = var.azs[0]

#   tags = {
#     Name = "private-subnet-1"
#   }
# }

# resource "aws_subnet" "private2" {

#   cidr_block = local.private_cidr_blocks[1]
#   vpc_id     = aws_vpc.demo_vpc.id

#   availability_zone = var.azs[1]

#   tags = {
#     Name = "private-subnet-2"
#   }
# }

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo_igw.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}



resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  # Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Outbound Rules
  # Internet access to anywhere

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-SG"
  }

  #### Take this out #####
  # ingress {
  #   description = "Allow http from everywhere"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description = "Allow http from everywhere"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # egress {
  #   description = "Allow outgoing traffic"
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # dynamic "ingress" {
  #   for_each = [80, 22]
  #   content {
  #     from_port   = ingress.value
  #     to_port     = ingress.value
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # }
}

resource "aws_security_group" "db" {
  name        = "db"
  description = "Allow db traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description     = "mysql/aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web.id}"] #[aws_security_group.ELB_SG.id]
  }

  ingress {
    description     = "postgresql access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web.id}"] #[aws_security_group.ELB_SG.id]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #security_groups = ["${aws_security_group.web.id}"] #[aws_security_group.ELB_SG.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-SG"
  }


  # dynamic "ingress" {
  #   for_each = [22, 3306, 5432]
  #   content {
  #     from_port       = ingress.value
  #     to_port         = ingress.value
  #     protocol        = "tcp"
  #     security_groups = ["${aws_security_group.web.id}"]
  #     #cidr_blocks = ["0.0.0.0/0"]
  #   }
  # }
}