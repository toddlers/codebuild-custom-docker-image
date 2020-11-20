# codebuild-custom-docker-image

## Building custom docker image with tools for codebuild projects.

#### As pulling the docker images from dockerhub got throttled, so there is a high chance whenever we want to build something , we might get into this trouble. So CFN templates takes care of that. It creates following things for building the automation:

1. ECR(EC2 Container Registry)
2. A CodeBuild Project with `buildpec` inside for installing various tools like below which can be adjusted via the `Makefile`
  * Terraform
  * Tfenv
  * Boto3
  * Configures Python3
  * Golang
  * Jq
  * Unzip
3. A `CloudWatch Crontab` entry to invoke the `CodeBuild` Job at midnight
4. A `CloudWatch` event Rule catches the `CodeBuild`  status for following states:
  * FAILED
  * STOPPED
  * SUCCEEDED
5. Event Rule subscribed to a SNS Topic
6. And then `AWS Chatbot` receives notifications from above SNS topic eventually send them to Configured Slack Channel.


#### The idea can be further refined to have a custom lambda deployed and subscribed to cloudwatch events for codebuild status updates, process the status maybe add more metadata to it and send the notification via slack or SES. 

#### Note:
 * As of now `AWS Chabot` is not supported via terraform[1] because there is no support via AWS Go SDK[2]. So this might look more cleaner in `terraform`.
 
 
1. https://github.com/hashicorp/terraform-provider-aws/issues/12304
2.  https://github.com/aws/aws-sdk-go/issues/3582
