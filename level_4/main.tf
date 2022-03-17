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

resource "aws_lightsail_instance_public_ports" "k8s" {
  instance_name = aws_lightsail_instance.master_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }

  port_info {
    protocol  = "tcp"
    from_port = 6443
    to_port   = 6443
  }

  port_info {
    protocol  = "tcp"
    from_port = 2379
    to_port   = 2380
  }

  port_info {
    protocol  = "tcp"
    from_port = 10250
    to_port   = 10250
  }

    port_info {
    protocol  = "tcp"
    from_port = 10259
    to_port   = 10259
  }

  port_info {
    protocol  = "tcp"
    from_port = 10257
    to_port   = 10257
  }

    port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 4443
    to_port   = 4443
  }

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }

}


resource "aws_lightsail_instance_public_ports" "k8s-worker-1" {
  instance_name = aws_lightsail_instance.worker_1.name

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }

  port_info {
    protocol  = "tcp"
    from_port = 6443
    to_port   = 6443
  }

  port_info {
    protocol  = "tcp"
    from_port = 2379
    to_port   = 2380
  }

  port_info {
    protocol  = "tcp"
    from_port = 10250
    to_port   = 10250
  }

    port_info {
    protocol  = "tcp"
    from_port = 10259
    to_port   = 10259
  }

  port_info {
    protocol  = "tcp"
    from_port = 10257
    to_port   = 10257
  }
    port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

   port_info {
    protocol  = "tcp"
    from_port = 4443
    to_port   = 4443
  }

   port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }

}

resource "aws_lightsail_instance_public_ports" "k8s-worker-2" {
  instance_name = aws_lightsail_instance.worker_2.name

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }


  port_info {
    protocol  = "tcp"
    from_port = 6443
    to_port   = 6443
  }

  port_info {
    protocol  = "tcp"
    from_port = 2379
    to_port   = 2380
  }

  port_info {
    protocol  = "tcp"
    from_port = 10250
    to_port   = 10250
  }

    port_info {
    protocol  = "tcp"
    from_port = 10259
    to_port   = 10259
  }

  port_info {
    protocol  = "tcp"
    from_port = 10257
    to_port   = 10257
  }

   port_info {
    protocol  = "tcp"
    from_port = 4443
    to_port   = 4443
  }

   port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }
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
  user_data = file("centos8-init-kube.sh")
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
  user_data = file("centos8-init-kube.sh")
}


resource "aws_lightsail_instance" "worker_2" {
  name              = "${var.env_prefix}-work-2_instance"
  availability_zone = var.avail_zone
  key_pair_name     = aws_lightsail_key_pair.thtai_key_pair.name
  bundle_id = var.master_bundle_id
  blueprint_id = var.blueprint_id
  tags = {
    Name = "worker",
    env = var.env_prefix
  }
  user_data = file("centos8-init-kube.sh")
}

