module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name = var.cluster_name
  cluster_version = "1.31"

  vpc_id = var.vpc_id
  subnet_ids = var.private_subnet
  control_plane_subnet_ids = var.intra_subnet

  authentication_mode = "API_AND_CONFIG_MAP"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  
  # cluster_addons = {
  #   coredns = {
  #     most_recent = true
  #   }
  #   kube-proxy = {
  #     most_recent = true
  #   }
  #   vpc-cni = {
  #     most_recent = true
  #   }
  #   aws-ebs-csi-driver = {
  #     most_recent = true
  
  #   }
  # }
  cluster_addons = {
    coredns        = { most_recent = true }
    kube-proxy     = { most_recent = true }
    vpc-cni        = { most_recent = true }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    node_group_1 = {
      instance_types = ["t3.medium"] 
      ami_type = "AL2023_x86_64_STANDARD"
      

      min_size = 1
      max_size = 1
      desired_size = 1

      additional_policies = [
          "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
          var.ebs_csi_driver_policy_arn
      ]

        tags = {
          "name" = "${var.cluster_name}"
        }
      launch_template = {
        root_volume_type = "gp2"
        root_volume_size = 20
      }
      labels = {
        "managed_by" = "terraform"
        "k8s-app" = "microservice-application"
      }

    }
    # node_group_2 = {
    #     ami_type = "AL2023_x86_64_STANDARD"
    #     instance_types = [""] 

    #     min_size = 1
    #     max_size = 1
    #     desired_size = 1
    # }
    
    # node_group_2 = {
    #     ami_type = "AL2023_x86_64_STANDARD"
    #     instance_types = [""] 
    #     min_size = 1
    #     max_size = 1
    #     desired_size = 1
    # }

}

}