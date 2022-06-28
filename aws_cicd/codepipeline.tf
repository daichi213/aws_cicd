locals {

  cp-01 = {
    name        = "${var.service_name}-cp"
    description = "App Runner for CodePipeline"

    artifact_store_name = "${var.service_name}-artifact"

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
      name            = "Build"
      namespace       = "BuildVariables"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      ## output_artifacts = ["BuildArtifact"]
      version = "1"

      configuration = {
        ProjectName = aws_codebuild_project.cb-01.name
      }
    }
  }

}
