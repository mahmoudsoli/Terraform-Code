module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-dev-cluster"
  cluster_version = "1.32"
  vpc_id          = aws_vpc.vpc.id
  subnet_ids      = [aws_subnet.new-pub-subnet.id, aws_subnet.new-pub-subnet-2.id]

  eks_managed_node_groups = {
    stagging_nodes = {
      desired_size = 3
      max_size     = 4
      min_size     = 3

      instance_types = ["t2.micro"]

      ssh = {
        enable     = true
        public_key = "demo"
      }

      tags = {
        Name    = "eks-node-for-stagging-cluster"
        project = "Terraform-with-AzureDevOps"
      }
    }
  }

  tags = {
    Name    = "eks-stagging-cluster"
    project = "Terraform-with-AzureDevOps"
  }
}

# Add IAM user 'mahmoud' to aws-auth configmap
resource "kubernetes_config_map" "aws_auth" {
  depends_on = [module.eks]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = <<EOT
- userarn: arn:aws:iam::275837741249:user/mahmoud
  username: mahmoud
  groups:
    - system:masters
EOT
  }
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
