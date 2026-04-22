module "my_infrastructure" {
  source = "../../modules/network_app"

 
  vpc_cidr         = "10.0.0.0/16"
  subnet_count     = 2
  instance_type    = "t3.micro"
  assign_public_ip = true
}
