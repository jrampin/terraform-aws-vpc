resource "aws_flow_log" "main" {
  log_destination      = aws_s3_bucket.vpc_logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}

resource "aws_s3_bucket" "vpc_logs" {
  bucket = "${var.project_name}-${var.aws_region}-${var.aws_account_id}-vpc-logs-bucket"
  acl    = "log-delivery-write"

  versioning {
    enabled    = true
    mfa_delete = false # TODO The CICD pipeline then requires MFA if enabled
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.aws_region}-${var.aws_account_id}-vpc-logs-bucket"
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}
