provider "aws" {
  region = var.region
}

# Bucket S3 privado
resource "aws_s3_bucket" "vyracareshell_bucket" {
  bucket        = var.project_name
  force_destroy = true
}

# Configuração SPA (index.html para Angular)
resource "aws_s3_bucket_website_configuration" "vyracareshell_bucket_website" {
  bucket = aws_s3_bucket.vyracareshell_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Origin Access Identity (OAI) para CloudFront acessar bucket privado
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.project_name} CloudFront"
}

# Política de bucket para permitir CloudFront acessar objetos
resource "aws_s3_bucket_policy" "vyracareshell_bucket_policy" {
  bucket = aws_s3_bucket.vyracareshell_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.vyracareshell_bucket.arn}/*"
      }
    ]
  })
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "vyracareshell_distribution" {
  origin {
    domain_name = aws_s3_bucket.vyracareshell_bucket.bucket_regional_domain_name
    origin_id   = "S3-vyracare-app-shell"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.oai.id}"
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-vyracare-app-shell"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
