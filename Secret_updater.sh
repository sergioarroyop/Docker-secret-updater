#!/bin/bash

red () {
	echo -e "\e[31m $1 \e[0m"
}

yellow () {
	echo -e "\e[33m $1 \e[0m"
}

green () {
	echo -e "\e[32m $1 \e[0m"
}

ENV_FILE=$1
SECRET=$2
SERVICE=$3

if [ -z $ENV_FILE ] || [ -z $SECRET ] || [ -z $SERVICE ];
then
	red "- Please provide an env file and a service name -"
	yellow "- Script usage:"
	yellow "- ./Secret_updater.sh </example/file.env> <secret_name> <service_name>"
	exit 1
else	
	
	yellow "- Updating secret $SECRET..."
	docker secret create ${SECRET}_2 $ENV_FILE &> /dev/null && \
	green "+ Created new second secret" || \
	red "- Failed when creating second secret" && exit 1 

	yellow "- Updating $SERVICE with new second secret..."
	docker service update \
	--secret-rm $SECRET \
	--secret-add source=${SECRET}_2,target=$SECRET \
	--detach=false $SERVICE &> /dev/null && \
	green "+ Service updated successfully" || \
	red "- Failed when updating service" && exit 1

	yellow "- Deleting old secret..."
	docker secret rm $SECRET &> /dev/null && \
	green "+ Old secret deleted successfully" || \
	red "- Failed when deleting old secret"

	yellow "- Creating secret $SECRET updated..."
	docker secret create $SECRET $ENV_FILE &> /dev/null && \
	green "+ Secret created successfully" || \
	red "- Failed when creating secret" && exit 1

	yellow "- Updating service $SERVICE with new secret $SECRET..."
	docker service update \
	--secret-rm ${SECRET}_2 \
	--secret-add source=$SECRET,target=$SECRET \
	--detach=false $SERVICE &> /dev/null && \
	green "+ Service updated successfully" || \
	red "- Failed when updating service" && exit 1
	
	yellow "- Deleting second secret"
	docker secret rm ${SECRET}_2 &> /dev/null && \
	green "+ Second secret deleted successfully" || \
	red "- Failed when deleting second secret" && exit 1
	
	green "+ Secret updated successfully"
fi
