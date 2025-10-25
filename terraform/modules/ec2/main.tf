
# Create a security group allowing HTTP, SSH, ICMP, and all outbound traffic
resource "aws_security_group" "sg" {
  name = "tool-SG"
  vpc_id = var.vpc_id
  description = "Allow all inound and outbound traffic"

  ingress  {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all inbound traffic"
  }
  
  egress  {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.environment}-VPC-SG"
  }

}



resource "aws_instance" "master" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  security_groups = [aws_security_group.sg.id]
  key_name = var.key_name
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y software-properties-common
              add-apt-repository --yes --update ppa:ansible/ansible
              apt-get install -y ansible
            EOF

  tags = {
    Name = "${var.environment}-Master"
    Environment = var.environment 
  }

}

resource "aws_instance" "monitoring" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.public_subnet
  security_groups = [aws_security_group.sg.id]
  tags = {
    Name = "${var.environment}-Monitoring"
    Environment = var.environment
  }
}

resource "aws_instance" "sonarqube" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.public_subnet
  security_groups = [aws_security_group.sg.id]
  tags = {
    Name = "${var.environment}-SonarQube"
    Environment = var.environment 
  }
}

