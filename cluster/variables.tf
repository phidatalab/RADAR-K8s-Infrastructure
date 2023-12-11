
variable "AWS_REGION" {
  type        = string
  description = "Target AWS region"
  default     = "eu-west-2"
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS access key associated with an IAM account"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS secret key associated with the access key"
  sensitive   = true
}

variable "AWS_SESSION_TOKEN" {
  type        = string
  description = "Session token for temporary security credentials from AWS STS"
  default     = ""
  sensitive   = true
}

variable "AWS_PROFILE" {
  type        = string
  description = "AWS Profile that resources are created in"
  default     = "default"
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"

  validation {
    condition     = length(var.eks_cluster_name) > 0
    error_message = "The cluster name cannot be empty."
  }
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags associated to resources created"
  default = {
    Project     = "radar-base"
    Environment = "dev"
  }
}

variable "eks_cluster_version" {
  type        = string
  description = "Amazon EKS Kubernetes version"
  default     = "1.27"
}

variable "eks_addon_version" {
  type        = map(string)
  description = "Amazon EKS add-on versions"
  default = {
    "coredns"        = "v1.9.3-eksbuild.10"
    "kube_proxy"     = "v1.26.9-eksbuild.2"
    "vpc_cni"        = "v1.15.3-eksbuild.1"
    "ebs_csi_driver" = "v1.25.0-eksbuild.1"
  }
}

variable "instance_types" {
  type        = list(any)
  description = "List of instance types used by EKS managed node groups"
  default     = ["m5a.large", "m5d.large", "m5a.large", "m5ad.large", "m4.large"]
}

variable "instance_capacity_type" {
  type        = string
  description = "Capacity type used by EKS managed node groups"
  default     = "SPOT"

  validation {
    condition     = var.instance_capacity_type == "ON_DEMAND" || var.instance_capacity_type == "SPOT"
    error_message = "Invalid instance capacity type. Allowed values are 'ON_DEMAND' or 'SPOT'."
  }
}

variable "dmz_node_size" {
  type        = map(number)
  description = "Node size of the dmz node group"
  default = {
    "desired" = 1
    "min"     = 0
    "max"     = 2
  }
}

variable "worker_node_size" {
  type        = map(number)
  description = "Node size of the worker node group"
  default = {
    "desired" = 2
    "min"     = 0
    "max"     = 10
  }
}

variable "eks_admins_group_users" {
  type        = list(string)
  description = "EKS admin IAM user group"
  default     = []
}
