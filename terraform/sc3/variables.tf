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
  default     = "OpsAthlan-03"

}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default = "10.0.3.0/24"
}

variable "allowed_ports" {
  description = "List of allowed ports with protocol, range, and remote IP"
  type = list(object({
    protocol         = string
    port_range_min   = number
    port_range_max   = number
    remote_ip_prefix = optional(string, "0.0.0.0/0")
  }))
  default = [
    {
      protocol       = "tcp"
      port_range_min = 22
      port_range_max = 22
    },
    {
      protocol       = "tcp"
      port_range_min = 8080
      port_range_max = 8080
    },
    {
      protocol       = "tcp"
      port_range_min = 8081
      port_range_max = 8081
    }
  ]
}

variable "flavor" {
  description = "Flavor of the OpenStack instance"
  type        = string
  default     = "m1.medium"
}

variable "image" {
  description = "Image to use for the instance"
  type        = string
  default     = "focal-server-cloudimg-amd64"
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
  default = "~/.ssh/test.pub"
}

variable "ssh_user" {
  description = "SSH user for the instance"
  type        = string
  default     = "ubuntu"
}

variable "nova_with_volume_count" {
  default = 1
}

variable "instance_with_volume_allowed" {
  type = list(object({
    protocol         = string
    port_range_min   = number
    port_range_max   = number
    remote_ip_prefix = optional(string, "0.0.0.0/0")
  }))
  default = [
    {
      protocol       = "tcp"
      port_range_min = 3306
      port_range_max = 3306
    },
    {
      protocol       = "tcp"
      port_range_min = 22
      port_range_max = 22
    }
  ]
}