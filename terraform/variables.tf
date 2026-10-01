variable "aws_region" {
  description = "AWS region for infrastructure provisioning"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Target deployment environment"
  type        = string
  default     = "production"
}

variable "instance_type" {
  description = "Compute instance type for Kubernetes node"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu/K8s node"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS (us-east-1)
}

variable "ssh_key_name" {
  description = "SSH key pair name for instance access"
  type        = string
  default     = "k8s-ssh-key"
}
