variable "project_name" {
  type        = string
  description = "Vyracare Shell"
  default     = "vyracare-app-shell"
}

variable "region" {
  type        = string
  description = "Região AWS"
  default     = "us-east-1"
}

variable "cloudfront_comment" {
  type        = string
  default     = "CloudFront Distribution for Angular Shell"
}
