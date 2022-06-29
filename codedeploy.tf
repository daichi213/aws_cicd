locals {

  ## app runner role
  apprun-01-role = {
    name = "${var.service_name}-role"

    ## policy-01: AWSAppRunnerServicePolicyForECRAccess

  }

  ## codebuild role
  cb-01-role = {
    name = "${var.service_name}-cb-role"

    policy-01 = {
      name = "${var.service_name}-cb-policy"
    }
    ## policy-02: AmazonEC2ContainerRegistryPowerUser

  }

  ## codepipeline role
  cp-01-role = {
    name = "${var.service_name}-cp-role"

    policy-01 = {
      name = "${var.service_name}-cp-policy"
    }
  }

  ## cloudwatch events role
  cwe-01-role = {
    name = "${var.service_name}-cwe-role"

    policy-01 = {
      name = "${var.service_name}-cwe-policy"
    }

  }

  instance_role = {
    name = "${var.service_name}_instance_role"

    policy-01 = {
      name = "${var.service_name}_instance_policy"
    }
  }

}

resource "aws_codedeploy_app" "deploy_app" {
  name = "example-app"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.example.name
  deployment_group_name = "example-group"
  service_role_arn      = aws_iam_role.deploy_role.arn

  ec2_tag_filter {
    key   = "filterkey2"
    type  = "KEY_AND_VALUE"
    value = "filtervalue"
  }
  
  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "example-trigger"
    trigger_target_arn = aws_sns_topic.example.arn
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