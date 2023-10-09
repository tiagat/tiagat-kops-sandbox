resource "aws_s3_bucket" "example" {
  bucket        = "${local.subdomain}-cluster-state"
  force_destroy = true
  tags = {
    Environment = "var.env_name"
  }
}
