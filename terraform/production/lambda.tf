data "archive_file" "twitter_consumer" {
  type        = "zip"
  output_path = "../../src/main/python/consumer.zip"
  source_dir  = "../../src/main/python/"
}

resource "aws_lambda_function" "twitter_consumer" {
  function_name = "twitter_consumer"
  handler       = "App.lambda_twitter_consumer"
  runtime       = "python2.7"
  s3_bucket     = "marcos-testing-data"
  s3_key        = "consumer.zip"
  role          = "${aws_iam_role.iam_for_terraform_lambda.arn}"
  memory_size   = "2048"
  timeout       = "600"

  depends_on = [
    "data.archive_file.twitter_consumer",
    "aws_iam_role.iam_for_lambda"
  ]

  environment {
    variables {
      app_key             = "${var.twitter_app_key}"
      app_secret          = "${var.twitter_app_secret}"
      oauth_token         = "${var.twitter_oauth_token}"
      oauth_token_secret  = "${var.twitter_oauth_token_secret}"
      filter_subject      = "${var.twitter_filter_subject}"
      kinesis_stream_name = "${aws_kinesis_stream.test_stream.name}"
    }
  }

    provisioner "local-exec" {
    command = "../../s3_upload.sh ${aws_s3_bucket.bucket.name}"
  }
}

resource "aws_lambda_function" "dynamo_producer" {
  function_name = "dynamo_producer"
  handler       = "App.dynamo_producer_from_kinesis"
  runtime       = "python2.7"
  s3_bucket     = "marcos-testing-data"
  s3_key        = "consumer.zip"
  role          = "${aws_iam_role.iam_for_terraform_lambda.arn}"
  memory_size   = "2048"
  timeout       = "180"

  depends_on = [
    "data.archive_file.twitter_consumer",
    "aws_lambda_function.twitter_consumer"
  ]
}

resource "aws_lambda_function" "dynamo_api" {
  function_name = "dynamo_api"
  handler       = "DynamoAPIFuncional.lambda_handler"
  runtime       = "python2.7"
  s3_bucket     = "marcos-testing-data"
  s3_key        = "consumer.zip"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  memory_size   = "2048"
  timeout       = "180"

  depends_on = [
    "data.archive_file.twitter_consumer",
    "aws_lambda_function.dynamo_producer"
  ]
}
