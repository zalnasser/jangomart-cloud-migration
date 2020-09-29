### JangoMart AWS Dev Environment


## Provision a new account using AWS organizations

# Assume we have an existing AWS account for billing purposes
aws organizations create-account --email "dev.aws.admin@jangomart.com" --account-name "dev.admin" --role-name AdminRole

# Assume the new role
aws sts assume-role --role-arn AdminRole --role-session-name devadminsession


## Create a VPC with 3 subnets

# Returns $VPC_ID
aws ec2 create-vpc --cidr-block 10.32.0.0/16			
# Create a Management subnet
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.32.0.0/20
# Create a Private subnet for Databases
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.32.64.0/20
# Create a Public subnet for Web Servers
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.32.64.0/20

# Create an internet gateway to allow access to the Public subnet; Returns $IGW_ID
aws ec2 create-internet-gateway
# Attach the IGW to the subnet
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
# Create a route table; Returns $RTB_ID
aws ec2 create-route-table --vpc-id $VPC_ID
# Create a route to the internet
aws ec2 create-route --route-table-id $RTB_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
# List subnets
aws ec2 describe-subnets --filters "Name=vpc-id,Values=\$VPC_ID" --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock}'
# Associate the route table with the Public subnet
aws ec2 associate-route-table  --subnet-id $SUBNET_ID --route-table-id $RTB_ID



