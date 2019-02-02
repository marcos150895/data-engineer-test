
resource "aws_lambda_event_source_mapping" "trigger" {
  event_source_arn  = "${aws_kinesis_stream.test_stream.arn}"
  function_name     = "${aws_lambda_function.dynamo_producer.arn}"
  starting_position = "LATEST"
}