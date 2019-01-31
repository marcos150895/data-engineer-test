resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = "${aws_iam_role.iam_for_lambda.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
            "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject*", "s3:PutObject*"],
      "Resource": ["arn:aws:s3:::*"]
    },
    {
      "Effect": "Allow",
      "Action": [
          "kinesis:*"
      ],
      
      "Resource": "arn:aws:kinesis:*:*:*"
    },
    {
      "Action": [
         "kinesis:PutRecords",
                "lambda:UpdateFunctionConfiguration",
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:CreateLogStream",
                "kinesis:ListStreams",
                "kinesis:GetRecord",
                "kinesis:PutRecord",
                "kinesis:GetShardIterator",
                "kinesis:DescribeStream",
                "kinesis:UpdateShardCount",
                "kinesis:GetRecords",
                "dynamodb:ListTables",
                "dynamodb:DeleteItem",
                "dynamodb:ListTagsOfResource",
                "dynamodb:DescribeReservedCapacityOfferings",
                "dynamodb:DescribeTable",
                "dynamodb:GetItem",
                "dynamodb:DescribeContinuousBackups",
                "dynamodb:DescribeLimits",
                "dynamodb:BatchGetItem",
                "dynamodb:BatchWriteItem",
                "dynamodb:ConditionCheckItem",
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:Query",
                "dynamodb:DescribeStream",
                "dynamodb:UpdateItem",
                "dynamodb:DescribeTimeToLive",
                "dynamodb:ListStreams",
                "dynamodb:CreateTable",
                "dynamodb:DescribeGlobalTableSettings",
                "dynamodb:GetShardIterator",
                "dynamodb:DescribeGlobalTable",
                "dynamodb:DescribeReservedCapacity",
                "dynamodb:DescribeBackup",
                "dynamodb:UpdateTable",
                "dynamodb:GetRecords"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
