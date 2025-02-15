module "continuous_apply_codebuild_role" {
  source     = "./iam_role"
  name       = "continuous-apply"
  identifier = "codebuild.amazonaws.com"
  policy     = data.aws_iam_policy.administrator_access.policy
}


data "aws_iam_policy" "administrator_access" {
  # コンソールで調べて貼り付けた
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "iam_role_arn" {
  value = module.continuous_apply_codebuild_role.iam_role_arn
}

output "iam_role_name" {
  value = module.continuous_apply_codebuild_role.iam_role_name
}
