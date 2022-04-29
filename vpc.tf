# ====================
#
# VPC
#
# ====================
resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # DNS解決を有効化
  enable_dns_hostnames = true # DNSホスト名を有効化

  tags = {
    Name = "demo"
  }
}

# ====================
#
# Subnet
#
# ====================
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true # インスタンスにパブリックIPアドレスを自動的に割り当てる

  tags = {
    Name = "demo"
  }
}

# ====================
#
# Internet Gateway
#
# ====================
resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "demo"
  }
}

# ====================
#
# Route Table
#
# ====================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "public_demo"
  }
}

resource "aws_route" "demo" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.demo.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "demo" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ====================
#
# Security Group
#
# ====================
resource "aws_security_group" "demo" {
  vpc_id = aws_vpc.demo.id
  name   = "demo"

  tags = {
    Name = "demo"
  }
}

# インバウンドルール(ssh接続用)
resource "aws_security_group_rule" "in_ssh" {
  security_group_id = aws_security_group.demo.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

# インバウンドルール(pingコマンド用)
resource "aws_security_group_rule" "in_icmp" {
  security_group_id = aws_security_group.demo.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
}

# アウトバウンドルール(全開放)
resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.demo.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}
