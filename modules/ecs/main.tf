# main.tf

resource "aws_ecs_cluster" "this" {
  name = "ecs-cluster"
}

# IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_exec" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_exec.json
}

data "aws_iam_policy_document" "ecs_exec" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_attach" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch log group for ECS
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/app"
  retention_in_days = 7
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_exec.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.image_url
      portMappings = [
        {
          containerPort = 3000
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS Security Group
resource "aws_security_group" "ecs_tasks" {
  name   = "ecs-tasks-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Fargate Service
resource "aws_ecs_service" "app" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.app.arn

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app"
    container_port   = 3000
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_exec_attach]
}
