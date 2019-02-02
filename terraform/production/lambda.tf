data "archive_file" "twitter_consumer" {
  type        = "zip"
  output_path = "../../src/main/python/consumer.zip"
  source_dir  = "../../src/main/python/"

  depends_on = ["aws_iam_role.iam_for_lambda"]
}

resource "aws_lambda_function" "twitter_consumer" {
  function_name = "twitter_consumer"
  handler       = "App.lambda_twitter_consumer"
  runtime       = "python2.7"
  filename      = "../../src/main/python/consumer.zip"
  role          = "${aws_iam_role.iam_for_terraform_lambda.arn}"
  memory_size   = "2048"
  timeout       = "600"

  depends_on = [
    "data.archive_file.twitter_consumer",
  ]

  environment {
    variables {
      app_key             = "7oNLyfSizGCIY27atxC10bpmj"
      app_secret          = "g8f46YmsRIR0AxdIVtDvooJBxvr2MA8NwjZdKnuTjnmfGeg7IH"
      oauth_token         = "882363468187303936-5Dz40L9SVlLjBPHHcykw2q3EXUMCIEi"
      oauth_token_secret  = "DN9ynBUMeSBl0Twf034Jijn7eCIntZHsFYIIhJehDZOSV"
      filter_subject      = "brasil"
      kinesis_stream_name = "access_log"
    }
  }
}

resource "aws_lambda_function" "dynamo_producer" {
  function_name = "dynamo_producer"
  handler       = "App.dynamo_producer_from_kinesis"
  runtime       = "python2.7"
  filename      = "../../src/main/python/consumer.zip"
  role          = "${aws_iam_role.iam_for_terraform_lambda.arn}"
  memory_size   = "2048"
  timeout       = "180"

  depends_on = [
    "data.archive_file.twitter_consumer",
  ]
}

resource "aws_lambda_function" "dynamo_api" {
  function_name = "dynamo_api"
  handler       = "DynamoProducerFuncional.lambda_handler"
  runtime       = "python2.7"
  filename      = "../../src/main/python/consumer.zip"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  memory_size   = "2048"
  timeout       = "180"

  depends_on = [
    "data.archive_file.twitter_consumer",
  ]
}
