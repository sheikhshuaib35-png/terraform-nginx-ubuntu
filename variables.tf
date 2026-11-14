variable "aws_region" {
  description = "AWS region in which to use the default VPC and deploy the instance."
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type required by the assessment."
  type        = string
  default     = "t2.micro"
}

variable "ssh_allowed_cidr" {
  description = "Trusted IPv4 CIDR allowed to connect over SSH; use your public IP followed by /32."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_allowed_cidr))
    error_message = "ssh_allowed_cidr must be a valid IPv4 CIDR, preferably your public IP with a /32 mask."
  }
}