provider "aws" {
  region = "ap-south-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}

# Create subnet in the VPC
resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "DefaultSubnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainGateway"
  }
}

# Create Route Table
resource "aws_route_table" "rtable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "MainRouteTable" }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.default.id
  route_table_id = aws_route_table.rtable.id
}

# Create Security Group for SSH, HTTP, HTTPS
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

# Create EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0f1dcc636b69a6438"
  instance_type = "t3.medium"
  key_name      = "my-key"

  subnet_id              = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "DockerHost"
  }

  provisioner "local-exec" {
  command = "mkdir -p ~/ansible && echo ${self.public_ip} > ~/ansible/inventory"
}

}


    to_port     = 443
    protocol    = "tcp"

                                                                             41,1          50%


                                                                             1,1           Top
