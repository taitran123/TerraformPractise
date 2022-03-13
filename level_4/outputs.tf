output "master-node_public_ip" {
  value = aws_lightsail_instance.master_instance.public_ip_address
}

output "master-node_private_ip" {
  value = aws_lightsail_instance.master_instance.private_ip_address
}

output "master-node_username" {
  value = aws_lightsail_instance.master_instance.username
}

output "worker_1_public_ip" {
  value = aws_lightsail_instance.worker_1.public_ip_address
}

output "worker_1_private_ip" {
  value = aws_lightsail_instance.worker_1.private_ip_address
}

output "worker_1_username" {
  value = aws_lightsail_instance.worker_1.username
}

output "worker_2_public_ip" {
  value = aws_lightsail_instance.worker_2.public_ip_address
}

output "worker_2_private_ip" {
  value = aws_lightsail_instance.worker_2.private_ip_address
}

output "worker_2_username" {
  value = aws_lightsail_instance.worker_2.username
}