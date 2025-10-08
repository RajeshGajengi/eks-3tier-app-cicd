variable "cluster_name" {
  type = string
  default = "mycluster"
}

variable "node_group_name" {
  type = string
  default = "mynode"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "desired_size" {
  default = 1
}

variable "max_size" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "instance_type" {
    type = string
    default = "t2.medium"
}
