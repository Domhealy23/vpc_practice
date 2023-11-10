resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

    tags = {
        Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet1A" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Availabilty_zone_a"
  }
}

resource "aws_subnet" "subnet1B" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Availabilty_zone_b"
  }
}

resource "aws_subnet" "subnet1C" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "Availabilty_zone_c"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"
 }

  tags = {
    Name = "route_table"
  }
}

# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id       = aws_vpc.main.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = ["10.0.0.0/16"]  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
}
} 

resource "aws_route_table_association" "a" {
 subnet_id = "${aws_subnet.subnet1A.id}"
 route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_route_table_association" "b" {
 subnet_id = "${aws_subnet.subnet1B.id}"
 route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_route_table_association" "c" {
 subnet_id = "${aws_subnet.subnet1C.id}"
 route_table_id = "${aws_route_table.rt.id}"
}

data "aws_ami" "linux" {
   most_recent = true
   owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_sub1A" {
    ami  = data.aws_ami.linux.id
    #count = "${var.number_of_instances}"
    subnet_id = aws_subnet.subnet1A.id
    instance_type = "t2.micro"
        #key_name = "${var.ami_key_pair_name}"
    tags = {
      Name = "ec2_sub1A"
    }
} 

resource "aws_instance" "ec2_sub1B" {
    ami  = data.aws_ami.linux.id
    #count = "${var.number_of_instances}"
    subnet_id = aws_subnet.subnet1B.id
    instance_type = "t2.micro"
    #key_name = "${var.ami_key_pair_name}"
    tags = {
      Name = "ec2_sub1B"
    }
} 

resource "aws_instance" "ec2_sub1C" {
    ami  = data.aws_ami.linux.id
    #count = "${var.number_of_instances}"
    subnet_id = aws_subnet.subnet1C.id
    instance_type = "t2.micro"
    #key_name = "${var.ami_key_pair_name}"
    tags = {
      Name = "ec2_sub1C"
    }
} 
# output "ami" {
#   value = data.aws_ami.linux
  
