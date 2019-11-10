# logs.tf

# Log stream and group for ClowdWatch - 30 day retention

resource "aws_cloudwatch_log_group" "hello_log_group" {
  name              = "/ecs/hello-app"
  retention_in_days = 30 

  tags = {
    name = "hello-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "hello_log_stream" {
  name           = "hello-log-stream"
  log_group_name = aws_cloudwatch_log_group.hello_log_group.name
}