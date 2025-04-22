# -----------------------------
# Terraform Variables - Root
# -----------------------------
# These are the global input variables for your infrastructure.
# You can override these in terraform.tfvars or via CLI -var flags.

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "threat-model-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "AZs to distribute subnets across"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "image_url" {
  description = "Docker image URI to deploy to ECS (ECR or local registry)"
  type        = string
}

variable "domain_name" {
  description = "Base domain name (e.g. example.com)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for the domain"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Set to true to enable NAT Gateway in public subnet"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "If true, use a single NAT Gateway for all AZs"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "threat-model"
  }
}
