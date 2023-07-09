# Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "AKIAYLGIQMFDBTY73NH6"
  secret_key = "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"
  region = "us-east-1"
}

# Provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity-T2" {
  ami = "ami-06b09bfacae1453cb"
  instance_type =  "t2.micro"
  count = 4
  key_name = "udacity"
  tags = {
    "Name" = "Udacity T2"
    "Created_by" = "terraform"
  }
}


# Provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity-M4" {
  ami = "ami-06b09bfacae1453cb"
  instance_type = "m4.large"
  count = 2
  key_name = "udacity"
  tags = {
    "Name" = "Udacity M4"
    "Created_by" = "terraform"
  } 
}