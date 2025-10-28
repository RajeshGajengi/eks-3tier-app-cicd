resource "aws_security_group" "sg" {
  name = "tool-SG"
  vpc_id = var.vpc_id
  description = "Allow all inound and outbound traffic"

  ingress  {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
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


resource "aws_db_subnet_group" "my_rds_subnet_group" {
  name       = "my-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "My RDS Subnet Group"
  }
}

resource "aws_db_instance" "mariadb" {
  identifier = "mariadb"
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mariadb"
  engine_version       = "11.4"
  instance_class       = "db.t4g.micro"
  username             = var.username
  password             = var.password
  skip_final_snapshot  = true
#   publicly_accessible = true
  db_subnet_group_name = aws_db_subnet_group.my_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "${var.environment}-db"
    Environment = var.environment 
  }
}





# resource "aws_db_subnet_group" "my_rds_subnet_group" {
#   name       = "my-rds-subnet-group"
#   subnet_ids = ["subnet-00436c3c31d3cf2dc", "subnet-022813e09293b373e"]
#   tags = {
#     Name = "My RDS Subnet Group"
#   }
# }

