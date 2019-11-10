# ecs_php.tf
data "template_file" "php_app" {
  template = file("./templates/ecs/php_app.json.tpl")

  vars = {
    php_image      = var.php_image
    php_port       = var.php_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
resource "aws_ecs_task_definition" "php" {
  family                   = "php-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.php_app.rendered
}

resource "aws_ecs_service" "php" {
  name            = "php-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.php.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}