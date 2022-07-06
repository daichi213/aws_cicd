locals {

  aws_sns_topic = {
    name = "${var.service_name}_sns_topic_name.fifo"
  }

  email_destination = {
    value = "${var.service_name}"
  }

}

resource "aws_sns_topic" "CICD_execution_results" {
  name                        = local.aws_sns_topic.name
  fifo_topic                  = true
  content_based_deduplication = true
}

resource "aws_sns_topic_subscription" "execution_results_target" {
  topic_arn = aws_sns_topic.CICD_execution_results.arn
  protocol  = "email"
  endpoint  = local.email_destination.value
}