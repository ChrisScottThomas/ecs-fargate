# security.tf

# Group for ALB ; USe to restrict access to the app
resource "aws_security_group" "lb" {
  name        = "hello-load-balancer-security-group"
  description = "controls access to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol      = "tcp"
    from_port     = var.app_port
    to_port       = var.app_port
    cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    protocol      = "-1"
    from_port     = 0
    to_port       = 0
    cidr_blocks   = ["0.0.0.0/0"]
  }
}

# Ensure traffic to ECS only comes from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "hello-ecs-tasks-security-group"
  description = "allow inbound from ALB only"
  vpc_id      = aws_vpc.main.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
