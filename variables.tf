## access_key
variable "aws_access_key" {}

## secret key
variable "aws_secret_key" {}

## region
variable "aws_region" {}

## aws account reference
data "aws_caller_identity" "current" {}

## repository name
variable "repo_name" {}

## repository description
variable "repo_description" {}

## aws app runner service name
variable "service_name" {}
