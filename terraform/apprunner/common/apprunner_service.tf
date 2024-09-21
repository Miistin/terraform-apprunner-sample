// AppRunenr
resource "aws_apprunner_service" "sample" {
  service_name = "sample"

  source_configuration {
    image_repository {
      image_repository_type = "ECR"
      image_configuration {
        port             = "8080"
        runtime_environment_variables = {
          SUBNET_IDS = join("," , data.aws_subnets.current.ids)
          SECURITY_GROUP_ID = data.aws_security_group.current.id
        }
      }
      image_identifier = "${aws_ecr_repository.apprun-ecr-repository.repository_url}:latest"
    }
    auto_deployments_enabled = true
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
    }
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_role.arn
  }

  depends_on = [null_resource.deploy]
}
