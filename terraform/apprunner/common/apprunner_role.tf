resource "aws_iam_role" "apprunner_role" {
  name               = "AppRunnerECRAccess"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = ["build.apprunner.amazonaws.com", "tasks.apprunner.amazonaws.com"]
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "AppRunnerCloudWatchLogsAccess"
  description = "Allows AppRunner And Lambda to write logs to CloudWatch"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# ECSタスクを実行するためのIAMポリシー
resource "aws_iam_policy" "ecs_run_task_policy" {
  name        = "AppRunnerECSRunTaskAccess"
  description = "Allows AppRunner to run ECS tasks"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask",
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:StopTask",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task-definition/*" // 必要に応じてリソースARNを修正
      }
    ]
  })
}

# AppRunnerがECSタスク実行ロールをパスするためのIAMポリシー
resource "aws_iam_policy" "pass_role_policy" {
  name        = "AppRunnerPassRolePolicy"
  description = "Allows AppRunner to pass the ECS task execution role"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = aws_iam_role.ecs_task_execution_role.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pass_role_policy_attachment" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = aws_iam_policy.pass_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "apprunner_ecs_run_task_policy_attachment" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = aws_iam_policy.ecs_run_task_policy.arn
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_access_policy" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy_attachment" "apprunner_cloudwatch_logs_policy_attachment" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}
