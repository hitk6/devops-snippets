# tf cmds
terraform init -backend-file=./backnd/dev.hcl
terraform plan -var-file ./vars/dev.tfvars
terraform apply -var-file ./vars/DEV.tfvars --auto-approve 
terraform destroy -var-file ./vars/DEV.tfvars --auto-approve 


# Configure terraform privider on EC2 and Cloud9 using IAM role credentials (terraform will use the creds of iam role attached to ec2 or cloud9)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs#ec2-instance-metadata-service
role_name=$( curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/ )
data="$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${role_name})"

# 1 Cloud9, Export Iam Creds
export AWS_ACCESS_KEY_ID="$(echo ${data} | jq -r .AccessKeyId)"
export AWS_SECRET_ACCESS_KEY="$(echo ${data} | jq -r .SecretAccessKey)"
export AWS_SESSION_TOKEN="$(echo ${data} | jq -r .Token)"

# now tf will work normally

# More features
# 2
export AWS_DEFAULT_REGION=eu-west-1
export AWS_PROFILE="default"

# 3
export AWS_SHARED_CREDENTIALS_FILE="/Users/tf_user/.aws/creds"

# EC2
AWS_METADATA_URL defaults to http://169.254.169.254:80/latest

# FOR CodeBuild, ECS, and EKS 
creds="$(${AWS_CONTAINER_CREDENTIALS_RELATIVE_URI}/path/)"
creds="$(${AWS_CONTAINER_CREDENTIALS_FULL_URI}/path/)"

# EKS
If you're running Terraform on EKS and have configured IAM Roles for Service Accounts (IRSA), 
Terraform will use the pod's role. This support is based on the underlying AWS_ROLE_ARN
and AWS_WEB_IDENTITY_TOKEN_FILE environment variables being automatically set by 
Kubernetes or manually for advanced usage.
https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

# Assume other iam role for terraform deployment
Assume Role
If provided with a role ARN, Terraform will attempt to assume this role using the supplied credentials.

Usage:

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
    session_name = "SESSION_NAME"
    external_id  = "EXTERNAL_ID"
  }
}