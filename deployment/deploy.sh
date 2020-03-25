#!/bin/sh -e

#Usage: CONTAINER_VERSION=docker_container_version [create|update]

# register task-definition
sed <td-nginx.template -e "s,@VERSION@,$CONTAINER_VERSION,">TASKDEF.json
aws ecs register-task-definition --cli-input-json file://TASKDEF.json > REGISTERED_TASKDEF.json
TASKDEFINITION_ARN=$( < REGISTERED_TASKDEF.json jq .taskDefinition.taskDefinitionArn )