# 버지니아 북부 프로바이더 선언
provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

# 버지니아 북부 US-ACM
resource "aws_acm_certificate" "us_acm" {
  provider   = aws.us
  domain_name       = ""
  validation_method = "DNS"

  tags = {
    Name = "Fourdollar-SSL/TLS"
  }

  key_algorithm = "RSA_2048"

}

# 라우터 53에 등록
resource "aws_route53_record" "us_acm" {
  provider   = aws.us
  for_each = {
    for dvo in aws_acm_certificate.us_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = ""
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.us_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.us_acm : record.fqdn]
}


# 싱가포르 Singapore-ACM
resource "aws_acm_certificate" "singapore_acm" {
  provider   = aws.singapore
  domain_name       = ""
  validation_method = "DNS"

  tags = {
    Name = "Fourdollar-SSL/TLS"
  }

  key_algorithm = "RSA_2048"

}

# 서울 Seoul-ACM
resource "aws_acm_certificate" "seoul_acm" {
  domain_name       = ""
  validation_method = "DNS"

  tags = {
    Name = "Fourdollar-SSL/TLS"
  }

  key_algorithm = "RSA_2048"

}