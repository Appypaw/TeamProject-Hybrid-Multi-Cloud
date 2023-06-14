# Seoul 데이터(인스턴스에 필요) 블록
data "aws_ami" "amazon_linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

# Seoul 베스천 인스턴스 생성(인스턴스는 위 데이터 블록을 참고한다)
resource "aws_instance" "bastion_instance" {
  ami           = data.aws_ami.amazon_linux2.image_id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.seoul_pub_sn1.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.seoul_pub_sg.id]
  key_name = ""

  user_data = <<-EOT
  #!/bin/bash
  echo "p@ssw0rd" | passwd --stdin root
  sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
  service sshd restart
  EOT

  tags = {
    Name = "Bastion-Instance"
  }
}

# Singapore 데이터(인스턴스에 필요) 블록
data "aws_ami" "amazon_linux22" {
  provider   = aws.singapore
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

# Singapore 베스천 인스턴스 생성(인스턴스는 위 데이터 블록을 참고한다)
resource "aws_instance" "bastion_instance2" {
  provider   = aws.singapore
  ami           = data.aws_ami.amazon_linux22.image_id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.singapore_pub_sn1.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.singapore_pub_sg.id]
  key_name = ""

  user_data = <<-EOT
  #!/bin/bash
  echo "p@ssw0rd" | passwd --stdin root
  sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
  service sshd restart
  EOT

  tags = {
    Name = "Bastion-Instance"
  }
}