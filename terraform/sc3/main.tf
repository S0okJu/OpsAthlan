variable "project_name" { default = "OpsAthlan-03" }
variable "image" { default = "focal-server-cloudimg-amd64" }
variable "flavor" { default = "m1.medium" }
variable "public_key" { default = "~/.ssh/test.pub" }
variable "volume_size" { default = 1 }
variable "network_name" { default = "OpsAthlan-03-subnet" }
variable "subnet_cidr" { default = "10.0.4.0/24" }
variable "external_network_id" { default = "050492c9-9a56-48f2-a3a4-942e658d60a0" }

# 1. Networking
resource "openstack_networking_network_v2" "network" {
  name = "${var.project_name}-network"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = "${var.project_name}-subnet"
  network_id = openstack_networking_network_v2.network.id
  cidr       = var.subnet_cidr
  ip_version = 4
}

resource "openstack_networking_router_v2" "router" {
  name                = "${var.project_name}-router"
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

# 2. Security Group for Single Nova Instance
resource "openstack_networking_secgroup_v2" "web_secgroup" {
  name        = "${var.project_name}-web-secgroup"
  description = "Allow SSH and web traffic"
}

resource "openstack_networking_secgroup_rule_v2" "web_secgroup_rules" {
  count             = 2
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = element([22, 8080], count.index)
  port_range_max    = element([22, 8080], count.index)
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web_secgroup.id
}

# 3. Security Group for MySQL Nova Instance
resource "openstack_networking_secgroup_v2" "db_secgroup" {
  name        = "${var.project_name}-db-secgroup"
  description = "Allow SSH and MySQL traffic"
}

resource "openstack_networking_secgroup_rule_v2" "db_secgroup_rules" {
  count             = 2
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = element([22, 3306], count.index)
  port_range_max    = element([22, 3306], count.index)
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.db_secgroup.id
}

# 4. Keypair
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.project_name}-keypair"
  public_key = file(var.public_key)
}

# 5. Block Storage Volume for MySQL Instance
resource "openstack_blockstorage_volume_v3" "db_volume" {
  name = "${var.project_name}-db-volume"
  size = var.volume_size
}

# 6. Networking Port for Instances
resource "openstack_networking_port_v2" "web_port" {
  name              = "${var.project_name}-web-port"
  network_id        = openstack_networking_network_v2.network.id
  security_group_ids = [openstack_networking_secgroup_v2.web_secgroup.id]

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet.id
  }
}

resource "openstack_networking_port_v2" "db_port" {
  name              = "${var.project_name}-db-port"
  network_id        = openstack_networking_network_v2.network.id
  security_group_ids = [openstack_networking_secgroup_v2.db_secgroup.id]

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet.id
  }
}

# 7. Floating IP for Web Instance
resource "openstack_networking_floatingip_v2" "web_floating_ip" {
  pool = "public"  # Replace with the actual name of your floating IP pool if different
}

resource "openstack_networking_floatingip_associate_v2" "web_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.web_floating_ip.address
  port_id     = openstack_networking_port_v2.web_port.id
}

# Floating IP for MySQL (DB) Instance
resource "openstack_networking_floatingip_v2" "db_floating_ip" {
  pool = "public"  # Replace with the actual name of your floating IP pool if different
}

resource "openstack_networking_floatingip_associate_v2" "db_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.db_floating_ip.address
  port_id     = openstack_networking_port_v2.db_port.id
}

# 8. Single Nova Instance (Web Server)
resource "openstack_compute_instance_v2" "web_instance" {
  name            = "${var.project_name}-web-instance"
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.keypair.name

  network {
    port = openstack_networking_port_v2.web_port.id
  }

  metadata = {
    ssh_user = "ubuntu"
  }
}

# 9. Nova Instance with Volume (MySQL Server)
resource "openstack_compute_instance_v2" "db_instance" {
  name            = "${var.project_name}-db-instance"
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.keypair.name

  network {
    port = openstack_networking_port_v2.db_port.id
  }

  metadata = {
    ssh_user = "ubuntu"
  }
}

# 10. Attach Volume to MySQL Instance
resource "openstack_compute_volume_attach_v2" "db_volume_attach" {
  instance_id = openstack_compute_instance_v2.db_instance.id
  volume_id   = openstack_blockstorage_volume_v3.db_volume.id
}
