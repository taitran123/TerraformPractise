resource "aws_lightsail_instance_public_ports" "k8s-worker-1" {
  instance_name = var.instance_name

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
    to_port   = 10259
  }

    port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

   port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }
}