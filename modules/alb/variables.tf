## variables.tf
variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "certificate_arn" {
  type = string
}
variable "target_port" {
  type = number
}
