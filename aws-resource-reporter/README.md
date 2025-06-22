# AWS Resource Reporter

This script allows you to list AWS resources for a given service and region, then automatically sends the output via email using **AWS Simple Email Service (SES)**.

## 📌 Features

- Lists resources for supported AWS services (EC2, RDS, S3, IAM, Lambda, etc.)
- Sends resource list as an email using AWS SES
- Can be scheduled via **cron job** for periodic reports
- Logs basic status messages for success/failure

## 🧾 Requirements

- AWS CLI installed
- AWS credentials configured (`aws configure`)
- Valid and verified **SES sender and recipient email addresses**
- `jq` installed (used to build JSON email body)

## 📁 Directory Structure

To run this script every day at 9 AM:

crontab -e
Add the line:

0 9 * * * /path/to/aws-resource-reporter/aws_resource_list.sh ap-south-1 s3 
