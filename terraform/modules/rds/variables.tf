variable "environment" {
    type = string
    description = "envirnoments (dev/stage/prod)"
}

variable "vpc_id" {
  type = string
  description = "vpc id of database vpc"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List the private subnets ids of database subnets"
}

variable "db_name" {
  type = string
  description = "Name of database instance"
}

variable "username" {
  type = string
  description = "name of user"
}

variable "password" {
  type = string
  description = "password of user"
}