resource "aws_eip" "vpc_eip" {
  vpc = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-eip"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

resource "aws_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.vpc_eip.id
  subnet_id     = aws_subnet.public[count.index].id
  #subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-gw"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-priv-route"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

resource "aws_route" "nat_access" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}