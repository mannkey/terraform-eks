variable "kubernetes_version" {
  default     = 1.31
  description = "kubernetes version"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default     = "us-west-1"
  description = "aws region"
}

variable "namespaces" {
  description = "This is list of namespaces"
  type        = list(string)
  default = [
    "ingress",
    "monitoring",
    "prod",
  ]
}
