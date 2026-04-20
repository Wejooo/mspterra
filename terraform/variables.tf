variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "mspterra-eks"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes (2 vCPU, 4 GB RAM)"
  type        = string
  default     = "t3.medium"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster control plane"
  type        = string
}

variable "eks_node_role_arn" {
  description = "ARN of the IAM role for EKS worker nodes"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
