data "aws_ami" "latest-amazon-linux-image"{
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
}




resource "aws_instance" "master"{
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  availability_zone = var.avail_zone
  private_ip = var.private_ip
  associate_public_ip_address = true
  key_name = var.key_name
  tags = {
    Name: "${var.env_prefix} - instance"
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_location)
  }

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname k8smaster",
    ]
  }


  provisioner "local-exec" {   
    command = "echo ${self.public_ip} > output.txt"
  }


  # Blind run, use if available
  user_data = file("initilize-kube.sh")
}
