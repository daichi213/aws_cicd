locals {

  code_deploy_app = {
    name = "${var.service_name}_codedeploy_app"
  }

  code_deployment_group = {
    name = "${var.service_name}_codedeployment_group"
  }

}

resource "aws_codedeploy_app" "deploy_app" {
  name = local.code_deploy_app.name
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.deploy_app.name
  deployment_group_name = local.code_deployment_group.name
  service_role_arn      = aws_iam_role.deploy_role.arn

  ec2_tag_filter {
    key   = "filterkey2"
    type  = "KEY_AND_VALUE"
    value = "filtervalue"
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "example-trigger"
    trigger_target_arn = aws_sns_topic.CICD_execution_results.arn
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }
}