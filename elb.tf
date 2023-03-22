resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
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
  vpc_id      = aws_vpc.demo_vpc.id
}

resource "aws_lb_target_group_attachment" "tg" {
  count = 4
  target_group_arn  = aws_lb_target_group.public_tg.arn
  target_id         = element([
    aws_instance.pub1b.id,
    aws_instance.pub2a.id,
    aws_instance.pub2b.id,
    aws_instance.pub1a.id
  ], count.index)
  port              = 80
}