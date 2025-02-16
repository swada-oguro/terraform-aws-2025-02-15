variable "name" {
  description = "ロールの名前"
  default = "continuous-apply"
}
variable "policy" {
  description = "ポリシー。JSON"
}
variable "identifier" {
  description = "信頼するサービス"
  default = "codebuild.amazonaws.com"
}

# 信頼するサービスを指定して、信頼関係ポリシードキュメントを作成する
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}
# ロール名と↑で作った信頼関係ポリシードキュメントを指定してロールを作成
resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# ポリシー名とポリシーの内容をJSONで指定してポリシーを作成する
resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy
}

# ロールにポリシーをアタッチする
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

# 作ったロールのarnを出力する
output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

# 作ったロールの名前を出力する
output "iam_role_name" {
  value = aws_iam_role.default.name
}

