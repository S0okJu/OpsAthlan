# Floating ip
data "openstack_networking_network_v2" "ext_network" {
  name = var.ext_network_name
}

resource "openstack_networking_network_v2" "network_network" {
  name                  = "${var.project_name}-network"
  admin_state_up        = true
  port_security_enabled = var.port_security_enabled
}

# Floating ip
resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = data.openstack_networking_network_v2.ext_network.name
}

# 3.1 Subnet 생성
resource "openstack_networking_subnet_v2" "network_subnet" {
  name            = "${var.project_name}-subnet"
  network_id      = openstack_networking_network_v2.network_network.id
  cidr            = var.subnet_cidr
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

# 3.2 Router 생성
resource "openstack_networking_router_v2" "network_router" {
  name                = "${var.project_name}-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_network.id
}

# 3.3 Router Interface 생성
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.network_router.id
  subnet_id = openstack_networking_subnet_v2.network_subnet.id
}
