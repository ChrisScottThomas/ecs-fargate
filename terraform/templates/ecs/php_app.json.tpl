[
  {
      "name": "php-app",
      "image": "${php_image}",
      "cpu": ${fargate_cpu},
      "memory": ${fargate_memory},
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "/ecs/php-app",
              "awslogs-region": "${aws_region}",
              "awslogs-stream-prefix": "ecs"
          }
      },
      "portMappings": [
        {
            "containerPort": ${php_port},
            "hostPort": ${php_port}
        }
    ]
  }
]