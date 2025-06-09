# main.tf for terraform

# ----------------------------------------
# VPC Module
# ----------------------------------------
module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = var.vpc_name
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  availability_zones   = var.availability_zones
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.tags
}

# ----------------------------------------
# ACM Certificate (DNS Validated)
# ----------------------------------------
module "acm" {
  source         = "./modules/acm"
  domain_name    = "tm.${var.domain_name}"
  hosted_zone_id = var.hosted_zone_id
}

# ----------------------------------------
# ALB + Listener + Security Groups
# ----------------------------------------
module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  certificate_arn     = module.acm.certificate_arn
  target_port         = 3000
}

# ----------------------------------------
# Route 53 Record for HTTPS Access
# ----------------------------------------
module "route53" {
  source          = "./modules/route53"
  domain_name     = "tm.${var.domain_name}"
  hosted_zone_id  = var.hosted_zone_id
  alb_dns_name    = module.alb.alb_dns_name
  alb_zone_id     = module.alb.alb_zone_id
}

# ----------------------------------------
# ECS + Fargate Service
# ----------------------------------------
module "ecs" {
  source                = "./modules/ecs"
  image_url             = var.image_url
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  alb_target_group_arn  = module.alb.target_group_arn
  alb_sg_id             = module.alb.alb_sg_id
  aws_region            = var.aws_region 
}
