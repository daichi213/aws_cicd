locals {

  repo-01 = {
    name        = var.repo_name
    description = var.repo_description
  }

}

## codecommit
resource "aws_codecommit_repository" "repo-01" {
  repository_name = local.repo-01["name"]
  description     = local.repo-01["description"]
}
