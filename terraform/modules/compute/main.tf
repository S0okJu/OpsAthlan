data "openstack_images_image_v2" "vm_image" {
  most_recent = true
  name = var.image
}

resource "openstack_compute_keypair_v2" "instance_keypair" {
  name       = "${var.project_name}-keypair"
  public_key = file(var.pubkey_file_path)
}

# 2. Security Group
resource "openstack_networking_secgroup_v2" "instance_secgroup" {
  name                 = "${var.project_name}-secgroup"
  description          = "${var.project_name} Security Group"
  delete_default_rules = false
}

# 2.1 Security Group Rule 생성
resource "openstack_networking_secgroup_rule_v2" "secgroup_rules" {
  count             = length(var.allowed_ports)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = lookup(var.allowed_ports[count.index], "protocol", "tcp")
  port_range_min    = lookup(var.allowed_ports[count.index], "port_range_min")
  port_range_max    = lookup(var.allowed_ports[count.index], "port_range_max")
  remote_ip_prefix  = lookup(var.allowed_ports[count.index], "remote_ip_prefix", "0.0.0.0/0")
  security_group_id = openstack_networking_secgroup_v2.instance_secgroup.id
}

# 4. Nova Instance 생성

resource "openstack_networking_port_v2" "networking_port" {
  name = "${var.project_name}-port"
  network_id = var.network_network

  depends_on = [
    var.network_router_id
  ]
}

resource "openstack_compute_instance_v2" "nova_instance" {
  name            = "${var.project_name}-instance"
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.instance_keypair.name
  security_groups = [openstack_networking_secgroup_v2.instance_secgroup.name]

  network {
    port = openstack_networking_port_v2.networking_port.id
  }

    metadata = {
      ssh_user = var.ssh_user
      depends_on = var.network_router_id
    }
}

resource "openstack_compute_floatingip_associate_v2" "floating_ip_association" {
  floating_ip = var.floating_ip.address
  instance_id = openstack_compute_instance_v2.nova_instance.id
}
