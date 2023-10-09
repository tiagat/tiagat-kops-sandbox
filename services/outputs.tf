output "dns_zone_name" {
  value = local.subdomain
}

output "dns_zone_id" {
  value = aws_route53_zone.main.zone_id
}
