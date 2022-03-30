terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "dev-terraform-buckets-1"
    key = "myapp/state.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


resource "aws_lightsail_key_pair" "thtai_key_pair" {
  name = "thtainopass"
  public_key = file(var.public_key_location)
}


module aws_lightsail_firewall_master {
  source = "./modules/firewalls"
  instance_name = aws_lightsail_instance.master_instance.name
}

module aws_lightsail_firewall_worker1 {
  source = "./modules/firewalls"
  instance_name = aws_lightsail_instance.worker_1.name
}

module aws_lightsail_firewall_worker2 {
  source = "./modules/firewalls"
  instance_name = aws_lightsail_instance.worker_2.name
}

resource "aws_lightsail_instance" "master_instance" {
  name              = "${var.env_prefix}-master_instance"
  availability_zone = var.avail_zone
  key_pair_name     = aws_lightsail_key_pair.thtai_key_pair.name
  bundle_id = var.master_bundle_id
  blueprint_id = var.blueprint_id
  tags = {
    Name = "master",
    env = var.env_prefix
  }
  user_data = file(var.entry_file)
}

resource "aws_lightsail_instance" "worker_1" {
  name              = "${var.env_prefix}-work-1_instance"
  availability_zone = var.avail_zone
  key_pair_name     = aws_lightsail_key_pair.thtai_key_pair.name
  bundle_id = var.node_bundle_id
  blueprint_id = var.blueprint_id
  tags = {
    Name = "worker",
    env = var.env_prefix
  }
  user_data = file(var.entry_file)
}


resource "aws_lightsail_instance" "worker_2" {
  name              = "${var.env_prefix}-work-2_instance"
  availability_zone = var.avail_zone
  key_pair_name     = aws_lightsail_key_pair.thtai_key_pair.name
  bundle_id = var.node_bundle_id
  blueprint_id = var.blueprint_id
  tags = {
    Name = "worker",
    env = var.env_prefix
  }
  user_data = file(var.entry_file)
}

