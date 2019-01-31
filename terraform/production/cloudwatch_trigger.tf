resource "aws_cloudwatch_event_rule" "every_5_minutes_lambda" {
  name                = "trigger_lambda_twitter_consumer"
  description         = ""
  schedule_expression = "cron(0/5 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule      = "${aws_cloudwatch_event_rule.every_5_minutes_lambda.name}"
  target_id = "twitter_consumer"
  arn       = "${aws_lambda_function.twitter_consumer.arn}"
}

resource "aws_lambda_permission" "cloudwatch_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "twitter_consumer"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_5_minutes_lambda.arn}"
}
