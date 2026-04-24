variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "The AMI ID for Amazon Linux 2023"
  type        = string
  default     = "ami-098e39bafa7e7303d" # Valid for us-east-1
}
variable "root_volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 50
}

