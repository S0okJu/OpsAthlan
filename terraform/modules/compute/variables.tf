# Metadata
variable "project_name" {}

# Key Pair
variable "pubkey_file_path" {}

# Instance
variable "flavor" {}
variable "ssh_user" {}
variable "image" {}
variable "nova_volume_name" {
    default = "nova-volume"
}

variable "nova_count" {
    default = 1
}
variable "nova_with_volume_count" {
    default = 0
}

# Network
variable "network_network" {}
variable "network_router_id" {}
variable "allowed_ports" {}
variable "instance_with_volume_allowed" {
    default = []
}
variable "floating_ip" {}