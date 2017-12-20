#!/usr/bin/env bash

# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

configure_aws_cli(){
	aws --version
	aws configure set default.region us-east-1
	aws configure set default.output json
}

deploy_cluster() {

    family="ferp-travis-docker-task"

    make_task_def
    register_definition
    if [ $(aws ecs update-service --cluster ferp-travis-docker --service ferp-travis-docker-service --task-definition $revision | $JQ '.service.taskDefinition') != $revision ]; then
        echo "Error updating service."
        return 1
    fi

    # wait for older revisions to disappear
    # not really necessary, but nice for demos
    for attempt in {1..30}; do
        if stale=$(aws ecs describe-services --cluster ferp-travis-docker --services ferp-travis-docker-service | \
                       $JQ ".services[0].deployments | .[] | select(.taskDefinition != \"$revision\") | .taskDefinition"); then
            echo "Waiting for stale deployments:"
            echo "$stale"
            sleep 5
        else
            echo "Deployed!"
            return 0
        fi
    done
    echo "Service update took too long."
    return 1
}

make_task_def(){
	task_template='[
		{
			"name": "ferp-travis-docker-task",
			"image": "118755217067.dkr.ecr.us-east-1.amazonaws.com/jso528/ferp-travis-docker:latest",
			"essential": true,
			"memory": 300,
			"cpu": 256,
			"portMappings": [
				{
					"containerPort": 3000,
                    "hostPort": 3000
				}
			]
		}
	]'
	
	task_def=$(printf "$task_template")
}

register_definition() {

    if revision=$(aws ecs register-task-definition --container-definitions "$task_def" --family $family | $JQ '.taskDefinition.taskDefinitionArn'); then
        echo "Revision: $revision"
    else
        echo "Failed to register task definition"
        return 1
    fi

}

configure_aws_cli
deploy_cluster