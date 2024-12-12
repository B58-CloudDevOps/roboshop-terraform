env = prod
vpc = {
  main = {
    cidr               = "10.1.0.0/16"
    availability_zones = ["us-east-1a", "us-east-1b"]
    subnets = {
      public = {
        cidr = ["10.1.0.0/24", "10.1.1.0/24"]
        igw  = true
      }

      web = {
        cidr = ["10.1.2.0/24", "10.1.3.0/24"]
        ngw  = true
      }

      app = {
        cidr = ["10.1.4.0/24", "10.1.5.0/24"]
        ngw  = true
      }

      db = {
        cidr = ["10.1.6.0/24", "10.1.7.0/24"]
        ngw  = true
      },
    }
  },
}