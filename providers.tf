# Configure the AWS provider for the entire project.
provider "aws" {
  region = var.aws_region
}



# # Or if using LocalStack, configure the provider and endpoints!
# provider "aws" {
#   region                      = var.aws_region
#   access_key                  = "test"   # Dummy values for LocalStack
#   secret_key                  = "test"
#   skip_credentials_validation = true
#   skip_requesting_account_id  = true
#   skip_metadata_api_check     = true
  
#   endpoints {
#     acm            = "http://localhost:4566"
#     route53        = "http://localhost:4566"
#     cloudwatch     = "http://localhost:4566"
#     logs           = "http://localhost:4566"
#     iam            = "http://localhost:4566"
#     sts            = "http://localhost:4566"
#     ecs            = "http://localhost:4566"
#     elbv2          = "http://localhost:4566"
#     ec2            = "http://localhost:4566"
#   }
# }