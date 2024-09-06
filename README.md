## TerraformでAppRunnerをデプロイするサンプル
このリポジトリは、TerraformでAppRunnerをデプロイする最小構成サンプルです。

## Requirements

- Terraform v1.9.0
- AWS CLI v2.16.9以上

## 使い方
### 1. 事前準備
#### AWS CLIの設定
既にやってる場合は不要です。

```bash
aws configure --profile <profile-name>
```

#### Profileの指定
`terraform/apprunner/dev/main.tf`の`provider`の`profile`を設定してください。

```hcl
provider "aws" {
  region  = "<region>"
  profile = "<profile-name>"
}
```

### Terraformの初期化
```bash
cd terraform/apprunner/dev
terraform init
```

### Plan

```bash
cd terraform/apprunner/dev
terraform plan
```

### 環境の構築

```bash
cd terraform/apprunner/dev
terraform apply
```

### 環境の削除

```bash
cd terraform/apprunner/dev
terraform destroy
```
