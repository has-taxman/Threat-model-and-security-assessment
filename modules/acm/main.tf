# -----------------------------------
# ACM Certificate with DNS Validation
# -----------------------------------

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Create DNS record in Route53 to validate the certificate
resource "aws_route53_record" "cert_validation" {
  zone_id = var.hosted_zone_id
  name    = element(aws_acm_certificate.cert.domain_validation_options[*].resource_record_name, 0)
  type    = element(aws_acm_certificate.cert.domain_validation_options[*].resource_record_type, 0)
  records = [element(aws_acm_certificate.cert.domain_validation_options[*].resource_record_value, 0)]
  ttl     = 60
}

# Link the certificate to Route53 DNS record to complete validation
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
