# CodeBuildプロジェクトにWebhookの設定をする
resource "aws_codebuild_webhook" "continuous_apply" {

  # 設定をするCodeBuildのプロジェクトをnameで指定する
  project_name = aws_codebuild_project.continuous-apply.name

  # プルリクを作った時。Openになる
  filter_group {
    filter {
      type = "EVENT"
      pattern = "PULL_REQUEST_CREATED"
    }
  }

  # プルリクが更新されたとき。commitして修正した
  filter_group {
    filter {
      type = "EVENT"
      pattern = "PULL_REQUEST_UPDATED"
    }
  }
  
  # プルリクの再Open。あまり無い気がする
  filter_group {
    filter {
      type = "EVENT"
      pattern = "PULL_REQUEST_REOPENED"
    }
  }
  
  # mainブランチへのpush。つまりmainへのプルリクマージ
  filter_group {
    filter {
      type = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type = "HEAD_REF"
      pattern = "main"
    }
  }
}
