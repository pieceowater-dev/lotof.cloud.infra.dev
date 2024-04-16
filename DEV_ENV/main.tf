# ------------------VARS-------------------
variable "providerRegion" {}

# ------------------VPC--------------------

resource "aws_vpc" "main" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name = "DevVPC"
  }
}

# ------------------Subnet--------------------

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.providerRegion}a"

  tags = {
    Name = "Subnet1"
  }
}

# ------------------Internet Gateway--------------------

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainGateway"
  }
}

# ------------------Route Table--------------------

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "DevRouteTable"
  }
}

# ------------------Route Table Association--------------------

resource "aws_route_table_association" "subnet_assoc" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt.id
}

# ------------------Security Group--------------------

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  // Allow SSH inbound from your IP address (replace with your IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevSecurityGroup"
  }
}

# ------------------EC2 Instance--------------------
resource "aws_instance" "vm" {
  ami           = "ami-01dad638e8f31ab9a"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet1.id
  key_name      = "pieceowater-dev-serv"  # create this key first!
  security_groups = [ aws_security_group.sg.id ]
  
  associate_public_ip_address = true

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      security_groups
    ]
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y vim
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              EOF

  tags = {
    Name = "DevServer"
  }
}
