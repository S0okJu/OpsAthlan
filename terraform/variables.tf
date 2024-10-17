variable "ext_network_name" {
  description = "The external network to be used"
  type        = string
  default = "public"
}

variable "port_security_enabled" {
  description = "Enable or disable port security"
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Name of the project"
  type        = string

}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default = "10.0.2.0/24"
}

variable "allowed_ports" {
  description = "List of allowed ports with protocol, range, and remote IP"
  type        = list(map(string))
}

variable "flavor" {
  description = "Flavor of the OpenStack instance"
  type        = string
}

variable "image" {
  description = "Image to use for the instance"
  type        = string
}

variable "network_network" {
  description = "Network ID provided by the network module"
  type        = string
}

variable "network_router_id" {
  description = "Router ID provided by the network module"
  type        = string
}

variable "pubkey_file_path" {
  description = "Path to the public key file"
  type        = string
}

variable "ssh_user" {
  description = "SSH user for the instance"
  type        = string
}

variable "floating_ip" {}