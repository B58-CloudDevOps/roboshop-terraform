env            = "dev"
def_vpc_cidr   = "172.31.0.0/16" # Added this additional input to cater maps iterated from vpc
bastion_host   = ["172.31.43.201/32"]
hosted_zone_id = "Z0520454XBSCKDOCPTCY"
vpc = {
  main = {
    cidr               = "10.0.0.0/16"
    availability_zones = ["us-east-1a", "us-east-1b"]
    subnets = {
      public = {
        cidr = ["10.0.0.0/24", "10.0.1.0/24"]
        igw  = true
      }

      web = {
        cidr = ["10.0.2.0/24", "10.0.3.0/24"]
        ngw  = true
      }

      app = {
        cidr = ["10.0.4.0/24", "10.0.5.0/24"]
        ngw  = true
      }

      db = {
        cidr = ["10.0.6.0/24", "10.0.7.0/24"]
        ngw  = true
      }
    }

    peering_vpcs = {
      tools = {
        id             = "vpc-0031cc952da0c7bfc"
        def_vpc_cidr   = "172.31.0.0/16"
        route_table_id = "rtb-0623fe36206b96d65"
      }
    }
  }
}

db_servers = {
  rabbitmq = {
    instance_type = "t3.small"
    ports = {
      rabbitmq = {
        port = 5672
        cidr = ["10.0.4.0/24", "10.0.5.0/24"]
      }
    }
  }
  mongodb = {
    instance_type = "t3.small"
    ports = {
      mongodb = {
        port = 27017
        cidr = ["10.0.4.0/24", "10.0.5.0/24"]
      }
    }
  }
  mysql = {
    instance_type = "t3.small"
    ports = {
      mysql = {
        port = 3306
        cidr = ["10.0.4.0/24", "10.0.5.0/24"]
      }
    }
  }
  redis = {
    instance_type = "t3.small"
    ports = {
      redis = {
        port = 6379
        cidr = ["10.0.4.0/24", "10.0.5.0/24"]
      }
    }
  }
}


eks = {
  main = {
    subnet_ref          = "app"
    eks_cluster_version = "1.30" # 1.31 is latest
    node_groups = {
      first = {
        min_nodes      = 1
        max_nodes      = 3
        capacity_type  = "ON_DEMAND"
        instance_types = ["t3.medium"]
      }
    }
    addons = {
      kube-proxy = {
        addon_version               = null
        resolve_conflicts_on_update = "OVERWRITE"
      }
      vpc-cni = {
        addon_version               = null
        resolve_conflicts_on_update = "OVERWRITE"
      }
      eks-pod-identity-agent = {
        addon_version               = null
        resolve_conflicts_on_update = "OVERWRITE"
      }
    }
  }
}


opensearch = {
  main = {
    instance_type  = "r7g.large.search"
    engine_version = "OpenSearch_2.17"
  }
}