variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "Amazon Machine Image ID"
  default     = "ami-0e9107ed11be76fde"
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH into the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the instance over HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "go-api-port" {
  description = "Port on which the Go API server listens"
  type        = number
  default     = 3001
}
