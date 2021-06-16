data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t3.medium"
  key_name                    = aws_key_pair.terraform_key.id
  subnet_id                   = aws_subnet.private[0].id
  vpc_security_group_ids      = [aws_security_group.main.id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-private"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

resource "aws_instance" "public" {
  ami           = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type = "t3.medium"
  key_name      = aws_key_pair.terraform_key.id
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-public"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Allow inbound traffic to ElasticSearch and from VPC CIDR"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["202.180.77.121/32"]
  }

  // Egress is required, otherwise lambda functions can't ship logs into ES cluster
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}