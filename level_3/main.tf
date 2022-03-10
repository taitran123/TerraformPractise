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

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  env_prefix = var.env_prefix
  my_ip = var.my_ip
}

module "ssh-key" {
  source = "./modules/ssh-key"
  public_key_location = var.public_key_location
}


module "master-node" {
  source = "./modules/node-master"
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip
  env_prefix = var.master_prefix
  image_name = var.image_name
  key_name = module.ssh-key.key-name
  instance_type = var.instance_type_master
  subnet_id = module.vpc.public_subnets[0]
  avail_zone = var.avail_zone
  private_key_location = var.private_key_location
  sg_id = module.sg.sg-id
  private_ip = var.master_private_ip
}

module "worker-node-1" {
  source = "./modules/node-worker1"
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip
  env_prefix = var.worker_prefix
  image_name = var.image_name
  key_name = module.ssh-key.key-name
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnets[0]
  avail_zone = var.avail_zone
  private_key_location = var.private_key_location
  sg_id = module.sg.sg-id
  private_ip = var.worker_1_private_ip
}


module "worker-node-2" {
  source = "./modules/node-worker2"
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip
  env_prefix = var.worker_prefix
  image_name = var.image_name
  key_name = module.ssh-key.key-name
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnets[0]
  avail_zone = var.avail_zone
  private_key_location = var.private_key_location
  sg_id = module.sg.sg-id
  private_ip = var.worker_2_private_ip
}
