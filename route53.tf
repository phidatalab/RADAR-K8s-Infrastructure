resource "aws_route53_zone" "primary" {
  name = var.domain_name
  tags = merge(tomap({ "Name" : "${var.environment}-radar-base-primary-zone" }), var.common_tags)
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_eip.cluster_loadbalancer_eip.public_dns]
}

resource "aws_route53_record" "alertmanager" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "alertmanager.${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${var.environment}.${var.domain_name}"]
}

resource "aws_route53_record" "dashboard" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "dashboard.${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${var.environment}.${var.domain_name}"]
}

resource "aws_route53_record" "grafana" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "grafana.${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${var.environment}.${var.domain_name}"]
}

resource "aws_route53_record" "graylog" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "graylog.${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${var.environment}.${var.domain_name}"]
}

resource "aws_route53_record" "prometheus" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "prometheus.${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${var.environment}.${var.domain_name}"]
}

resource "aws_route53_record" "s3" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "s3.${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${var.environment}.${var.domain_name}"]
}

output "radar_base_route53_hosted_zone_id" {
  value = aws_route53_zone.primary.zone_id
}
