variable "instance_type" {
  type = string
  description = "Instance type"
}

variable "environment" {
    type = string
    description = "envirnoments (dev/stage/prod)"
}

variable "ami" {
  type = string
  description = "AMI id"
}

variable "key_name" {
  type = string
  description = "key pair"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "public_subnet" {
  type = string
  description = "public subnet id"
}