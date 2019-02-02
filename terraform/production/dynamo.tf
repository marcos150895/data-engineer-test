resource "aws_dynamodb_table" "table_tweet" {
  name           = "tweet"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "hash_line"
  range_key      = "user_id"

  tags = {
    Name        = "dynamodb-tweets-1"
    Environment = "production"
    Owner       = "Marcos"
  }

  attribute {
    name = "hash_line"
    type = "S"
  }
}
