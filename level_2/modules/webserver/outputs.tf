output "instance" {
    value = aws_instance.myapp-server
}

output "instance_id" {
    value = aws_instance.myapp-server.id
}