resource "aws_s3_bucket" "kops_state" {
  bucket        = var.bucket_state
  force_destroy = true
  tags = {
    Environment = "var.env_name"
  }
}

resource "aws_s3_bucket" "kops_discovery" {
  bucket        = var.bucket_discovery
  force_destroy = true
  tags = {
    Environment = "var.env_name"
  }
}
