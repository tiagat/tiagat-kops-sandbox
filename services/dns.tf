data "aws_route53_zone" "root" {
  zone_id      = var.root_dns_zone_id
  private_zone = false
}

resource "aws_route53_zone" "main" {
  name          = local.subdomain
  force_destroy = true
  tags = {
    Environment = "${var.env_name}"
  }

}

resource "aws_route53_record" "main-ns" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = local.subdomain
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.main.name_servers
}

resource "aws_route53_record" "main-a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = local.subdomain
  type    = "A"
  ttl     = "300"
  records = [
    "127.0.0.1"
  ]
}
