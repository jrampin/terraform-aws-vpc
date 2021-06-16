//
// Public subnets
//

resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true

  availability_zone = length(regexall("^[a-z]{2}-", var.azs[count.index])) > 0 ? var.azs[count.index] : null

  tags = {
    Name        = "${var.project_name}-${var.environment}-pub-subnet-${count.index + 1}"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

//
// Private subnets
//

resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]

  availability_zone = length(regexall("^[a-z]{2}-", var.azs[count.index])) > 0 ? var.azs[count.index] : null

  tags = {
    Name        = "${var.project_name}-${var.environment}-priv-subnet-${count.index + 1}"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

//
// Route table association
//

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.igw_route_table[0].id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.nat.id
}

#//
#// Public routes
#//
#
#resource "aws_route_table" "public" {
#  count = length(var.public_subnets) > 0 ? 1 : 0
#
#  vpc_id = aws_vpc.main.id
#}
