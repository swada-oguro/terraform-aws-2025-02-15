# モジュールに渡すポリシーをdataで参照する
data "aws_iam_policy" "administrator_access" {
  # AWSが提供する管理ポリシー（AdministratorAccess）を参照する
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# モジュールを使ってロールを作る
# CodeBuildに↑の管理権限を任せる
module "continuous_apply_codebuild_role" {
  source     = "./iam_role"
  name       = "continuous-apply"
  identifier = "codebuild.amazonaws.com"
  policy     = data.aws_iam_policy.administrator_access.policy
}


# 作成したロールのarnを出力する
output "iam_role_arn" {
  value = module.continuous_apply_codebuild_role.iam_role_arn
}

# 作成したロールの名前を出力する
output "iam_role_name" {
  value = module.continuous_apply_codebuild_role.iam_role_name
}
