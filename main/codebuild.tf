resource "aws_codebuild_project" "continuous-apply" {
  name = "continuous-apply"
  service_role = module.continuous_apply_codebuild_role.iam_role_arn

  source {
    type = "GITHUB"
    location = "https://github.com/swada-oguro/terraform-hook-2025-02-15.git"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    type = "LINUX_CONTAINER"
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "hashicorp/terraform:1.3.7"
    privileged_mode = false
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws codebuild import-source-credentials \
        --server-type GITHUB \
        --auth-type PERSONAL_ACCESS_TOKEN \
        --token $GITHUB_TOKEN
    EOT
    environment = {
      GITHUB_TOKEN = data.aws_ssm_parameter.github_token.value
    }
  }
}

data "aws_ssm_parameter" "github_token" {
  name = "/continuous-apply/github-token"
}
