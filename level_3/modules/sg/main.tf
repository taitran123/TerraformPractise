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
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress  {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress  {
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress  {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress  {
    from_port = 10259
    to_port = 10259
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress  {
    from_port = 10257
    to_port = 10257
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