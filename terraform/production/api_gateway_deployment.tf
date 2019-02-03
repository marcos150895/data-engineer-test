resource "aws_api_gateway_deployment" "deployment_dynamo_api" {
  depends_on = ["aws_api_gateway_integration.integration_get"]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "deploying_api"

  variables = {
    "answer" = "42"
  }
}
