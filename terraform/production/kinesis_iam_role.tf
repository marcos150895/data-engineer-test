resource "aws_iam_role" "iam_for_terraform_lambda" {
  name = "consumer_role"
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

resource "aws_iam_role_policy" "consumer_role_policy" {
  name = "consumer_role_policy"
  role = "${aws_iam_role.iam_for_terraform_lambda.id}"
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
      "Sid": "Stmt1493060054000",
      "Effect": "Allow",
      "Action": ["lambda:InvokeAsync", "lambda:InvokeFunction"],
      "Resource": ["arn:aws:lambda:*:*:*"]
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
        "kinesis:GetRecords",
        "kinesis:PutRecords",
        "kinesis:UpdateShardCount",
        "kinesis:PutRecord",
        "kinesis:GetRecord",
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:ListStreams",
        "lambda:UpdateFunctionConfiguration"
        
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
