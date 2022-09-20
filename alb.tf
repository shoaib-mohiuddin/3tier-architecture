resource "aws_lb" "application_lb" {
  name               = "application-lb"
  security_groups    = [aws_security_group.alb_sg.id]
  load_balancer_type = "application"

  subnets = [
    aws_subnet.web_public["a"].id,
    aws_subnet.web_public["b"].id,
    #aws_subnet.web_public["c"].id

  ]

  tags = {
    Name = "application-lb"
  }
}

resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_alb_target_group.web_tg.arn
        weight = 100
      }
    }
  }
}

resource "aws_alb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_3tier.id

  health_check {
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn    = aws_alb_target_group.web_tg.arn
}
