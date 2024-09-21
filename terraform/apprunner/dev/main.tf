locals {
  profile = "admin"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

provider "aws" {
  region = "ap-northeast-1"  # 変数を参照する形でAWSプロバイダを設定
  profile = local.profile
}

module "common" {
  source = "../common"
  vpc_id = var.vpc_id
}

#terraform {
#  backend "s3" {
#    bucket = "bucket-name"              # Terraformの状態を保存するS3バケット名
#    key    = "sample/terraform.tfstate" # S3バケット内の保存先パス
#    region = "ap-northeast-1"           # S3バケットのリージョン
#    profile = "terraform"               # S3バケットにアクセスするためのプロファイル名
#  }
#}
