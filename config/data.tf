data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.eks_cluster_name}-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["${var.eks_cluster_name}-vpc"]
  }
  filter {
    name   = "tag:subnet-type"
    values = ["public"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.eks_cluster_name}-vpc"]
  }
  filter {
    name   = "tag:subnet-type"
    values = ["private"]
  }
}

data "aws_security_group" "node" {
  filter {
    name   = "tag:Name"
    values = ["${var.eks_cluster_name}-node"]
  }
}

data "aws_security_group" "vpc_default" {
  filter {
    name   = "tag:Name"
    values = ["${var.eks_cluster_name}-vpc-default-sg"]
  }
}

data "aws_eks_cluster" "main" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "main" {
  name = var.eks_cluster_name
}

data "aws_autoscaling_groups" "main" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [var.eks_cluster_name]
  }
}

data "aws_eks_node_group" "worker" {
  cluster_name = var.eks_cluster_name
  node_group_name = join("-", [
    element(split("-", [for asg in data.aws_autoscaling_groups.main.names : asg if startswith(asg, "eks-${var.eks_cluster_name}-worker-")][0]), 1),
    element(split("-", [for asg in data.aws_autoscaling_groups.main.names : asg if startswith(asg, "eks-${var.eks_cluster_name}-worker-")][0]), 2),
    element(split("-", [for asg in data.aws_autoscaling_groups.main.names : asg if startswith(asg, "eks-${var.eks_cluster_name}-worker-")][0]), 3),
  ]) # This is really hacky and there's gonna be a better way of extracting this.
}

locals {
  aws_account = element(split(":", data.aws_eks_cluster.main.arn), 4)
  oidc_issuer = element(split("//", data.aws_eks_cluster.main.identity[0].oidc[0].issuer), 1)

  storage_classes = {
    gp2 = "radar-base-ebs-sc-gp2"
    gp3 = "radar-base-ebs-sc-gp3"
    io1 = "radar-base-ebs-sc-io1"
    io2 = "radar-base-ebs-sc-io2"
  }

  s3_bucket_names = {
    intermediate_output_storage = "${var.eks_cluster_name}-intermediate-output-storage"
    output_storage              = "${var.eks_cluster_name}-output-storage"
    velero_backups              = "${var.eks_cluster_name}-velero-backups"
  }

  cname_prefixes = [
    "alertmanager",
    "dashboard",
    "grafana",
    "graylog",
    "prometheus",
    "s3",
  ]

}
