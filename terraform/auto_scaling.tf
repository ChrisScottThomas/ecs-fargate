# auto_scaling.tf

resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_esc_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = aws_iam_role.ecs_auto_scale_role.arn
  min_capacity       = 1
  max_capacity       = 3
}

# Autoscale by one - up

resource "aws_appautoscaling_policy" "up" {
  name               = "hello_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_esc_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
  depends_on = [aws_appautoscalaing_target.target]
}

# Autoscale by one - down

resource "aws_appautoscaling_policy" "down" {
  name               = "hello_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_esc_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
  depends_on = [aws_appautoscalaing_target.target]
}

# Set CloudWatch triggers - up
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "hello_cpu_utilisation_low"
  comparison_operator = "LessThanOrEqualtoThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "This alarm triggers hello to scale up on CPU capacity (85% usage)"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

# Set CloudWatch triggers - down
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "hello_cpu_utilisation_low"
  comparison_operator = "LessThanOrEqualtoThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "This alarm triggers hello to scale down on CPU capacity (10% usage)"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}