output "s3_bucket_name" {
  value = aws_s3_bucket.vyracaredashboard_bucket.bucket
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.vyracaredashboard_distribution.domain_name
}
