# roles.tf

# ECS task role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
  
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS Task role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.ecs_task_execution_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_execution_role.json}"
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name   = "${aws_iam_role.ecs_task_execution_role.name}"
  policy = "${data.aws_iam_policy.ecs_task_execution.policy}"
}

# ECS task role policy attachment

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = "${aws_iam_role.ecs_task_execution_role.name}"
  policy_arn = "${aws_iam_policy.ecs_task_execution_policy.arn}"
}