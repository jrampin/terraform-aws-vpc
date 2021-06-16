resource "aws_vpc" "main" {
  cidr_block = var.cidr_network

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}