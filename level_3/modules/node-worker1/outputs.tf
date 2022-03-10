output "instance" {
    value = aws_instance.worker
}

output "instance_id" {
    value = aws_instance.worker.id
}