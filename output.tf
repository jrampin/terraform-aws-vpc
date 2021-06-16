output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.main.*.id, [""])[0]
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "s3_bucket_logs" {
  description = "S3 Bucket for VPC logs"
  value = aws_s3_bucket.vpc_logs
}
