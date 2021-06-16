resource "aws_internet_gateway" "gw" {
  count = var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-internet-gw"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

resource "aws_route_table" "igw_route_table" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-pub-route"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

resource "aws_route" "public_internet_access" {
  count = var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.igw_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw[count.index].id
}