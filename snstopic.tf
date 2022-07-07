locals {

  aws_sns_topic = {
    name = "${var.service_name}_sns_topic_name"
  }

  email_destination = {
    value = "${var.email_destination}"
  }

}

resource "aws_sns_topic" "CICD_execution_results" {
  name = local.aws_sns_topic.name
}

resource "aws_sns_topic_subscription" "execution_results_target" {
  topic_arn = aws_sns_topic.CICD_execution_results.arn
  protocol  = "email"
  endpoint  = local.email_destination.value
}
