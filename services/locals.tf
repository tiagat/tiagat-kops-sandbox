locals {
  subdomain = "${var.env_name}.${data.aws_route53_zone.root.name}"
}
