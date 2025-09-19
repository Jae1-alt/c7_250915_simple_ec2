variable "region" {
  type        = string
  description = "Region for infrastructure"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "Desired CIDR for VPC"
  default     = "10.190.0.0/16"
}

variable "public_subnets" {
  description = "The 'key : value' pair in the this variable will be used to create the subnets, number of subnets(based on the number of 'key:value' pairs, and the 'value' in the pair will be used to create the associeted subnet(s))"
  type        = map(number)
  default = {
    "class7_a" = 0
  }
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "c7_2_brazil"
}

variable "ingress_ipv4_ssh" {
  type        = string
  description = "The permitted ipv4 cidr range for port 22"
  default     = "0.0.0.0/0"
}

variable "ingress_ipv4_http" {
  type        = string
  description = "The permitted ipv4 cidr range for port 80"
  default     = "0.0.0.0/0"
}


locals {
  service_name = "c7_to_brazil"
  owner        = "Jaune"
  environment  = "Test"
}

locals {
  subnet_tags = {
    for name, number in var.public_subnets : name => {

      Name        = name
      Owner       = local.owner
      Environment = local.environment
    }
  }
}

locals {
  ec2_tags = {
    for name, number in var.public_subnets : name => {

      Name        = "${name}-instance"
      Owner       = local.owner
      Environment = local.environment
    }
  }
}

locals {
  vpc_tags = {
    Name        = var.vpc_name
    Owner       = local.owner
    Environment = local.environment
  }
}
