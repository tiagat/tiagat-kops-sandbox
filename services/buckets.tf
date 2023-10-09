resource "aws_s3_bucket" "example" {
  bucket        = "tiagat.kops-state"
  force_destroy = true
  tags = {
    Environment = "var.env_name"
  }
}
