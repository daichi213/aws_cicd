output "codecommit_repository" {
  value = aws_codecommit_repository.repo-01.clone_url_http
}
