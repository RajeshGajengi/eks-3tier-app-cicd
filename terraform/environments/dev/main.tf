provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  environment     = var.environment
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks-cluster" {
  source        = "../../modules/eks-cluster"
  environment   = var.environment
  cluster_name  = var.cluster_name
  vpc_id        = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  depends_on = [module.vpc]
}

module "eks-nodes" {
  source          = "../../modules/eks-nodes"
  node_group_name = var.node_group_name
  cluster_name    = module.eks-cluster.eks_cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  environment     = var.environment
  desired_size    = var.desired_size
  max_size        = var.max_size
  min_size        = var.min_size
  depends_on = [module.vpc]
}

module "ec2" {
 source = "../../modules/ec2"
 instance_type = var.instance_type
 environment = var.environment
 key_name = var.key_name
 vpc_id = module.vpc.vpc_id
 public_subnet = module.vpc.public_subnet_ids[1]
 ami = var.ami
 depends_on = [ module.vpc ]

}

module "rds" {
  source = "../../modules/rds"
  vpc_id = module.vpc.vpc_id
  environment = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  db_name = var.db_name
  username = var.username
  password = var.password
  depends_on = [ module.eks-cluster,module.eks-nodes ]
  }


# Ansible invetory configuration
resource "null_resource" "remote_ansible_inventory" {
  depends_on = [module.ec2]  # Wait for EC2 module to finish

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu",
      "git clone -b dev https://github.com/RajeshGajengi/eks-3tier-app-cicd.git", 
      "cd eks-3tier-app-cicd/ansible",
      "rm -f inventory.ini",
      # Create the inventory file safely
      "echo '[master]' > inventory.ini",
      "echo '${module.ec2.master_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem' >> inventory.ini",
      "echo '[sonarqube]' >> inventory.ini",
      "echo '${module.ec2.sonarqube_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem' >> inventory.ini",
      "echo '[monitor]' >> inventory.ini",
      "echo '${module.ec2.monitoring_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem' >> inventory.ini"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.root}/../../../project.pem")
      host        = module.ec2.master_public_ip
    }
  }
}






# resource "null_resource" "remote_ansible_inventory" {
#   depends_on = [module.ec2]  # Wait for EC2 module to finish

#   provisioner "remote-exec" {
#     inline = [
#       "cd /home/ubuntu",
#       "git clone -b dev https://github.com/RajeshGajengi/eks-3tier-app-cicd.git", 
#       "cd eks-3tier-app-cicd/ansible",
#       "rm inventory.ini",
#       <<-EOF
#       cat <<INVENTORY > /home/ubuntu/eks-3tier-app-cicd/ansible/inventory.ini
#       [master]
#       ${module.ec2.master_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem

#       [sonarqube]
#       ${module.ec2.sonarqube_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem

#       [monitor]
#       ${module.ec2.monitoring_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem
#       INVENTORY
#       EOF
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file("${path.root}/../../../project.pem")
#       host        = module.ec2.master_public_ip
#     }
#   }
# }



## It gives inventory.ini name diffrent like 'inventory.ini'$'\r' so use below code


# resource "null_resource" "remote_ansible_inventory" {
#   depends_on = [module.ec2]

#   provisioner "remote-exec" {
#     inline = [
#       "cd /home/ubuntu",
#       "git clone -b dev https://github.com/RajeshGajengi/eks-3tier-app-cicd.git",
#       "cd eks-3tier-app-cicd/ansible",
#       "rm -f inventory.ini",
#       # LF-safe heredoc
#       "cat <<'INVENTORY' > inventory.ini",
#       "[master]",
#       "${module.ec2.master_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem",
#       "",
#       "[sonarqube]",
#       "${module.ec2.sonarqube_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem",
#       "",
#       "[monitor]",
#       "${module.ec2.monitoring_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem",
#       "INVENTORY"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file("${path.root}/../../../project.pem")
#       host        = module.ec2.master_public_ip
#     }
#   }
# }




# this will load values into local inevetory.ini file

# resource "local_file" "ansible_config" {
#   filename = "${path.module}/../../../ansible/inventory.ini"
  
#   content = <<EOT
#   [master]
#   ${module.ec2.master_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem
  
#   [sonarqube]
#   ${module.ec2.sonarqube_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem

#   [monitor]
#   ${module.ec2.monitoring_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/project.pem

#   EOT

#   depends_on = [ module.ec2 ]
# }



# resource "null_resource" "run_ansible" {
#   provisioner "local-exec" {
#     command = <<-EOF
#               git clone -b dev https://github.com/RajeshGajengi/personal-project.git
#               cd personal-project
#             EOF
#   }
# }