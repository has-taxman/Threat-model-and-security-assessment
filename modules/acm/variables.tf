## variables.tf
variable "domain_name" {
  description = "Fully qualified domain name for the certificate"
  type        = string
}
variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}
