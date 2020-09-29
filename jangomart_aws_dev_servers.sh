## Provision Servers and Databases

# EC2 Configuration, ec2config.json

{
    "LaunchConfigurationName": "CLItutorial-launchconfig",
    "ImageId": "ami-04243f720af95c9eaeeb2d",
    "SecurityGroups": [
        "sg-abcd1234"
    "InstanceType": "r5.2xlarge",
    ],
    "BlockDeviceMappings": [
        {
            "DeviceName": "/dev/xvdcz",
            "Ebs": {
                "VolumeSize": 1000,
                "VolumeType": "gp2",
                "DeleteOnTermination": true,
                "Encrypted": true
            }
        }
    ],
    "IamInstanceProfile": "arn:aws:iam::111122223333:instance-profile/ecsInstanceRole",
    "AssociatePublicIpAddress": true
}

# Import autoscaling configuration
aws autoscaling create-launch-configuration --cli-input-json file://ec2config.json

# Autoscaling Configuration (simplified), asgconfig.json

{
    "LaunchConfigurationName": "jangomart-dev-compute",
    "MinSize": 3,
    "MaxSize": 10,
    "DesiredCapacity": 3,
    "DefaultCooldown": 300,
    "AvailabilityZones": [
        "us-east-1c",
		"us-east-1d"
    ],
    "VPCZoneIdentifier": $PUBLIC_SUBNET,
}

# Create an Autoscaling Group for the Compute cluster
aws autoscaling create-auto-scaling-group --auto-scaling-group-name jangomart-dev-compute --cli-input-json file://asgconfig.json

# Deploy and Attach an Elastic Load Balancer
aws elbv2 create-load-balancer --name dev-compute-elb  --subnets $PUBLIC_SUBNET --security-groups webServerSecGroup

aws autoscaling attach-load-balancer-target-groups --auto-scaling-group-name jangomart-dev-compute --target-group-arns $COMPUTE_ARNS

# Enable Cloudfront CDN
aws cloudfront create-distribution \
    --origin-domain-name dev.aws.jangomart.com 
	
# Create Oracle RDS instance
aws rds create-db-instance \
    --engine oracle-se1 \
    --db-instance-identifier jangomart-dev-db \
    --allocated-storage 1000 \ 
    --db-instance-class db.m5.2xlarge \
    --db-security-groups dbSecGroup \
    --db-subnet-group $PRIVATE_SUBNET \
    --master-username admin \
    --master-user-password foobar \
    --backup-retention-period 3
	
# Create PostgreSQL RDS instance
aws rds create-db-instance
    --engine postgres \
    --db-instance-identifier jangomart-dev-profile-db \ 
    --allocated-storage 100 \
    --db-instance-class db.t3.large \
    --master-username admin \
    --master-user-password foobar \
    --vpc-security-group-ids dbSecGroup \
    --db-subnet-group $PRIVATE_SUBNET
	
	
	
	

