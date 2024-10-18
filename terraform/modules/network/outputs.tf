output "network_id" {
  value = openstack_networking_network_v2.network_network.id
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.network_subnet.id
}

output "router_id" {
  value = openstack_networking_router_v2.network_router.id
}

output "floating_ip" {
  value = openstack_networking_floatingip_v2.floating_ip
}