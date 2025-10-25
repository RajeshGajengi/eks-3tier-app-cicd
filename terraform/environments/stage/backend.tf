terraform {
  backend "s3" {
    bucket         = "terraform-state-mynewbucket"    # The name of your S3 bucket
    key            = "eks/stage/terraform.tfstate"  # Path for the state file in S3
    region         = "us-east-1"                    # AWS region
    encrypt        = true                           # Enable encryption for the state file in S3
    dynamodb_table = "terraform-locks"              # DynamoDB table for state locking
  }
}

