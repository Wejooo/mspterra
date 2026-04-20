resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids             = aws_subnet.public[*].id
    endpoint_public_access = true
  }

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_eks_node_group" "workers" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-workers"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = aws_subnet.public[*].id

  instance_types = [var.node_instance_type]

  scaling_config {
    desired_size = var.node_count
    min_size     = 1
    max_size     = var.node_count + 1
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${var.cluster_name}-worker"
  }

  depends_on = [aws_eks_cluster.main]
}
