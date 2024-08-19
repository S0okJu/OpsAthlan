# ----- Keypair
resource "openstack_compute_keypair_v2" "opsathlan_keypair" {
  name       = "opsathlan-${var.scenerio_id}-keypair"
  public_key = chomp(file(var.public_key_path))
}

# ----- Security Group 
# Create a security group
resource "openstack_networking_secgroup_v2" "opsathlan_secgroup" {
  name                 = "opsathlan-${var.scenerio_id}-secugroup"
  delete_default_rules = true
}

# Security group rule
resource "openstack_networking_secgroup_rule_v2" "secgroup_rules" {
  count             = length(var.allowed_ports)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = lookup(var.allowed_ports[count.index], "protocol", "tcp")
  port_range_min    = lookup(var.allowed_ports[count.index], "port_range_min")
  port_range_max    = lookup(var.allowed_ports[count.index], "port_range_max")
  remote_ip_prefix  = lookup(var.allowed_ports[count.index], "remote_ip_prefix", "0.0.0.0/0")
  security_group_id = openstack_networking_secgroup_v2.opsathlan_secgroup.id
}

# ----- Nova Instance
resource "openstack_compute_instance_v2" "nova_instance" {
  name            = "opsathlan-${var.scenerio_id}-instance"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  security_groups = [openstack_networking_secgroup_v2.opsathlan_secgroup.name]
  key_pair        = openstack_compute_keypair_v2.opsathlan_keypair.name

  network {
    uuid = openstack_networking_subnet_v2.internal_subnet.id
  }
}

# ----- Floating IP Association
resource "openstack_compute_floatingip_associate_v2" "floating_ip_association" {
  floating_ip = var.floating_ip
  instance_id = openstack_compute_instance_v2.nova_instance.id
}

# ----- Network
resource "openstack_networking_network_v2" "opsathlan_network" {
  name                  = "opsathlan-${var.scenerio_id}-network"
  count                 = var.use_neutron == true ? 1 : 0
  admin_state_up        = true
  port_security_enabled = var.port_security_enabled
}

# Subnet for the internal network
resource "openstack_networking_subnet_v2" "internal_subnet" {
  name            = "${var.scenerio_id}-internal-subnet"
  network_id      = openstack_networking_network_v2.opsathlan_network[count.index].id
  cidr            = var.subnet_cidr
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

# ----- Router
resource "openstack_networking_router_v2" "opsathlan_router" {
  name                = "opsathlan-${var.scenerio_id}-router"
  count               = var.use_neutron == true ? 1 : 0
  admin_state_up      = true
  external_network_id = var.external_net
}

# Attach the router to the subnet
resource "openstack_networking_router_interface_v2" "router_interface" {
  count     = var.use_neutron == true ? 1 : 0
  router_id = openstack_networking_router_v2.opsathlan_router[count.index].id
  subnet_id = openstack_networking_subnet_v2.opsathlan_subnet[count.index].id
}


