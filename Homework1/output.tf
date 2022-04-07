
output "server" {
  value = aws_instance.consul_server.*.public_ip
}


output "webserver" {
  value = aws_instance.consul_webserver.public_ip
}
 