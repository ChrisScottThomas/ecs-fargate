# variables.tf

variable "aws_region" {
  description = "The AWS region we deploy to"
  default     = "eu-west-2" #London
}

variable "ecs_task_execution_role_name" {
  description  = "ECS task execution role name"
  default      = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description  = "ECS auto scale role name"
  default      = "myEcsAutoScaleRole"
}

variable "az_count" {
  description  = "Set number of Availability Zones in region"
  default      = "2"
}

variable "app_image" {
  description  = "Deployable Docker image"
  default      = "docker.io/chrisscottthomas/nginx" #Simple NGINX container
}

variable "php_image" {
  description  = "Deployable PHP Docker image"
  default      = "docker.io/chrisscottthomas/php-fpm" #Simple PHP container
}

variable "app_port" {
  description  = "Exposed port for container"
  default      = "80"
}

variable "php_port" {
  description  = "Exposed port for container"
  default      = "9000"
}

variable "app_count" {
  description  = "Number of containers"
  default      = "1"
}

variable "health_check_path" {
  description  = "Path to query container health"
  default      = "/" # Will provide a HTTP/200 to verify health
}

variable "fargate_cpu" {
  description = "Fargate CPU resource allocation"
  default     = "1024" # 1024 == 1 vCPU
}

variable "fargate_memory" {
  description  = "Fargate RAM resource allocation"
  default      = "2048" # size in MiB
}
