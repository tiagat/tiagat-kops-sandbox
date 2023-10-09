resource "aws_s3_bucket" "example" {
  bucket = "${local.subdomain}-cluster-state"

  tags = {
    Environment = "var.env_name"
  }
}
