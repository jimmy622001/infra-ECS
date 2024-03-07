#!/bin/bash

################################################################################
# Configure cluster name
################################################################################
echo ECS_CLUSTER='${ecs_cluster_name}' >> /etc/ecs/ecs.config

################################################################################
# Install packages
################################################################################

yum -y install python-pip

################################################################################
# Install AWS CLI
################################################################################

pip install --upgrade pip
pip install awscli
pip install awscli --upgrade

################################################################################
# Install CloudWatch agent
#
# Problem solving or setting up a new agent:
# 1. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file-wizard.html
#    for single steps for creating the configuration file
# 2. On the EC2 instance, run `sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status`
#    to check if the agent is running if you don't see any logs
# 3. Check `/var/log/amazon/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log` for log output of the CloudWatch agent
################################################################################

aws ssm --region eu-central-1 get-parameters --names ${environment}.cloudwatch-agent-config.json --with-decryption --output text --query Parameters[0].Value > /etc/amazon-cloudwatch-agent.json
curl https://s3.amazonaws.com/amazoncloudwatch-agent/centos/amd64/latest/amazon-cloudwatch-agent.rpm --output cloudwatch-agent.rpm
rpm -U ./cloudwatch-agent.rpm
rm -rf cloudwatch-agent.rpm

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/etc/amazon-cloudwatch-agent.json -s
