#!/bin/bash

SG_ID="sg-0aa5dff7e9a9bb856"
AMI_ID="ami-0220d79f3f480ecf5"
HOSTED_ZONE_ID="Z014515327I2BWOYLLNUD"
DOMAIN_NAME="chittis.online"



for instance in $@

TAG_NAME=$instance

EXISTING_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$TAG_NAME" "Name=instance-state-name,Values=running,pending" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

if [ -n "$EXISTING_ID" ]; then
    echo "Error: An instance with the name '$TAG_NAME' already exists (ID: $EXISTING_ID)."
    exit 1
fi

echo "Name is unique. Launching instance..."


do
      instance_Id=$( aws ec2 run-instances \
        --image-id $AMI_ID \
        --instance-type t3.micro \
        --security-group-ids $SG_ID \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
        --query 'Instances[0].InstanceId' \
        --output text )

        if [ $instance == "frontend" ]; then

             IP=$(
               aws ec2 describe-instances \
                --instance-ids $instance_Id \
               --query 'Reservations[].Instances[].PublicIpAddress' \
               --output text
             )

             RECORD_NAME=$DOMAIN_NAME
        else
            IP=$(
               aws ec2 describe-instances \
                --instance-ids $instance_Id \
               --query 'Reservations[].Instances[].PrivateIpAddress' \
               --output text
             )

             RECORD_NAME=$instance.$DOMAIN_NAME

        fi

    echo "Ip adress $IP"


    aws route53 change-resource-record-sets \
     --hosted-zone-id $HOSTED_ZONE_ID \
     --change-batch '
     {
        "Comment": "Update A record ",
        "Changes": [
            {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                   "Name": "'$RECORD_NAME'",
                   "Type": "A",
                   "TTL": 1,
                  "ResourceRecords": [{ "Value": "'$IP'" }]
              }
            }
         ]
     }
     '
            echo "record updated for $instance"
done