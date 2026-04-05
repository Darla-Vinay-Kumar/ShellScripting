#!/bin/bash
# Script to launch a new EC2 instance and display its details

AMI_ID="ami-0220d79f3f480ecf5"  # Update with your AMI ID
INSTANCE_TYPE="t3.micro"        # Update as needed
SG_ID="sg-06298c18e86c57b2e"   # Update with your Security Group ID
KEY_NAME="your-key-name"        # Update with your Key Pair name
INSTANCE_NAME="MyInstance"      # Update as needed
REGION="us-east-1"              # Update with your region

# Launch the instance
InstanceID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --security-group-ids "$SG_ID" \
  --region "$REGION" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Instance created with ID: $InstanceID"

# Wait for the instance to be running
aws ec2 wait instance-running --instance-ids "$InstanceID" --region "$REGION"

echo "Instance is now running."

# Get the public IP address
PublicIP=$(aws ec2 describe-instances \
  --instance-ids "$InstanceID" \
  --region "$REGION" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "Public IP of the instance: $PublicIP"
