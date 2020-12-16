#!/bin/bash

ALB_Name=$1

echo "ALB_Name: $ALB_Name"

ALB_ARN=$(aws elbv2 describe-load-balancers --names $ALB_Name --query 'LoadBalancers[0].LoadBalancerArn' --output text)

TG_ARN=$(aws elbv2 describe-target-groups --load-balancer-arn $ALB_ARN --query 'TargetGroups[0].TargetGroupArn' --output text)

aws elbv2 describe-target-health --target-group-arn $TG_ARN --query 'TargetHealthDescriptions[*].Target.Id' --output text
