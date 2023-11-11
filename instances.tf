# Demo Ubuntu Server(t2.medium) in Public Subnet
resource "aws_instance" "demo_server" {
  count                  = 1
  ami                    = var.linuxami
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  subnet_id              = element(aws_subnet.public_subnets.*.id, count.index)
  key_name               = var.key_name

  tags = {
    Name = "Belong_Servers"
  }
}

# 2 Instances Of Redhat Servers(t2.micro) in Private Subnet
resource "aws_instance" "private_servers" {
  count                  = 2
  ami                    = var.linuxami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  subnet_id              = element(aws_subnet.private_subnets.*.id, count.index)
  key_name               = var.key_name
  user_data              = file("init_script.sh")

  tags = {
    Name = "Belong_Servers"
  }
}
