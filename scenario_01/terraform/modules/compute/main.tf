# keypair
resource "openstack_compute_keypair_v2" "k8s" {
  name       = "opsathlan-${var.scenerio_id}-keypair"
  public_key = chomp(file(var.public_key_path))
}

resource "openstack_networking_secgroup_v2" "k8s_master" {
  name                 = "${var.cluster_name}-k8s-master"
  description          = "${var.cluster_name} - Kubernetes Master"
  delete_default_rules = true
}

