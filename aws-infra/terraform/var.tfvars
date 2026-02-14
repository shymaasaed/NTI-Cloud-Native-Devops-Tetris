region = "eu-north-1"
vpc_cidr = "10.44.0.0/16"
private_subnets_cidr = [ "10.44.1.0/24" , "10.44.2.0/24","10.44.4.0/24"]
public_subnets_cidr =  "10.44.3.0/24" 
private_subnets_names = ["private-subnet-a","private-subnet-b","private-subnet-c"]
public_subnets_names = "public-subnet"
vpc_name = "eks-vpc"
igw_name = "igw"
