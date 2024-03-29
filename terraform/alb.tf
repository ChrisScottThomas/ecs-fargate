# alb.tf

# Create ALB with health check
resource "aws_lb" "main" {
  name            = "hello-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id] 
}

resource "aws_lb_target_group" "app" {
  name        = "hello-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path # /
    unhealthy_threshold = "2"
  }
}

#Redirect ALB traffic to target group
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.id 
  port              = var.app_port # :3000
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app.id
    type             = "forward"
  }
}
