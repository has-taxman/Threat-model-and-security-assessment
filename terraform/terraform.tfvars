# ----------------------------------------
# AWS Region (optional—defaults to eu-north-1)
# ----------------------------------------
aws_region       = "eu-north-1"

# ----------------------------------------
# VPC Overrides (all have sane defaults, so you can omit these if you like)
# ----------------------------------------
vpc_name         = "my-ecs-vpc"
vpc_cidr_block   = "10.0.0.0/16"
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["eu-north-1a", "eu-north-1b"]

# ----------------------------------------
# ECS Container Image
# ----------------------------------------
# The full ECR URI (account + region + repo:tag) of the image you pushed
image_url        = "717279702591.dkr.ecr.eu-north-1.amazonaws.com/threat-model:latest"

# Point Terraform at the local registry, because LocalStack does not support ECS without Pro version
# image_url      = "localhost:5000/threat-composer:latest"

# ----------------------------------------
# DNS & SSL Configuration
# ----------------------------------------
# Your base domain (must match a public hosted zone in Route 53)
domain_name      = "hasnatur-devops.com"

# The Route 53 Hosted Zone ID where `tm.<domain_name>` lives
hosted_zone_id = "Z00702582LV7HS4Q7ROIH"