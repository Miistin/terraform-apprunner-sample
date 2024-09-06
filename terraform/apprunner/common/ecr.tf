
resource "aws_ecr_repository" "apprun-ecr-repository" {
  name = "my-ecr-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "archive_file" "deploy" {
  type        = "zip"
  output_path = "${path.module}/../../../build/hello.zip"
  source_dir  = "${path.module}/../../../src"
  # .dockerignore 相当の指定を行う。
  excludes = setunion(
    fileset("${path.module}/../../..", "test/**/*"),
  )
}

resource "null_resource" "deploy" {
  provisioner "local-exec" {
    command = <<BASH
      cd ../../../
      echo "Create Docker Image"
      ./gradlew dockerBuild

      # 最新のトークンを取得
      LOGIN_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)
      if [ $? -ne 0 ]; then
        echo "Failed to get ECR login password"
        exit 1
      fi

      echo "Deploy Docker Image to ECR"
      # ECRにログイン
      echo $LOGIN_PASSWORD | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
      docker tag ${var.imagename}:latest $REPOSITORY_URL:latest
      docker push $REPOSITORY_URL":latest"
    BASH

    environment = {
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
      AWS_REGION = data.aws_region.current.name
      REPOSITORY_URL = aws_ecr_repository.apprun-ecr-repository.repository_url
    }
  }

  triggers = {
    sha256 = "${data.archive_file.deploy.output_sha}"
  }
}

