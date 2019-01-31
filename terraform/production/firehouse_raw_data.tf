resource "aws_kinesis_firehose_delivery_stream" "firehouse_raw_data" {
  name        = "firehouse_raw_data"
  destination = "s3"

  kinesis_source_configuration {
    role_arn           = "${aws_iam_role.firehose_role.arn}"
    kinesis_stream_arn = "${aws_kinesis_stream.test_stream.arn}"
  }

  s3_configuration {
    role_arn        = "${aws_iam_role.firehose_role.arn}"
    bucket_arn      = "${aws_s3_bucket.bucket.arn}"
    prefix          = "raw/"
    buffer_size     = 10
    buffer_interval = 400
  }

  depends_on = [
    "aws_kinesis_stream.test_stream",
    "aws_iam_role.firehose_role",
  ]
}
