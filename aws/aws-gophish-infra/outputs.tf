#output variables for builds
output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
output "ubuntu_instance_public_ip" {
  description = "Public IP address of ubuntu-instance"
  value = aws_instance.dev_server.public_ip
}
