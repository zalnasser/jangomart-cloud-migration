### JangoMart AWS Dev Environment


## Provision a new account using AWS organizations

# Assume we have an existing AWS account for billing purposes
aws organizations create-account --email "dev.aws.admin@jangomart.com" --account-name "dev.admin" --role-name AdminRole

# Assume the new role
aws sts assume-role --role-arn AdminRole --role-session-name devadminsession


## Create a VPC

# Returns $VPC_ID
aws ec2 create-vpc --cidr-block 10.32.0.0/16			
# Create a Management subnet
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.32.0.0/20
# Create a Private subnet for Databases
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.32.64.0/20
# Create a Public subnet for Web Servers
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.32.64.0/20