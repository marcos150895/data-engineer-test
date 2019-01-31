resource "aws_s3_bucket" "bucket" {
  bucket = "marcos-testing-data"
  acl    = "private"
}
