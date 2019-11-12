[
  {
      "name": "hello-app",
      "image": "${app_image}",
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "/ecs/hello-app",
              "awslogs-region": "${aws_region}",
              "awslogs-stream-prefix": "ecs"
          }
      },
      "portMappings": [
        {
            "containerPort": ${app_port},
            "hostPort": ${app_port}
        }
    ]
  },
  {
      "name": "php-app",
      "image": "${php_image}",
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "/ecs/hello-app",
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