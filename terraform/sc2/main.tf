module "network" {
  source = "../modules/network"

  ext_network_name      = var.ext_network_name
  port_security_enabled = var.port_security_enabled
  project_name          = var.project_name
  subnet_cidr           = var.subnet_cidr
}

module "compute" {
  source = "../modules/compute"


  allowed_ports     = var.allowed_ports
  flavor            = var.flavor
  image             = var.image
  network_network   = module.network.network_id
  network_router_id = module.network.router_id
  project_name      = var.project_name
  pubkey_file_path  = var.pubkey_file_path
  ssh_user          = var.ssh_user
  floating_ip       = module.network.floating_ip
}