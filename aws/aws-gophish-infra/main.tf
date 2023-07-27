terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
provider "aws" {
  region  = "us-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_instance" "dev_server" {
#  source  = "terraform-aws-modules/ec2-instance/aws"
#sets up basic instance for gophish server

  instance_type          = "t2.micro"
  ami			 = "ami-03f65b8614a860c29"
  key_name               = "mykey"
  vpc_security_group_ids = ["sg-1","sg-2"] 
  user_data = "${file("dev-instance.sh")}"

  tags = {
    Name = "ubuntu-instance"
    Terraform   = "true"
    Environment = "dev"
  }
}
  resource "aws_route53_record" "dev_server" {
   zone_id = "my-zone-id" 
   name    = "my.domain.com"
   type    = "A"
   ttl     = 300
   records = [aws_instance.dev_server.public_ip]
 }
