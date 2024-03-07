variable "s3_bucket_prefix" {
  description = "S3 bucket prefix where Terraform state file is stored"
  type        = string
}

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

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_prefix" {
  description = "Unique prefix for all resource names"
  default     = "jimmy622001"
  type        = string
}

variable "ec2_key" {
  description = "Public key for SSH access to EC2 instances"
  type        = string
}

variable "autoscaling_max_size" {
  description = "Max size of the autoscaling group"
  default     = 3
  type        = number
}

variable "autoscaling_min_size" {
  description = "Min size of the autoscaling group"
  default     = 1
  type        = number
}

variable "ecs_ec2_instance_type" {
  description = "Instance type for EC2"
  default     = "t3.micro"
  type        = string
}

variable "tag_scenario" {
  description = "Scenario name for all resources"
  default     = "jimmy622001"
}

variable "vpc_cidr_block" {
  description = "VPC network"
}

variable "az_count" {
  description = "Describes how many availability zones we want to have"
  default     = 2
}

variable "maximum_scaling_step_size" {
  description = "Maximum amount of EC2 instances that should be added on scale-out"
  default     = 2
  type        = number
}

variable "minimum_scaling_step_size" {
  description = "Minimum amount of EC2 instances that should be added on scale-out"
  default     = 1
  type        = number
}

variable "target_capacity" {
  description = "Amount of resources of container instances that should be used for task placement in %"
  default     = 100
  type        = number
}