terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "ap-northeast-2"
  # access_key = ""
  # secret_key = ""
}

# Seoul-VPC 생성
resource "aws_vpc" "seoul_vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Seoul-VPC"
  }
}

# Seoul-Pub-SN1 생성
resource "aws_subnet" "seoul_pub_sn1" {
  vpc_id     = aws_vpc.seoul_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Seoul-Pub-SN1"
  }
}

# Seoul-Pub-SN2 생성
resource "aws_subnet" "seoul_pub_sn2" {
  vpc_id     = aws_vpc.seoul_vpc.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Seoul-Pub-SN2"
  }
}

# Seoul-Pri-SN3 생성
resource "aws_subnet" "seoul_pri_sn3" {
  vpc_id     = aws_vpc.seoul_vpc.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Seoul-Pri-SN3"
  }
}

# Seoul-Pri-SN4 생성
resource "aws_subnet" "seoul_pri_sn4" {
  vpc_id     = aws_vpc.seoul_vpc.id
  cidr_block = "10.1.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "Seoul-Pri-SN4"
  }
}

# Seoul-DB-SN5 생성
resource "aws_subnet" "seoul_db_sn5" {
  vpc_id     = aws_vpc.seoul_vpc.id
  cidr_block = "10.1.5.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Seoul-DB-SN5"
  }
}

# Seoul-DB-SN6 생성
resource "aws_subnet" "seoul_db_sn6" {
  vpc_id     = aws_vpc.seoul_vpc.id
  cidr_block = "10.1.6.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "Seoul-DB-SN6"
  }
}

# Seoul-IGW 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "seoul_igw" {
  vpc_id = aws_vpc.seoul_vpc.id

  tags = {
    Name = "Seoul-IGW"
  }
}

# Seoul-Pub-RT 라우팅 테이블 생성
resource "aws_route_table" "seoul_pub_rt" {
  vpc_id = aws_vpc.seoul_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.seoul_igw.id
  }

  tags = {
    Name = "Seoul-Pub-RT"
  }
}

# Seoul-Pub-RT 퍼블릭 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "seoul_pub_rt_association1" {
  subnet_id      = aws_subnet.seoul_pub_sn1.id
  route_table_id = aws_route_table.seoul_pub_rt.id
}

# Seoul-Pub-RT 퍼블릭 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "seoul_pub_rt_association2" {
  subnet_id      = aws_subnet.seoul_pub_sn2.id
  route_table_id = aws_route_table.seoul_pub_rt.id
}

# Seoul-Pri-RT 라우팅 테이블 생성
resource "aws_route_table" "seoul_pri_rt" {
  vpc_id = aws_vpc.seoul_vpc.id

  tags = {
    Name = "Seoul-Pri-RT"
  }
}

# Seoul-Pri-RT 프라이빗 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "seoul_pri_rt_association3" {
  subnet_id      = aws_subnet.seoul_pri_sn3.id
  route_table_id = aws_route_table.seoul_pri_rt.id
}

# Seoul-Pri-RT 프라이빗 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "seoul_pri_rt_association4" {
  subnet_id      = aws_subnet.seoul_pri_sn4.id
  route_table_id = aws_route_table.seoul_pri_rt.id
}

# Seoul-DB-RT 라우팅 테이블 생성
resource "aws_route_table" "seoul_db_rt" {
  vpc_id = aws_vpc.seoul_vpc.id

  tags = {
    Name = "Seoul-DB-RT"
  }
}

# Seoul-DB-RT 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "seoul_db_rt_association5" {
  subnet_id      = aws_subnet.seoul_db_sn5.id
  route_table_id = aws_route_table.seoul_db_rt.id
}

# Seoul-DB-RT 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "seoul_db_rt_association6" {
  subnet_id      = aws_subnet.seoul_db_sn6.id
  route_table_id = aws_route_table.seoul_db_rt.id
}

# Seoul-Pub-SG 보안 그룹 생성(name이 보안 그룹 이름, tags가 Name으로 들어간다)
resource "aws_security_group" "seoul_pub_sg" {
  name        = "Seoul-Pub-SG"
  description = "Seoul-Pub-SG"
  vpc_id      = aws_vpc.seoul_vpc.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "aurora/db"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.1.3.0/24"]
  }

  ingress {
    description      = "aurora/db"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.1.4.0/24"]
  }

  ingress {
    description      = "4500"
    from_port        = 4500
    to_port          = 4500
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Seoul-Pub-SG"
  }
}

# Seoul-Pri-SG 보안 그룹 생성
resource "aws_security_group" "seoul_pri_sg" {
  name        = "Seoul-Pri-SG"
  description = "Seoul-Pri-SG"
  vpc_id      = aws_vpc.seoul_vpc.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "efs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "aurora/db"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Seoul-Pri-SG"
  }
}

# Seoul-ALB-SG 보안 그룹 생성
resource "aws_security_group" "seoul_alb_sg" {
  name        = "Seoul-ALB-SG"
  description = "Seoul-ALB-SG"
  vpc_id      = aws_vpc.seoul_vpc.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "3000"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Seoul-ALB-SG"
  }
}

# Seoul-DB-SG 보안 그룹 생성
resource "aws_security_group" "seoul_db_sg" {
  name        = "Seoul-DB-SG"
  description = "Seoul-DB-SG"
  vpc_id      = aws_vpc.seoul_vpc.id

  ingress {
    description      = "aurora/db"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.1.3.0/24"]
  }

  ingress {
    description      = "aurora/db"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.1.4.0/24"]
  }

  ingress {
    description      = "aurora/db"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.2.1.0/24"]
  }

  ingress {
    description      = "aurora/db"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["172.16.3.0/24"]
  }

  ingress {
    description      = "aurora/db"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["172.16.4.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Seoul-DB-SG"
  }
}

# Seoul-EFS-SG 보안 그룹 생성
resource "aws_security_group" "seoul_efs_sg" {
  name        = "Seoul-EFS-SG"
  description = "Seoul-EFS-SG"
  vpc_id      = aws_vpc.seoul_vpc.id

  ingress {
    description      = "efs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["10.1.0.0/16"]
  }

  ingress {
    description      = "efs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["172.16.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Seoul-EFS-SG"
  }
}

# Seoul-ST-SG 생성
resource "aws_security_group" "seoul_st_sg" {
  name        = "Seoul-ST-SG"
  description = "Seoul-ST-SG"
  vpc_id      = aws_vpc.seoul_vpc.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "nfs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["172.16.0.0/16"]
  }
  
  ingress {
    description      = "nfs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["10.1.0.0/16"]
  }

  ingress {
    description      = "nfs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "udp"
    cidr_blocks      = ["10.1.0.0/16"]
  }

  ingress {
    description      = "nfs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "udp"
    cidr_blocks      = ["172.16.0.0/16"]
  }

  ingress {
    description      = "smb"
    from_port        = 445
    to_port          = 445
    protocol         = "tcp"
    cidr_blocks      = ["10.1.0.0/16"]
  }

  ingress {
    description      = "smb"
    from_port        = 445
    to_port          = 445
    protocol         = "tcp"
    cidr_blocks      = ["172.16.0.0/16"]
  }

  ingress {
    description      = "smb"
    from_port        = 445
    to_port          = 445
    protocol         = "udp"
    cidr_blocks      = ["10.1.0.0/16"]
  }

  ingress {
    description      = "smb"
    from_port        = 445
    to_port          = 445
    protocol         = "udp"
    cidr_blocks      = ["172.16.0.0/16"]
  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Seoul-ST-SG"
  }
}

# Seoul-EIP 탄력적 ip 생성
resource "aws_eip" "seoul_eip" {
  vpc      = true

  tags = {
    Name = "Seoul-EIP"
  }
}

# Seoul-NAT-Gateway 나트 게이트웨이 생성
resource "aws_nat_gateway" "seoul_nat_gateway" {
  allocation_id = aws_eip.seoul_eip.id
  subnet_id     = aws_subnet.seoul_pub_sn2.id

  tags = {
    Name = "Seoul-NAT-Gateway"
  }
}

# Seoul-Pri-RT 프라이빗 라우팅 테이블과 NAT-Gateway 연결
resource "aws_route" "seoul_pri_rt_route" {
  route_table_id         = aws_route_table.seoul_pri_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.seoul_nat_gateway.id
}