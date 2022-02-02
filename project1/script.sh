#!/bin/bash

IP=$(aws ec2 describe-instances --region ap-southeast-1 --query 'Reservations[*].Instances[*].PublicIpAddress' --filters Name=tag:Name,Values=Deploy --output text)

if ! [ -z $IP ];
then
    ssh -i ~/.ssh/sg-key.pem ubuntu@$IP bash < replace-container.sh
else
    ansible-playbook pb1.yaml
    ansible-playbook -i host pb2.yaml --private-key ~/.ssh/sg-key.pem
fi
