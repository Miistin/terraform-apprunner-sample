resource "aws_cloudwatch_log_group" "apprunner_log_group" {
  name = "apperunner"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "apprunner_log_stream" {
  name           = "api"
  log_group_name = aws_cloudwatch_log_group.apprunner_log_group.name
}
