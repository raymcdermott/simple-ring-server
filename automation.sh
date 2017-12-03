#!/usr/bin/env bash

set -ex

export aws_region=$(aws configure get region)
export TF_VAR_environment=$2

IMAGE_NAME=static-file-server
SHA=$(git rev-parse --short HEAD)
IMAGE_VERSION=$(echo $(git rev-parse --abbrev-ref HEAD) | tr / _)-${SHA}
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
IMAGE_REPO=${AWS_ACCOUNT_ID}.dkr.ecr.${aws_region}.amazonaws.com/${IMAGE_NAME}

case "$1" in

    provision)
        echo terraform apply -var-file=./envs/${TF_VAR_environment}.tfvars
        ;;

    destroy)
        echo terraform destroy -var-file=./envs/${TF_VAR_environment}.tfvars
        ;;

    build)
        docker build -t $IMAGE_REPO:$IMAGE_VERSION .
        ;;

    publish)
        VERSIONED_API=$IMAGE_NAME-$IMAGE_VERSION

        $(aws ecr get-login --no-include-email)
        docker push $IMAGE_REPO:$IMAGE_VERSION
        rm -f /tmp/${VERSIONED_API}.zip
#        zip -r -j /tmp/${VERSIONED_API}.zip /tmp/Dockerrun.aws.json
#        aws s3 cp /tmp/${VERSIONED_API}.zip s3://artefacts.crocubot.io/$IMAGE_NAME/$VERSIONED_API.zip

        ;;

    deploy)
#        aws elasticbeanstalk update-environment --environment-name vouch-api-${TF_VAR_environment} --version-label $IMAGE_VERSION
        ;;


    *)  echo 'not a valid target'
        exit 1
        ;;
esac
