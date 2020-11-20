# codebuild-custom-docker-image

Building custom docker image with tools for codebuild projects.

As pulling the docker images from dockerhub got throttled, so there is a high chance whenever we want to build something , we might get into this trouble.
So CFN templates takes care of that. It creates following things for building the automation:

1. ECR(EC2 Container Registry)
2. A CodeBuild Project with `buildpec` inside for installing various tools like 
  * Terraform
  * Tfenv
  * Boto3
  * Configures Python3
  * Golang
  * Jq
  * Unzip
  They are configurable via the `Makefile`
3. A `CloudWatch Crontab` entry to invoke the `CodeBuild` Job at midnight
4. A `CloudWatch` event Rule catches the `CodeBuild`  status for following states:
  * FAILED
  * STOPPED
  * SUCCEEDED
5. Event Rule subscribed to a SNS Topic
6. And then `AWS Chatbot` receives notifications from above SNS topic eventually send them to Configured Slack Channel.


