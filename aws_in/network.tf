# Enabling vpc to connect to the internet
resource "aws_internet_gateway" "iGTW" {
  vpc_id = aws_vpc.main.id
  tags = {
    name = "internetGateway"
  }
}

#custom routing table
resource "aws_route_table" "public-CRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"                  # allow to reach everywhere
    gateway_id = aws_internet_gateway.iGTW.id # Custom Routing Table use this Internet Gateway to access internet
  }
  tags = {
    Name = "custom-pub-CRT"
  }

}

# create connection between route tambel and subnet
resource "aws_route_table_association" "associationOfCRTAndSubnet" {
  subnet_id      = aws_subnet.test-subnet-public-1.id
  route_table_id = aws_route_table.public-CRT.id

}

#Creation of security group for our EC2
#This will allow ssh connection

resource "aws_security_group" "ssh_security" {
  vpc_id = aws_vpc.main.id
  # the egress was made to all ip adresses to connect ssh
  # can be changed to the ip 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]

  }
  # this is to allow the ngix inside EC2 to reach the outside world
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "SSH-allowed"
  }
}
