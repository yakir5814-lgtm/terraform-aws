output "deployed_vpc_id" {
  value = module.my_infrastructure.vpc_id
}

output "deployed_server_ip" {
  value = module.my_infrastructure.instance_public_ip
}
