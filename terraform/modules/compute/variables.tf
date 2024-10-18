# Metadata
variable "project_name" {}

# Key Pair
variable "pubkey_file_path" {}

# Instance
variable "flavor" {}
variable "ssh_user" {}
variable "image" {}

# Network
variable "network_network" {}
variable "network_router_id" {}
variable "allowed_ports" {
  type = list
}
variable "floating_ip" {}