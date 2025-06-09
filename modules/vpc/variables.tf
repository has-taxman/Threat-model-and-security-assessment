# variables.tf for terraform/modules/vpc
variable "vpc_name" {
  type        = string
  description = "Name to assign to the VPC"
}
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}
variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}
variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}
variable "availability_zones" {
  type        = list(string)
  description = "List of AZs to use"
}
variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to provision a NAT gateway"
  default     = false
}
variable "single_nat_gateway" {
  type        = bool
  description = "Whether to use a single NAT gateway across AZs"
  default     = false
}
variable "enable_dns_hostnames" {
  type        = bool
  description = "Whether to enable DNS hostnames in the VPC"
  default     = false  
}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to VPC resources"
}
