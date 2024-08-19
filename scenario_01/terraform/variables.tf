variable "scenario_id" {
  description = "Identifier for the scenario, used to uniquely name resources."
  type        = string
  default     = "01"
}

variable "image_name" {
  description = "The name of the image to use for the instance."
  type        = string
  default     = "focal-server-cloudimg-amd64"
}

variable "flavor_name" {
  description = "The flavor to use for the instance."
  type        = string
  default     = "m1.medium"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet."
  type        = string
}

variable "port_security_enabled" {
  description = "Enable or disable port security on the network."
  type        = bool
  default     = true
}

variable "allowed_ports" {
  description = "List of maps defining allowed ports for the security group. Each map should include protocol, port_range_min, port_range_max, and optionally remote_ip_prefix."
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
    }
  ]
}

variable "pubkey_file_path" {
  type    = string
  default = "./ed.test.pub"
}
