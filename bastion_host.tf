# Bastion Host
resource "aws_instance" "bastion_host" {
  ami                    = "ami-03c3351e3ce9d04eb"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  tags = { Name = "bastion-host" }
}