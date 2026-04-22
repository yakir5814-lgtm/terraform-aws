variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "The AMI ID for Ubuntu 22.04"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Valid for us-east-1
}
