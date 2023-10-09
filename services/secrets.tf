resource "aws_secretsmanager_secret" "admin_ssh_key" {
  name = "${var.env_name}-admin-ssh-key"
}
