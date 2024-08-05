#!/bin/bash
set -x
#====== Resize EBS
resize2fs /dev/xvda
resize2fs /dev/xvdcz

#====== Install SSM
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
start amazon-ssm-agent
chkconfig amazon-ssm-agent on

#====== Install AWSLOGS
yum install -y awslogs
mv /etc/awslogs/awslogs.conf /etc/awslogs/awslogs.conf.bkp
aws s3 cp s3://${s3_bucket}/awslogs.conf /etc/awslogs/awslogs.conf
sed -i "s/clustername/${cluster_name}/g" /etc/awslogs/awslogs.conf
sed -i "s/instanceID/`curl -s http://169.254.169.254/latest/meta-data/instance-id`/g" /etc/awslogs/awslogs.conf
service awslogs start
chkconfig awslogs on

echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"cluster_type\":\"web\"} >> /etc/ecs/ecs.config
