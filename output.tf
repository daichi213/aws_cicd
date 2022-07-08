output "codecommit_repository" {
  value = aws_codecommit_repository.repo-01.clone_url_http
}

# TODO 実際の運用時には絶対にここを削除しなければならない
# この部分はtfstateファイルに出力されるが、運用時は必ずcommitする必要があるためsrcがPublicの場合は大変危険
output "developer_access_key" {
  value = aws_iam_access_key.developer_access_key.id
}

output "developer_secret_key" {
  value = aws_iam_access_key.developer_access_key.secret
}
