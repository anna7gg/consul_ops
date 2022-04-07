
resource "aws_instance" "consul_server" {
  count = 3
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.annaops_consul_key.key_name
  subnet_id                   = aws_subnet.public.id
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.consul_security_group.id]
  user_data            = local.consul_server-userdata  

  tags = {
    Name = "annaops-server"
    consul_server = "true"
  }

}

resource "aws_instance" "consul_webserver" {

  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.annaops_consul_key.key_name
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name
  vpc_security_group_ids = [aws_security_group.consul_security_group.id]
  user_data            = local.consul_agent-userdata  
  tags = {
    Name = "annaops-agent"
  }

}

#Security Group

resource "aws_security_group" "consul_security_group" {
      name = "consul_security_group"
      vpc_id = aws_vpc.consul_vpc.id
      tags = {
          Name = "consul_security_group"
      }
}

resource "aws_security_group_rule" "consul_http_acess" {
    description       = "allow http access from anywhere"
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.consul_security_group.id
    to_port           = 80
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "consul_ssh_acess" {
    description       = "allow ssh access from anywhere"
    from_port         = 22
    protocol          = "tcp"
    security_group_id = aws_security_group.consul_security_group.id
    to_port           = 22
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "consul_ui_acess" {
    description       = "Allow consul UI access from the world"
    from_port         = 8500
    protocol          = "tcp"
    security_group_id = aws_security_group.consul_security_group.id
    to_port           = 8500
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "consul_inside_all" {
    description       = "Allow all inside security group"
    from_port         = 0
    protocol           = "-1"
    security_group_id = aws_security_group.consul_security_group.id
    to_port           = 0
    type              = "ingress"
    self              = true
}

resource "aws_security_group_rule" "consul_outbound_anywhere" {
    description       = "allow outbound traffic to anywhere"
    from_port         = 0
    protocol           = "-1"
    security_group_id = aws_security_group.consul_security_group.id
    to_port           = 0
    type              = "egress"
    cidr_blocks       = ["0.0.0.0/0"]
}

