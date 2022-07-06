# Error一覧

## SNSのFIFOタイプについて

- 内容

SNS TOPICをFIFOタイプにしてインフラを構築した際に、以下のエラーが発生した。

```powershell
Error: error creating SNS Topic Subscription: InvalidParameter: Invalid parameter: Invalid protocol type: email │ status code: 400, request id:....
```

- 解決

[原因としてはFIFOはSQSに対してのみしか適用できない](https://stackoverflow.com/questions/64540867/why-do-i-get-an-error-when-trying-to-add-an-sns-trigger-to-my-aws-lambda-functio)ためこのようなエラーが発生していた。


```terraform
resource "aws_sns_topic" "CICD_execution_results" {
  name                        = local.aws_sns_topic.name
  fifo_topic                  = true
  content_based_deduplication = true
}
```

上のfifoタイプを標準タイプに変更したことでエラーは解消した。

```terraform
resource "aws_sns_topic" "CICD_execution_results" {
  name                        = local.aws_sns_topic.name
}
```
