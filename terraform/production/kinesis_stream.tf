resource "aws_kinesis_stream" "test_stream" {
  name             = "tweet_stream"
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Environment = "Production"
  }
}
