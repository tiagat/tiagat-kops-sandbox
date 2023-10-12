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

resource "aws_s3_bucket_ownership_controls" "kops_discovery" {
  bucket = aws_s3_bucket.kops_discovery.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "kops_discovery" {
  bucket = aws_s3_bucket.kops_discovery.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
