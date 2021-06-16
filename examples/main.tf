module "network" {
  source          = "../"

  aws_account_id  = var.aws_account_id
  project_name    = var.project_name
  environment     = var.environment
  aws_region      = var.aws_region
  cidr_network    = var.cidr_network
  azs             = var.azs
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}
