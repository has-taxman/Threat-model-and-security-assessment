# variables.tf for terraform-infra
# ----------------------------------------
# AWS Region
# ----------------------------------------
variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "eu-north-1"
}

# ----------------------------------------
# VPC Configuration
# ----------------------------------------
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "ecs-app-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway" {
  description = "Whether to provision a NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all AZs"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "ecs-threat-composer"
  }
}

# ----------------------------------------
# ECS Image & Deployment
# ----------------------------------------
variable "image_url" {
  description = "Full ECR image URI to deploy (e.g., <account>.dkr.ecr.<region>.amazonaws.com/repo:tag)"
  type        = string
}

# ----------------------------------------
# Domain & Route 53
# ----------------------------------------
variable "domain_name" {
  description = "Base domain name for your app (e.g., example.com)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for the domain"
  type        = string
}
