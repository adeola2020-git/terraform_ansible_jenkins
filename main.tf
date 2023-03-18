terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-app-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_public_1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_public_2"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_public_3"
  }
}

resource "aws_subnet" "public_d" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_public_4"
  }
}

resource "aws_subnet" "private_e" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1e"

  tags = {
    Name = "subnet_private_1"
  }
}

resource "aws_subnet" "private_f" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1f"

  tags = {
    Name = "subnet_private_2"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.public_d.id
  route_table_id = aws_route_table.public_rt.id
}

# Creating EIP 
resource "aws_eip" "elastic_ip" {
  depends_on = [aws_internet_gateway.main-igw]
  vpc        = true
}

# Creating NAT Gateways in the 4 public subnets and allocating the EIP to them
resource "aws_nat_gateway" "natgw1" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.main-igw]
  tags = {
    Name = "gw NAT1"
  }
}

resource "aws_nat_gateway" "natgw2" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_b.id
  depends_on    = [aws_internet_gateway.main-igw]
  tags = {
    Name = "gw NAT2"
  }
}

resource "aws_nat_gateway" "natgw3" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_c.id
  depends_on    = [aws_internet_gateway.main-igw]
  tags = {
    Name = "gw NAT3"
  }
}

resource "aws_nat_gateway" "natgw4" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_d.id
  depends_on    = [aws_internet_gateway.main-igw]
  tags = {
    Name = "gw NAT4"
  }
}

# Create RTs with the NATgw and associate with each private subnet
resource "aws_route_table" "routenat1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw1.id
  }
  tags = {
    Name = "routenat1"
  }
}

resource "aws_route_table_association" "assonat1" {
  subnet_id      = aws_subnet.private_e.id
  route_table_id = aws_route_table.routenat1.id
}

resource "aws_route_table" "routenat2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw2.id
  }
  tags = {
    Name = "routenat2"
  }
}

resource "aws_route_table_association" "assonat2" {
  subnet_id      = aws_subnet.private_e.id
  route_table_id = aws_route_table.routenat2.id
}

resource "aws_route_table" "routenat3" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw3.id
  }
  tags = {
    Name = "routenat3"
  }
}

resource "aws_route_table_association" "assonat3" {
  subnet_id      = aws_subnet.private_f.id
  route_table_id = aws_route_table.routenat3.id
}

resource "aws_route_table" "routenat4" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw4.id
  }
  tags = {
    Name = "routenat4"
  }
}

resource "aws_route_table_association" "assonat4" {
  subnet_id      = aws_subnet.private_f.id
  route_table_id = aws_route_table.routenat4.id
}
# Creating SG for the public subnets
resource "aws_security_group" "public_sg" {
  name   = "my-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow http from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow http from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Creating SG for the private subnets
resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow acess from the public subnet"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["aws_security_group.public_sg.id"]
  }

  ingress {
    description = "Allow http from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}

resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id, aws_subnet.public_d.id]
}

resource "aws_lb_listener" "public_lb_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }
}

resource "aws_lb_target_group" "public_tg" {
  name        = "my-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
}

resource "aws_launch_template" "public_launch_template" {

  name = "my_launch_template"

  image_id      = "ami-09cd747c78a9add63"
  instance_type = "t2.micro"
  key_name      = "Terraform-KP"

  #user_data = filebase64("${path.module}/server.sh")
  user_data = filebase64("user_data.sh")

  #   user_data = <<-EOF
  #   #!/bin/bash
  #   apt update
  #   apt upgrade -y
  #   apt install apache2 -y
  #   echo "<h1>Hello world from highly available group of ec2 instances</h1>" > /var/www/html/index.html
  #   systemctl start apache2
  #   systemctl enable apache2
  #   EOF

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.public_sg.id]
  }

  tags = {
    Name = "web-server"
  }
}

resource "aws_autoscaling_group" "public_asg" {
  name              = "public_asg"
  max_size          = 8
  min_size          = 4
  health_check_type = "ELB"
  desired_capacity  = 4
  target_group_arns = [aws_lb_target_group.public_tg.arn]

  vpc_zone_identifier = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id, aws_subnet.public_d.id]

  launch_template {
    id      = aws_launch_template.public_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "public_scale_up" {
  name                   = "public_scale_up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.public_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"   # add one instance
  cooldown               = "300" # cooldown period after scaling
}

resource "aws_cloudwatch_metric_alarm" "public_scale_up_alarm" {
  alarm_name          = "public-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.public_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.public_scale_up.arn]
}

resource "aws_autoscaling_policy" "public_scale_down" {
  name                   = "public-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.public_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "public_scale_down_alarm" {
  alarm_name          = "public-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.public_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.public_scale_down.arn]
}

output "web_elb_dns_name" {
  value = aws_lb.web_alb.dns_name
}





resource "aws_lb" "db_alb" {
  name               = "db-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_sg.id]
  subnets            = [aws_subnet.private_e.id, aws_subnet.private_f.id]
}

resource "aws_lb_listener" "private_lb_listener" {
  load_balancer_arn = aws_lb.db_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_tg.arn
  }
}

resource "aws_lb_target_group" "private_tg" {
  name        = "my-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
}

resource "aws_launch_template" "private_launch_template" {

  name = "private_launch_template"

  image_id      = "ami-09cd747c78a9add63"
  instance_type = "t2.micro"
  key_name      = "Terraform-KP"

  #user_data = filebase64("${path.module}/server.sh")
  #user_data = filebase64("user_data.sh")

  #   user_data = <<-EOF
  #   #!/bin/bash
  #   apt update
  #   apt upgrade -y
  #   apt install apache2 -y
  #   echo "<h1>Hello world from highly available group of ec2 instances</h1>" > /var/www/html/index.html
  #   systemctl start apache2
  #   systemctl enable apache2
  #   EOF

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.private_sg.id]
  }

  tags = {
    Name = "db-instance"
  }
}

resource "aws_autoscaling_group" "private_asg" {
  name              = "private_asg"
  max_size          = 4
  min_size          = 2
  health_check_type = "ELB"
  desired_capacity  = 2
  target_group_arns = [aws_lb_target_group.private_tg.arn]

  vpc_zone_identifier = [aws_subnet.private_e.id, aws_subnet.private_f.id]

  launch_template {
    id      = aws_launch_template.private_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "private_scale_up" {
  name                   = "private_scale_up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.private_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"   # add one instance
  cooldown               = "300" # cooldown period after scaling
}

resource "aws_cloudwatch_metric_alarm" "private_scale_up_alarm" {
  alarm_name          = "private-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.private_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.private_scale_up.arn]
}

resource "aws_autoscaling_policy" "private_scale_down" {
  name                   = "private-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.private_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "private_scale_down_alarm" {
  alarm_name          = "private-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.private_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.private_scale_down.arn]
}

output "db_elb_dns_name" {
  value = aws_lb.db_alb.dns_name
}