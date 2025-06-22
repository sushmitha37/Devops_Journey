#!/bin/bash
set -x
###############################################################################
# Author: Sushmitha Mosali
# Version: v1.2
#
# Script to list AWS resources for a service in a region and send via AWS SES email.
#
# Usage: ./aws_resource_list.sh <aws_region> <aws_service>
# Example: ./aws_resource_list.sh ap-south-1 s3
###############################################################################

if [ $# -ne 2 ]; then
    echo "Usage: ./aws_resource_list.sh <aws_region> <aws_service>"
    echo "Example: ./aws_resource_list.sh ap-south-1 s3"
    exit 1
fi

aws_region=$1
aws_service=$2

# Check if AWS CLI installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not installed. Please install it and try again."
    exit 1
fi

# Check if AWS CLI configured
if [ ! -d ~/.aws ]; then
    echo "AWS CLI is not configured. Please run 'aws configure' and try again."
    exit 1
fi

output=""

case $aws_service in
    ec2)
        echo "Listing EC2 Instances in $aws_region"
        output=$(aws ec2 describe-instances --region "$aws_region")
        ;;
    rds)
        echo "Listing RDS Instances in $aws_region"
        output=$(aws rds describe-db-instances --region "$aws_region")
        ;;
    s3)
        echo "Listing S3 Buckets"
        output=$(aws s3api list-buckets)
        ;;
    cloudfront)
        echo "Listing CloudFront Distributions"
        output=$(aws cloudfront list-distributions)
        ;;
    vpc)
        echo "Listing VPCs in $aws_region"
        output=$(aws ec2 describe-vpcs --region "$aws_region")
        ;;
    iam)
        echo "Listing IAM Users"
        output=$(aws iam list-users)
        ;;
    route53)
        echo "Listing Route53 Hosted Zones"
        output=$(aws route53 list-hosted-zones)
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms in $aws_region"
        output=$(aws cloudwatch describe-alarms --region "$aws_region")
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks in $aws_region"
        output=$(aws cloudformation describe-stacks --region "$aws_region")
        ;;
    lambda)
        echo "Listing Lambda Functions in $aws_region"
        output=$(aws lambda list-functions --region "$aws_region")
        ;;
    sns)
        echo "Listing SNS Topics in $aws_region"
        output=$(aws sns list-topics --region "$aws_region")
        ;;
    sqs)
        echo "Listing SQS Queues in $aws_region"
        output=$(aws sqs list-queues --region "$aws_region")
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables in $aws_region"
        output=$(aws dynamodb list-tables --region "$aws_region")
        ;;
    ebs)
        echo "Listing EBS Volumes in $aws_region"
        output=$(aws ec2 describe-volumes --region "$aws_region")
        ;;
    *)
        echo "Invalid service. Please enter a valid service."
        exit 1
        ;;
esac

if [ -z "$output" ]; then
    echo "No resources found for $aws_service in $aws_region."
    output="No resources found for $aws_service in $aws_region."
else
    echo "Resources found for $aws_service in $aws_region."
fi

sender="sushu52581@gmail.com"
recipient="sushu52581@gmail.com"
subject="AWS $aws_service Resources in $aws_region"
body="Below are the AWS $aws_service resources in region $aws_region:\n\n$output"

# Use jq to build JSON safely
email_json=$(jq -n \
  --arg from "$sender" \
  --arg to "$recipient" \
  --arg subj "$subject" \
  --arg body "$body" \
  '{
    Source: $from,
    Destination: { ToAddresses: [$to] },
    Message: {
      Subject: { Data: $subj },
      Body: { Text: { Data: $body } }
    }
  }')

# Send email with AWS CLI using --cli-input-json
aws ses send-email --cli-input-json "$email_json" --region "$aws_region"
status=$?

if [ $status -eq 0 ]; then
    echo "Email sent successfully to $recipient."
else
    echo "Failed to send email."
fi

