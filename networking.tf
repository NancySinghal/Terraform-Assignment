provider "aws" {
    region = "ap-south-1"
}

// Creating VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

//Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

//Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}

//Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

//Public Routes
//Route table
resource "aws_route_table" "my_rt_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-rt"
  }
}

//Route table association
resource "aws_route_table_association" "my_public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_rt_public.id
}

//Security Groups
resource "aws_security_group" "my_vpc_sg" {
  name        = "my-vpc-sg"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "my-vpc-sg"
  }
}

//NAT Gateway
resource "aws_eip" "nat_gateway" {
    domain = "vpc"
}

resource "aws_nat_gateway" "my-nat-gateway" {
    allocation_id = aws_eip.nat_gateway.id
    subnet_id     = aws_subnet.public_subnet.id

    tags = {
      Name = "NAT-gateway"
    }
    depends_on = [aws_internet_gateway.my_igw]
}

# Private routes
resource "aws_route_table" "my_rt_private" {
    vpc_id = aws_vpc.my_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.my-nat-gateway.id
    }
    
    tags = {
        Name = "my_rt_private"
    }
}
resource "aws_route_table_association" "my_private_rt_association"{
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.my_rt_private.id
}