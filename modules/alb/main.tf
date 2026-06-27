# Application Load Balancer

resource "aws_lb" "frontend_alb" {
  name               = "${var.environment}-frontend-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_sg_id
  ]

  subnets = [
    var.app_public_subnet_az1_id,
    var.app_public_subnet_az2_id
  ]

  tags = {
    Name = "${var.environment}-frontend-alb"
  }
}

# Target group

resource "aws_lb_target_group" "frontend_tg" {
  name     = "${var.environment}-frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.app_vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "${var.environment}-frontend-tg"
  }
}

# Target group attachment — server 1

resource "aws_lb_target_group_attachment" "frontend_1" {
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = var.frontend_1_id
  port             = 80
}

# Target group attachment — server 2

resource "aws_lb_target_group_attachment" "frontend_2" {
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = var.frontend_2_id
  port             = 80
}

# Listener

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}