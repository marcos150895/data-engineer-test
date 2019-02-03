resource "aws_s3_bucket" "bucket" {
  bucket = "marcos-testing-data"
  acl    = "private"
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.bucket.id}"
  key    = "consumer.zip"
  source = "../../src/main/python/consumer.zip"

  depends_on = [
    "data.archive_file.twitter_consumer",
  ]
}
