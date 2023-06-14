# Route53 지리적 레코드 생성
resource "aws_route53_record" "geo-record" {
    zone_id = ""
    name    = ""
    type    = "A"

    geolocation_routing_policy {
        country = "KR"
    }
    set_identifier = "서울 로드밸런서"

    alias {
        name    = aws_lb.seoul_alb.dns_name
        zone_id = aws_lb.seoul_alb.zone_id
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "geo-record2" {
    zone_id = ""
    name    = ""
    type    = "A"

    geolocation_routing_policy {
        country = "SG"
    }
    set_identifier = "싱가포르 로드밸런서"

    alias {
        name    = aws_lb.singapore_alb.dns_name
        zone_id = aws_lb.singapore_alb.zone_id
        evaluate_target_health = true
    }
}