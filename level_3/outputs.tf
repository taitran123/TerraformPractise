output "master-node_public_ip" {
  value = module.master-node.instance.public_ip
}

output "master-node_private_ip" {
  value = module.master-node.instance.private_ip
}

output "worker-node-1_public_ip" {
  value = module.worker-node-1.instance.public_ip
}

output "worker-node-1_private_ip" {
  value = module.worker-node-1.instance.private_ip
}


output "worker-node-2_public_ip" {
  value = module.worker-node-2.instance.public_ip
}

output "worker-node-2_private_ip" {
  value = module.worker-node-2.instance.private_ip
}
