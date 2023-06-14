# S3 버킷 생성
resource "aws_s3_bucket" "example_bucket" {
  bucket = "fourdollar-s3"  # 버킷 이름, 고유하게 설정
  acl    = "private"         # 버킷 ACL (접근 제어 목록) 설정

  lifecycle_rule {
    id      = "lifecycle"
    enabled = true

    expiration {
      days = 30
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
        kms_master_key_id = ""
      }
    }
  }
}
# S3 액세스 설정
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}