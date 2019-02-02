# resource "aws_kinesis_firehose_delivery_stream" "firehouse_parquet_data" {
#   name        = "firehouse_parquet_data"
#   destination = "extended_s3"

#   kinesis_source_configuration {
#     role_arn           = "${aws_iam_role.firehose_role.arn}"
#     kinesis_stream_arn = "${aws_kinesis_stream.test_stream.arn}"
#   }

#   extended_s3_configuration {
#     role_arn        = "${aws_iam_role.firehose_role.arn}"
#     bucket_arn      = "${aws_s3_bucket.bucket.arn}"
#     prefix          = "parquet/"
#     buffer_interval = "300"
#     buffer_size     = "128"

#     data_format_conversion_configuration {
#       input_format_configuration {
#         deserializer {
#           open_x_json_ser_de {
#             case_insensitive                         = "true"
#             convert_dots_in_json_keys_to_underscores = "false"
#           }
#         }
#       }

#       output_format_configuration {
#         serializer {
#           parquet_ser_de {
#             block_size_bytes              = "268435456"
#             compression                   = "SNAPPY"
#             enable_dictionary_compression = "false"
#             max_padding_bytes             = "0"
#             page_size_bytes               = "1048576"
#             writer_version                = "V1"
#           }
#         }
#       }

#       schema_configuration {
#         database_name = "${aws_glue_catalog_database.aws_glue_catalog_database.name}"
#         role_arn      = "${aws_iam_role.firehose_role.arn}"
#         table_name    = "raw"
#         version_id    = "LATEST"
#       }
#     }
#   }

#   depends_on = [
#     "aws_kinesis_stream.test_stream",
#     "aws_iam_role.firehose_role",
#   ]
# }
