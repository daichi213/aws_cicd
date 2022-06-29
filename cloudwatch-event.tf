locals {

  cwe-01 = {
    name        = "${aws_codepipeline.cp-01.name}-cwe"
    description = "CodePipeline CloudWatch Events"
  }

}

## cloudwatch event
resource "aws_cloudwatch_event_rule" "cwe-01" {
  name        = local.cwe-01["name"]
  description = local.cwe-01["description"]

  event_pattern = <<EOH
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "${aws_codecommit_repository.repo-01.arn}"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ],
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "master"
    ]
  }
}
EOH
}

resource "aws_cloudwatch_event_target" "cwe-01_target" {
  rule      = aws_cloudwatch_event_rule.cwe-01.name
  target_id = "CodePipeline"
  arn       = aws_codepipeline.cp-01.arn
  role_arn  = aws_iam_role.cwe-01-role.arn
}
