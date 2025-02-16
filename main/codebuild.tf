# SSMパラメータストアからGitHubのトークンを取得する
data "aws_ssm_parameter" "github_token" {
  name = "/continuous-apply/github-token"
}

# CodeBuildのプロジェクトを作る
resource "aws_codebuild_project" "continuous-apply" {
  # CodeBuildのプロジェクト名
  name = "continuous-apply"
  # CodeBuildのプロジェクトのロール、モジュールで作るもの
  service_role = module.continuous_apply_codebuild_role.iam_role_arn

  # CodeBuildのソース
  # GitHubのリポジトリを設定
  source {
    type = "GITHUB"
    location = "https://github.com/swada-oguro/terraform-hook-2025-02-15.git"
  }

  # Terraformを実行するだけなので成果物はなし
  artifacts {
    type = "NO_ARTIFACTS"
  }

  # CodeBuildが動かすコンテナとスペックを設定
  # hashicorp/terraform:1.3.7というイメージをSMALLで動かす
  environment {
    type = "LINUX_CONTAINER"
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "hashicorp/terraform:1.3.7"
    privileged_mode = false
  }

  # ここにはToDo感がある
  # Terraformで設定できないものをコマンドでやる。最後の手段
  # local-execはTerraformを実行しているマシンで実行される
  provisioner "local-exec" {
    # dataでSSMパラメータストアからGitHubトークンを取得して環境変数に入れる
    environment = {
      GITHUB_TOKEN = data.aws_ssm_parameter.github_token.value
    }
    # 環境変数のGitHubトークンをCodeBuildにインポートする
    # このインポートはCodeBuildの全プロジェクトで有効となる
    command = <<-EOT
      aws codebuild import-source-credentials \
        --server-type GITHUB \
        --auth-type PERSONAL_ACCESS_TOKEN \
        --token $GITHUB_TOKEN
    EOT
  }
}

