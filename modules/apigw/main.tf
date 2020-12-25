data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.namespace}-api"
  description = "This api proxies all request to a lambda handler"
}

#apigw role
resource "aws_api_gateway_account" "apigw_account" {
  depends_on = [aws_iam_role_policy.cloudwatch]
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global-${var.namespace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_lambda_permission" "lambda_permission_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*"
}

#GET / (redirects to /ui)
resource "aws_api_gateway_method" "redirect_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "redirect_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.redirect_method.http_method 
  type = "MOCK"
  request_templates = { "application/json" = <<-EOF
  {
    "statusCode" : 302
  }
EOF
}
}

resource "aws_api_gateway_method_response" "redirect" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.redirect_method.http_method 

  response_parameters = {
    "method.response.header.Location" = true
  }

  status_code = "302"
}

resource "aws_api_gateway_integration_response" "redirect_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.redirect_method.http_method 
  status_code = aws_api_gateway_method_response.redirect.status_code 

  response_parameters = {
    "method.response.header.Location" = "'/v1/ui'"
  }
}

# /{proxy+}
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

#ANY /{proxy+}
resource "aws_api_gateway_method" "auth_any" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "any_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.auth_any.http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_resource.proxy,
    aws_api_gateway_method.auth_any,
    aws_api_gateway_integration.any_method_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"
}
