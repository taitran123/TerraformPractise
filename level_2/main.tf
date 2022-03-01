terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-buckets-1"
    key = "myapp/state.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]
  public_subnet_tags = {
    Name = "${var.env_prefix}-public-subnet-1"
  }

  private_subnet_tags = {
    Name = "${var.env_prefix}-private-subnet-1"
  }

  

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}


module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip
  env_prefix = var.env_prefix
  image_name = var.image_name
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnets[0]
  avail_zone = var.avail_zone
  private_key_location = var.private_key_location
}

module "myapp-ebs" {
  source = "./modules/ebs"
  aws_instance_id = module.myapp-server.instance_id
  avail_zone = var.avail_zone
  snapshot_id = var.snapshot_id
  target_tag = var.target_tag
}
