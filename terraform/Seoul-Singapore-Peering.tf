# VPC-Peering 서울에서 요청
resource "aws_vpc_peering_connection" "seoul_singapore_vpc_peering" {
  vpc_id        = aws_vpc.seoul_vpc.id
  peer_region = "ap-southeast-1"
  peer_vpc_id   = aws_vpc.singapore_vpc.id
  
  tags = {
    Name = "Seoul-Singapore-VPC-Peering"
  }
}

# VPC-Peering 싱가포르에서 수락
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider   = aws.singapore
  vpc_peering_connection_id = aws_vpc_peering_connection.seoul_singapore_vpc_peering.id
  auto_accept               = true

  tags = {
    Name = "Singapore-Seoul-VPC-Peering"
  }
}

# Seoul-Pub-RT 퍼블릭 라우팅 테이블과 VPC-Peering 연결
resource "aws_route" "seoul_pub_rt_route" {
  route_table_id         = aws_route_table.seoul_pub_rt.id
  destination_cidr_block = "172.16.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.seoul_singapore_vpc_peering.id
}

# Seoul-Pri-RT 프라이빗 라우팅 테이블과 VPC-Peering 연결
resource "aws_route" "seoul_pri_rt_route2" {
  route_table_id         = aws_route_table.seoul_pri_rt.id
  destination_cidr_block = "172.16.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.seoul_singapore_vpc_peering.id
}

# Seoul-DB-RT 프라이빗 라우팅 테이블과 VPC-Peering 연결
resource "aws_route" "seoul_db_rt_route3" {
  route_table_id         = aws_route_table.seoul_db_rt.id
  destination_cidr_block = "172.16.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.seoul_singapore_vpc_peering.id
}

# Singapore-Pub-RT 퍼블릭 라우팅 테이블과 VPC-Peering 연결
resource "aws_route" "singapore_pub_rt_route" {
  provider   = aws.singapore
  route_table_id         = aws_route_table.singapore_pub_rt.id
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.seoul_singapore_vpc_peering.id
}

# Singapore-Pri-RT 프라이빗 라우팅 테이블과 VPC-Peering 연결
resource "aws_route" "singapore_pri_rt_route2" {
  provider   = aws.singapore
  route_table_id         = aws_route_table.singapore_pri_rt.id
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.seoul_singapore_vpc_peering.id
}