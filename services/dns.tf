data "aws_route53_zone" "root" {
  zone_id      = var.root_dns_zone_id
  private_zone = false
}

resource "aws_route53_zone" "main" {
  name = "${var.env_name}.${data.aws_route53_zone.root.name}"

  tags = {
    Environment = "${var.env_name}"
  }

}

resource "aws_route53_record" "main-ns" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = "${var.env_name}.${data.aws_route53_zone.root.name}"
  type    = "NS"
  ttl     = "86400"
  records = aws_route53_zone.main.name_servers
}