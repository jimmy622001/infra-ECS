variable "aws_access_key_id" {
  description = "AWS console access key"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS console secret key"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
  type        = string
}

variable "service_tld" {
  description = "TLD for service"
  default     = "https://jimmy622001.wixsite.com/"
  type        = string
}

variable "tag_scenario" {
  description = "Scenario name for all resources"
  default     = "jimmy622001"
}