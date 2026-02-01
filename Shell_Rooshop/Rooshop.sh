#!/bin/bash

SG_ID="sg-0aa5dff7e9a9bb856"
AMI_ID="ami-0220d79f3f480ecf5"
HOSTED_ZONE_ID="Z014515327I2BWOYLLNUD"



for instance in $@

do
      instance_Id=$( aws ec2 run-instances \
        --image-id $AMI_ID \
        --instance-type t3.micro \
        --security-group-ids $SG_ID \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
        --query 'Instances[0].InstanceId' \
        --output text )

        if [ $instance -eq frontend ]; then

             IP=$(
               aws ec2 describe-instances \
                --instance-ids $instance_Id \
               --query 'Reservations[].Instances[].PublicIpAddress' \
               --output text
             )
        else
            IP=$(
               aws ec2 describe-instances \
                --instance-ids $instance_Id \
               --query 'Reservations[].Instances[].PrivateIpAddress' \
               --output text
             )

        fi

    echo "Ip adress $IP"

done