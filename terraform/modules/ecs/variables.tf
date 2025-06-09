## variables.tf
variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "image_url" {
  type = string
}

variable "alb_target_group_arn" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "aws_region" {
  type = string
}