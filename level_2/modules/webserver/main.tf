resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress  {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.my_ip]
    prefix_list_ids = []
  }

  tags = {
    Name: "${var.env_prefix}-default-sg"
  }
}



data "aws_ami" "latest-amazon-linux-image"{
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
}



resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server"{
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name
  tags = {
    Name: "${var.env_prefix} - instance"
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_location)
  }

  provisioner "file" {
   source = ".env"
   destination = "/home/ec2-user/.env"
  }

  provisioner "file" {
   source = "entry-script.sh"
   destination = "/home/ec2-user/entry-script-ec2.sh"
  }

  provisioner "file" {
   source = "docker-compose.yml"
   destination = "/home/ec2-user/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = ["echo 'hello'"
    ]
    # script = "entry-script-ec2.sh"
  }

  provisioner "local-exec" {   
    command = "echo ${self.public_ip} > output.txt"
  }


  # Blind run, use if available
  user_data = file("entry-script.sh")
}


resource "aws_ebs_volume" "data_vol" {
  availability_zone = var.avail_zone
  size = 20
  type = "gp2"
  # iops = 100
  tags = {
    Name = "database ebs",
    env = "production"
  }
  snapshot_id = "snap-0cf81666aad5afbc2"
}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.data_vol.id
  instance_id = aws_instance.myapp-server.id
}

resource "aws_iam_role" "dlm_lifecycle_role" {
  name = "dlm-lifecycle-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dlm.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dlm_lifecycle" {
  name = "dlm-lifecycle-policy"
  role = aws_iam_role.dlm_lifecycle_role.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
            "ec2:CreateSnapshot",
            "ec2:CreateSnapshots",
            "ec2:DeleteSnapshot",
            "ec2:DescribeInstances",
            "ec2:DescribeVolumes",
            "ec2:DescribeSnapshots"
         ],
         "Resource": "*"
      },
      {
         "Effect": "Allow",
         "Action": [
            "ec2:CreateTags"
         ],
         "Resource": "arn:aws:ec2:*::snapshot/*"
      }
   ]
}
EOF
}

resource "aws_dlm_lifecycle_policy" "database_backup" {
  description        = "Database daily backup policy"
  execution_role_arn = aws_iam_role.dlm_lifecycle_role.arn
  state              = "ENABLED"
  tags = {
      Name = "Daily backup policy "
    }

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "twice a day snapshots"

      create_rule {
        interval      = 12
        interval_unit = "HOURS"
        times         = ["23:45"]
      }

      retain_rule {
        count = 2
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = false
    }

    

    target_tags = {
      env = "production"
    }
  }
}