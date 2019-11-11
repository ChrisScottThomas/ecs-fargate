# auto_scaling.tf

resource "aws_appautoscaling_target" "php" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.php.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 3
}

# Autoscale by one - up

resource "aws_appautoscaling_policy" "php_up" {
  name               = "hello_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.php.name}"
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
  depends_on = [aws_appautoscaling_target.php]
}

# Autoscale by one - down

resource "aws_appautoscaling_policy" "php_down" {
  name               = "php_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.php.name}"
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
  depends_on = [aws_appautoscaling_target.php]
}

# Set CloudWatch triggers - up
resource "aws_cloudwatch_metric_alarm" "php_service_cpu_high" {
  alarm_name          = "pbp_cpu_utilisation_high"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "This alarm triggers php_app to scale up on CPU capacity (85% usage)"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.php.name
  }

  alarm_actions = [aws_appautoscaling_policy.php_up.arn]
}

# Set CloudWatch triggers - down
resource "aws_cloudwatch_metric_alarm" "php_service_cpu_low" {
  alarm_name          = "php_cpu_utilisation_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "This alarm triggers php_app to scale down on CPU capacity (10% usage)"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.php.name
  }

  alarm_actions = [aws_appautoscaling_policy.php_down.arn]
}