output "dns_zone_name" {
  value = local.subdomain
}

output "dns_zone_id" {
  value = aws_route53_zone.main.zone_id
}

data "aws_secretsmanager_secret_version" "admin_ssh_key" {
  secret_id = aws_secretsmanager_secret.admin_ssh_key.id
}

output "admin_ssh_key" {
  value     = data.aws_secretsmanager_secret_version.admin_ssh_key.secret_string
  sensitive = true
}
