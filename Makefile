INSTALLATION_ID=dev
ENVIRONMENT=test
CONTAINER_REPOSITORY_NAME=docker-images
TERRAFORM_VERSION=0.13.5
TFENV_VERSION=2.0.0
PACKAGES=curl python3 python3-pip  golang jq unzip
PIP_PACKAGES=boto3 awscli
SLACK_CONFIGURATION_NAME=
SLACK_CHANNEL_ID=
SLACK_WORKSPACE_ID=
CHATBOT_LOGGING_LEVEL=NONE

 check-region-profile-set:
	if [ -z "${AWS_REGION}" ]; then \
        echo "AWS_REGION environment variable is not set."; exit 1; \
    fi
	if [ -z "${AWS_PROFILE}" ]; then \
        echo "AWS_PROFILE environment variable is not set."; exit 1; \
    fi

.PHONY: cfn-lint
cfn-lint: cfn-lint codebuild.yml

deploy: codebuild.yml
	aws \
	    --region $(AWS_REGION) \
	    cloudformation deploy \
	    --template-file $< \
	    --stack-name bake-docker-image \
	    --capabilities CAPABILITY_NAMED_IAM \
	    --no-fail-on-empty-changeset \
		  --tags Team=DevOps Application=DockerImageAutomation \
	    --parameter-overrides \
					"InstallationId=$(INSTALLATION_ID)" \
					"Environment=$(ENVIRONMENT)" \
					"ContainerRepositoryName=$(CONTAINER_REPOSITORY_NAME) \
					"TerraformVersion=$(TERRAFORM_VERSION) \
					"TfenvVersion=$(TFENV_VERSION) \
					"SlackChannelId=$(SLACK_CHANNEL_ID) \
					"SlackWorkspaceId=$(SLACK_WORKSPACE_ID) \
					"SlackConfigurationName=$(SLACK_CONFIGURATION_NAME) \
					"ChatBotLoggingLevel=$(CHATBOT_LOGGING_LEVEL)