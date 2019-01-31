resource "aws_glue_crawler" "s3_raw" {
  database_name = "${aws_glue_catalog_database.aws_glue_catalog_database.name}"
  name          = "s3_raw"
  role          = "${aws_iam_role.glue.arn}"
  schedule      = "cron(*/6 * * * ? *)"

  s3_target {
    path = "s3://${aws_s3_bucket.bucket.bucket}/raw/"
  }
}

resource "aws_glue_crawler" "s3_parquet" {
  database_name = "${aws_glue_catalog_database.aws_glue_catalog_database.name}"
  name          = "s3_parquet"
  role          = "${aws_iam_role.glue.arn}"
  schedule      = "cron(*/6 * * * ? *)"

  s3_target {
    path = "s3://${aws_s3_bucket.bucket.bucket}/parquet/"
  }
}
