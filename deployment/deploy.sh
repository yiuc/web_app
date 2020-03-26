#!/bin/sh -e
set -e

# register task-definition
sed <deployment/td-nginx.template -e "s,@VERSION@,${1},">TASKDEF.json
aws ecs register-task-definition --cli-input-json file://TASKDEF.json > REGISTERED_TASKDEF.json
TASKDEFINITION_ARN=$( < REGISTERED_TASKDEF.json jq .taskDefinition.taskDefinitionArn )

# create or update service
app_spec_content_string=$(jq -nc \
  --arg container_name "web" \
  --arg container_port "5000" \
  --arg task_definition_arn "$TASKDEFINITION_ARN" \
  '{version: 1, Resources: [{TargetService: {Type: "AWS::ECS::Service", Properties: {TaskDefinition: $task_definition_arn, LoadBalancerInfo: {ContainerName: $container_name, ContainerPort: $container_port}}}}]}')
app_spec_content_sha256=$(echo -n "$app_spec_content_string" | shasum -a 256 | sed 's/ .*$//')
revision="revisionType=AppSpecContent,appSpecContent={content='$app_spec_content_string',sha256=$app_spec_content_sha256}"

aws deploy create-deployment \
  --application-name="kaios-deploy" \
  --deployment-group-name="kaios-deploy" \
  --revision="$revision"