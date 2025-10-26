# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-buck"      # The name of your S3 bucket
#     key            = "dev/terraform.tfstate"  # Path for the state file in S3
#     region         = "us-east-1"              # AWS region
#     use_lockfile   = true                     # enable native S3 locking
#   }
# }

