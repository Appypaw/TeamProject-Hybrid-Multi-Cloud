# IDC-EIP 탄력적 ip 생성(나중에 IDC-CGW 인스턴스에 붙여줘야 함)
resource "aws_eip" "idc_eip" {
  vpc      = true

  tags = {
    Name = "IDC-EIP"
  }
}

# 고객 게이트웨이 생성
resource "aws_customer_gateway" "idc_vpn_cgw" {
  bgp_asn    = 65000
  ip_address = aws_eip.idc_eip.public_ip
  type       = "ipsec.1"

  tags = {
    Name = "IDC-VPN-CGW"
  }
}

# 가상 프라이빗 게이트웨이 생성
resource "aws_vpn_gateway" "aws_vpn_vgw" {
  vpc_id = aws_vpc.seoul_vpc.id

  tags = {
    Name = "AWS_VPN_VGW"
  }
}

# Site-to-Site VPN 연결 생성
resource "aws_vpn_connection" "site_to_site_vpn" {
  vpn_gateway_id      = aws_vpn_gateway.aws_vpn_vgw.id
  customer_gateway_id = aws_customer_gateway.idc_vpn_cgw.id
  type                = "ipsec.1"
  static_routes_only  = true

  local_ipv4_network_cidr = "10.2.0.0/16"
  remote_ipv4_network_cidr = "10.1.0.0/16"

  tunnel1_preshared_key = "fourdollar"
  tunnel2_preshared_key = "fourdollar"

  tags = {
    Name = "CGW-VGW"
  }
}

# S2S 정적경로 추가
resource "aws_vpn_connection_route" "static-route" {
  destination_cidr_block = "10.2.0.0/16"
  vpn_connection_id      = aws_vpn_connection.site_to_site_vpn.id
}

# 퍼블릭 라우팅 테이블 전파
resource "aws_vpn_gateway_route_propagation" "pub" {
  vpn_gateway_id = aws_vpn_gateway.aws_vpn_vgw.id
  route_table_id = aws_route_table.seoul_pub_rt.id
}

# 프라이빗 라우팅 테이블 전파
resource "aws_vpn_gateway_route_propagation" "pri" {
  vpn_gateway_id = aws_vpn_gateway.aws_vpn_vgw.id
  route_table_id = aws_route_table.seoul_pri_rt.id
}