locals {

  cb-01 = {
    name        = "${var.repo_name}-cb"
    description = "CodeBuild Project"

  }

}

# ====================
#
# Codebuild
#
# ====================
resource "aws_codebuild_project" "cb-01" {
  name          = local.cb-01["name"]
  description   = local.cb-01["description"]
  build_timeout = "5"
  service_role  = aws_iam_role.cb-01-role.arn

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.repo-01.clone_url_http
    git_clone_depth = 1
  }

  source_version = "refs/heads/master"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.ecr-01.name
    }

  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/codebuild/${var.service_name}-cb"
      stream_name = ""
    }

  }

}
