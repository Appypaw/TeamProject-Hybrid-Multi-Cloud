# 싱가포르 프로바이더 선언
provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}

# Singapore-VPC 생성
resource "aws_vpc" "singapore_vpc" {
  provider   = aws.singapore
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Singapore-VPC"
  }
}

# Singapore-Pub-SN1 생성
resource "aws_subnet" "singapore_pub_sn1" {
  provider   = aws.singapore
  vpc_id     = aws_vpc.singapore_vpc.id
  cidr_block = "172.16.1.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Singapore-Pub-SN1"
  }
}

# Singapore-Pub-SN2 생성
resource "aws_subnet" "singapore_pub_sn2" {
  provider   = aws.singapore
  vpc_id     = aws_vpc.singapore_vpc.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "ap-southeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Singapore-Pub-SN2"
  }
}

# Singapore-Pri-SN3 생성
resource "aws_subnet" "singapore_pri_sn3" {
  provider   = aws.singapore
  vpc_id     = aws_vpc.singapore_vpc.id
  cidr_block = "172.16.3.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Singapore-Pri-SN3"
  }
}

# Singapore-Pri-SN4 생성
resource "aws_subnet" "singapore_pri_sn4" {
  provider   = aws.singapore
  vpc_id     = aws_vpc.singapore_vpc.id
  cidr_block = "172.16.4.0/24"
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "Singapore-Pri-SN4"
  }
}

# Singapore-DB-SN5 생성
resource "aws_subnet" "singapore_db_sn5" {
  provider   = aws.singapore
  vpc_id     = aws_vpc.singapore_vpc.id
  cidr_block = "172.16.5.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Singapore-DB-SN5"
  }
}

# Singapore-DB-SN6 생성
resource "aws_subnet" "singapore_db_sn6" {
  provider   = aws.singapore
  vpc_id     = aws_vpc.singapore_vpc.id
  cidr_block = "172.16.6.0/24"
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "Singapore-DB-SN6"
  }
}

# Singapore-IGW 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "singapore_igw" {
  provider   = aws.singapore
  vpc_id = aws_vpc.singapore_vpc.id

  tags = {
    Name = "Singapore-IGW"
  }
}

# Singapore-Pub-RT 라우팅 테이블 생성
resource "aws_route_table" "singapore_pub_rt" {
  provider   = aws.singapore
  vpc_id = aws_vpc.singapore_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.singapore_igw.id
  }

  tags = {
    Name = "Singapore-Pub-RT"
  }
}

# Singapore-Pub-RT 퍼블릭 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "singapore_pub_rt_association1" {
  provider   = aws.singapore
  subnet_id      = aws_subnet.singapore_pub_sn1.id
  route_table_id = aws_route_table.singapore_pub_rt.id
}

# Singapore-Pub-RT 퍼블릭 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "singapore_pub_rt_association2" {
  provider   = aws.singapore
  subnet_id      = aws_subnet.singapore_pub_sn2.id
  route_table_id = aws_route_table.singapore_pub_rt.id
}

# Singapore-Pri-RT 라우팅 테이블 생성(id는 리소스 참고)
resource "aws_route_table" "singapore_pri_rt" {
  provider   = aws.singapore
  vpc_id = aws_vpc.singapore_vpc.id

  tags = {
    Name = "Singapore-Pri-RT"
  }
}

# Singapore-Pri-RT 프라이빗 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "singapore_pri_rt_association3" {
  provider   = aws.singapore
  subnet_id      = aws_subnet.singapore_pri_sn3.id
  route_table_id = aws_route_table.singapore_pri_rt.id
}

# Singapore-Pri-RT 프라이빗 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "singapore_pri_rt_association4" {
  provider   = aws.singapore
  subnet_id      = aws_subnet.singapore_pri_sn4.id
  route_table_id = aws_route_table.singapore_pri_rt.id
}

# Singapore-DB-RT 라우팅 테이블 생성(id는 리소스 참고)
resource "aws_route_table" "singapore_db_rt" {
  provider   = aws.singapore
  vpc_id = aws_vpc.singapore_vpc.id

  tags = {
    Name = "Singapore-DB-RT"
  }
}

# Singapore-DB-RT 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "singapore_db_rt_association5" {
  provider   = aws.singapore
  subnet_id      = aws_subnet.singapore_db_sn5.id
  route_table_id = aws_route_table.singapore_db_rt.id
}

# Singapore-DB-RT 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "singapore_db_rt_association6" {
  provider   = aws.singapore
  subnet_id      = aws_subnet.singapore_db_sn6.id
  route_table_id = aws_route_table.singapore_db_rt.id
}

# Singapore-Pub-SG 보안 그룹 생성
resource "aws_security_group" "singapore_pub_sg" {
  provider   = aws.singapore
  name        = "Singapore-Pub-SG"
  description = "Singapore-Pub-SG"
  vpc_id      = aws_vpc.singapore_vpc.id

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
    Name = "Singapore-Pub-SG"
  }
}

# Singapore-Pri-SG 보안 그룹 생성
resource "aws_security_group" "singapore_pri_sg" {
  provider   = aws.singapore
  name        = "Singapore-Pri-SG"
  description = "Singapore-Pri-SG"
  vpc_id      = aws_vpc.singapore_vpc.id

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
    Name = "Singapore-Pri-SG"
  }
}

# Singapore-ALB-SG 보안 그룹 생성
resource "aws_security_group" "singapore_alb_sg" {
  provider   = aws.singapore
  name        = "Singapore-ALB-SG"
  description = "Singapore-ALB-SG"
  vpc_id      = aws_vpc.singapore_vpc.id

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
    Name = "Singapore-ALB-SG"
  }
}

# Singapore-DB-SG 보안 그룹 생성
resource "aws_security_group" "singapore_db_sg" {
  provider   = aws.singapore
  name        = "Singapore-DB-SG"
  description = "Singapore-DB-SG"
  vpc_id      = aws_vpc.singapore_vpc.id

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
    Name = "Singapore-DB-SG"
  }
}

# Singapore-EFS-SG 보안 그룹 생성
resource "aws_security_group" "singapore_efs_sg" {
  provider   = aws.singapore
  name        = "Singapore-EFS-SG"
  description = "Singapore-EFS-SG"
  vpc_id      = aws_vpc.singapore_vpc.id

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
    Name = "Singapore-EFS-SG"
  }
}

# Singapore-EIP 탄력적 ip 생성
resource "aws_eip" "singapore_eip" {
  provider   = aws.singapore
  vpc      = true

  tags = {
    Name = "Singapore-EIP"
  }
}

# Singapore-NAT-Gateway 나트 게이트웨이 생성
resource "aws_nat_gateway" "singapore_nat_gateway" {
  provider   = aws.singapore
  allocation_id = aws_eip.singapore_eip.id
  subnet_id     = aws_subnet.singapore_pub_sn2.id

  tags = {
    Name = "Singapore-NAT-Gateway"
  }
}

# Singapore-Pri-RT 프라이빗 라우팅 테이블과 NAT-Gateway 연결
resource "aws_route" "singapore_pri_rt_route" {
  provider   = aws.singapore
  route_table_id         = aws_route_table.singapore_pri_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.singapore_nat_gateway.id
}