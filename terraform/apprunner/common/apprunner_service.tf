// AppRunenr
resource "aws_apprunner_service" "sample" {
  service_name = "sample"

  source_configuration {
    image_repository {
      image_repository_type = "ECR"
      image_configuration {
        port             = "8080"
      }
      image_identifier = "${aws_ecr_repository.apprun-ecr-repository.repository_url}:latest"
    }
    auto_deployments_enabled = true
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
    }
  }

  depends_on = [null_resource.deploy]
}
