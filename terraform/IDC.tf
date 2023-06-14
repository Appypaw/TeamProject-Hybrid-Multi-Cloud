# IDC-VPC 생성(tags가 이름,vpc생성 시 보안그룹(디폴트)도 같이 생성됨)
resource "aws_vpc" "idc_vpc" {
  cidr_block = "10.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "IDC-VPC"
  }
}

# IDC-Pub-SN1 생성(id는 리소스 참고,tags가 만들어지는 이름)
resource "aws_subnet" "idc_pub_sn1" {
  vpc_id     = aws_vpc.idc_vpc.id
  cidr_block = "10.2.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "IDC-Pub-SN1"
  }
}

# IDC-Pub-SN2 생성(id는 리소스 참고,tags가 만들어지는 이름)
resource "aws_subnet" "idc_pub_sn2" {
  vpc_id     = aws_vpc.idc_vpc.id
  cidr_block = "10.2.2.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "IDC-Pub-SN2"
  }
}

# IDC-Pri-SN3 생성(id는 리소스 참고,tags가 만들어지는 이름)
resource "aws_subnet" "idc_pri_sn3" {
  vpc_id     = aws_vpc.idc_vpc.id
  cidr_block = "10.2.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "IDC-Pri-SN3"
  }
}

# IDC-Pri-SN4 생성(id는 리소스 참고,tags가 만들어지는 이름)
resource "aws_subnet" "idc_pri_sn4" {
  vpc_id     = aws_vpc.idc_vpc.id
  cidr_block = "10.2.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "IDC-Pri-SN4"
  }
}

# IDC-IGW 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "idc_igw" {
  vpc_id = aws_vpc.idc_vpc.id

  tags = {
    Name = "IDC-IGW"
  }
}

# IDC-Pub-RT 라우팅 테이블 생성(id는 리소스 참고)
resource "aws_route_table" "idc_pub_rt" {
  vpc_id = aws_vpc.idc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.idc_igw.id
  }

  tags = {
    Name = "IDC-Pub-RT"
  }
}

# IDC-Pub-RT 퍼블릭 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "idc_pub_rt_association1" {
  subnet_id      = aws_subnet.idc_pub_sn1.id
  route_table_id = aws_route_table.idc_pub_rt.id
}

# IDC-Pub-RT 퍼블릭 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "idc_pub_rt_association2" {
  subnet_id      = aws_subnet.idc_pub_sn2.id
  route_table_id = aws_route_table.idc_pub_rt.id
}

# IDC-Pri-RT 라우팅 테이블 생성(id는 리소스 참고)
resource "aws_route_table" "idc_pri_rt" {
  vpc_id = aws_vpc.idc_vpc.id

  tags = {
    Name = "IDC-Pri-RT"
  }
}

# IDC-Pri-RT 프라이빗 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "idc_pri_rt_association3" {
  subnet_id      = aws_subnet.idc_pri_sn3.id
  route_table_id = aws_route_table.idc_pri_rt.id
}

# IDC-Pri-RT 프라이빗 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "idc_pri_rt_association4" {
  subnet_id      = aws_subnet.idc_pri_sn4.id
  route_table_id = aws_route_table.idc_pri_rt.id
}

# IDC-Pub-SG 보안 그룹 생성(name이 보안 그룹 이름, tags가 Name으로 들어간다)
resource "aws_security_group" "idc_pub_sg" {
  name        = "IDC-Pub-SG"
  description = "IDC-Pub-SG"
  vpc_id      = aws_vpc.idc_vpc.id

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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "IDC-Pub-SG"
  }
}

# idc-Pri-SG 보안 그룹 생성(name이 보안 그룹 이름, tags가 Name으로 들어간다)
resource "aws_security_group" "idc_pri_sg" {
  name        = "IDC-Pri-SG"
  description = "IDC-Pri-SG"
  vpc_id      = aws_vpc.idc_vpc.id

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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "IDC-Pri-SG"
  }
}