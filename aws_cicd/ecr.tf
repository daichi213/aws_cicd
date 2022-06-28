locals {

  ## ecr
  ecr-01 = {
    name         = var.repo_name
    scan_on_push = "false"
  }

}

## ecr
resource "aws_ecr_repository" "ecr-01" {
  name = local.ecr-01["name"]

  image_scanning_configuration {
    scan_on_push = local.ecr-01["scan_on_push"]

  }
}
