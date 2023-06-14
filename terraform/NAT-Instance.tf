# 데이터(인스턴스에 필요) 블록
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

# NAT 인스턴스 생성(인스턴스는 위 데이터 블록을 참고한다)
resource "aws_instance" "nat_instance" {
  ami           = data.aws_ami.amazon_linux2.image_id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.seoul_pub_sn1.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.seoul_pub_sg.id]
  key_name = ""

  user_data = <<-EOT
  #!/bin/bash
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  sysctl -p /etc/sysctl.conf
  yum install -y iptables-services
  systemctl start iptables.service
  systemctl enable iptables.service
  iptables -F
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  service iptables save
  EOT

  disable_api_termination = true
  source_dest_check = false

  tags = {
    Name = "NAT-Instance"
  }
}

# NAT Instance 생성 후 라우팅 테이블 수정
resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.seoul_pri_rt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
}