terraform {
  backend "s3" {
    bucket = "terraback"
    key = "terra.tfstate"
    region = "ap-south-1"
    dynamodb_table = "LockTable"
  }
}
data "local_file" "user_data_file" {
  filename = var.user_data_filename
}

data "local_file" "policy_file" {
  filename = var.role_policy_filename
}

module "ec2" {
  source = "./modules/ec2/"
  ami_id = var.ami_id
  sg_ingress = var.sg_ingress
  user_data = data.local_file.user_data_file.content
  ec2_role_policy = data.local_file.policy_file.content
}
