#!/bin/bash
AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-06298c18e86c57b2e"
ZoneId="Z018042118DWYK39M0YVT"
DomainName="darlavinaykumar.fun"
for instance in $@
do
    echo "Creating $instance instance"
    InstanceID=$(aws ec2 run-instances --image-id "ami-0220d79f3f480ecf5" --instance-type t3.micro --security-group-ids "sg-06298c18e86c57b2e" --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)
    echo "Instance created with ID: $InstanceID"

    if [ "$instance" != "Frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids $InstanceID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
        echo "Private IP of $instance instance: $IP"
        RecordName="$instance.$DomainName"
    else
        IP=$(aws ec2 describe-instances --instance-ids $InstanceID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
        echo "Public IP of $instance instance: $IP"
        RecordName="$DomainName"

    fi
    aws route53 change-resource-record-sets\
    --hosted-zone-id $ZoneId \
    --change-batch '
    {
    "Comment": "Added record for '$instance'",
    "Changes": [{
    "Action"                  :"UPSERT",
    "ResourceRecordSet"       :{
    "Name"                    :"'$RecordName'",
    "Type"                    :"A",
    "TTL"                     :1,
    "ResourceRecords"         :[{
    "Value"                   :"'$IP'"
    }]
    }
    }]}'
done