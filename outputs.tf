output "s3_bucket_name" {
  value = aws_s3_bucket.vyracareshell_bucket.bucket
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.vyracareshell_distribution.domain_name
}
