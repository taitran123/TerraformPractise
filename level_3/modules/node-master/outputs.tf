output "instance" {
    value = aws_instance.master
}

output "instance_id" {
    value = aws_instance.master.id
}