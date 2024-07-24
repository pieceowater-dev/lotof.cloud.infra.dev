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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
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
  count         = 1
  ami           = "ami-01dad638e8f31ab9a"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet1.id
  key_name      = "pieceowater-dev-serv"  # create this key first!
  security_groups = [ aws_security_group.sg.id ]
  
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 32
    delete_on_termination = true
    iops                  = 3000
    throughput            = 125
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  private_dns_name_options {
    hostname_type                = "ip-name"
    enable_resource_name_dns_a_record = true
    enable_resource_name_dns_aaaa_record = false
  }

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      security_groups
    ]
  }

  # user_data = <<-EOF
  #             #!/bin/bash
  #             yum update -y
  #             yum install -y vim
  #             yum install -y docker
  #             systemctl start docker
  #             systemctl enable docker
  #             yum install -y httpd certbot python3-certbot-apache
  #             sudo systemctl enable httpd
  #             sudo systemctl start httpd
  #             EOF

  tags = {
    Name = "DevServer-${count.index + 1}"
  }
}
