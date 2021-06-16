variable "aws_account_id" {
  default     = "123456"
  description = "Set the AWS account id; uses include ensuring global uniqueness of S3 bucket names"
  type        = string
}

variable "project_name" {
  default = "demo"
}

variable "environment" {
  description = "The environment name. Used to name and tag resources"
  type    = string
  default = "dev"
}

variable "aws_region" {
  description = "AWS Region"
  default = "ap-southeast-2"
}

variable "cidr_network" {
  default = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default = ["ap-southeast-2a", "ap-southeast-2c"]
}

variable "public_subnets" {
  default = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnets" {
  default = ["10.0.48.0/20", "10.0.64.0/20"]
}
