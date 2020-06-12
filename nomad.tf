provider "libvirt" {
  alias = "nomad1"
  uri = "qemu:///session"
}

data "template_file" "user_data" {
  template = file("cloud_init.cfg")
}

data "template_file" "puppet_data" {
  template = file("cloud_init_puppet.cfg")
}

data "template_file" "network_config" {
  template = file("network_config.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.nomad-pool.name
}

resource "libvirt_cloudinit_disk" "puppetinit" {
  name           = "puppetinit.iso"
  user_data      = data.template_file.puppet_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.nomad-pool.name
}
