terraform {
  required_providers {
    aws = {
      version = ">= 4.49.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Name  = "tf-test",
      Env   = "terraform-aws-2025-02-15",
      Owner = "swada",
    }
  }

}

