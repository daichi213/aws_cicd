locals {

  cp-01 = {
    name        = "${var.service_name}-cp"
    description = "App Runner for CodePipeline"

    artifact_store_name = "${var.service_name}-artifact-for-cicdpipeline"

  }

}

## s3 bucket
resource "aws_s3_bucket" "artifact_store" {
  bucket        = local.cp-01["artifact_store_name"]
  acl           = "private"
  force_destroy = true
}

## codepipeline
resource "aws_codepipeline" "cp-01" {
  name     = local.cp-01["name"]
  role_arn = aws_iam_role.cp-01-role.arn

  artifact_store {
    location = aws_s3_bucket.artifact_store.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      run_order        = 1
      name             = "Source"
      namespace        = "SourceVariables"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName       = aws_codecommit_repository.repo-01.repository_name
        BranchName           = "master"
        OutputArtifactFormat = "CODE_ZIP"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      namespace        = "BuildVariables"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.cb-01.name
      }
    }
  }

  # https://docs.aws.amazon.com/ja_jp/codepipeline/latest/userguide/reference-pipeline-structure.html#reference-action-artifacts
  # 上記URLの「プロバイダータイプのアクション設定プロパティ」を参考にした
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      namespace       = "DeployVariables"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.deploy_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.id
      }
    }
  }

}
