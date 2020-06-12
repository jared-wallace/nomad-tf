provider "libvirt" {
  alias = "nomad1"
  uri = "qemu:///session"
}

resource "libvirt_pool" "nomad-pool" {
  name = "nomad-pool"
  type = "dir"
  path = "/home/jarwallace/disk-images"
}

data "template_file" "user_data" {
  template = file("cloud_init.cfg")
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

resource "libvirt_volume" "nomad1-volume" {
  name = "nomad1.qcow2"
  pool = libvirt_pool.nomad-pool.name
  source = "https://cloud-images.ubuntu.com/focal/20200611/focal-server-cloudimg-amd64.img"
}

resource "libvirt_volume" "nomad2-volume" {
  name = "nomad2.qcow2"
  pool = libvirt_pool.nomad-pool.name
  source = "https://cloud-images.ubuntu.com/focal/20200611/focal-server-cloudimg-amd64.img"
}

resource "libvirt_domain" "nomad1" {
  name   = "nomad1"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.nomad1-volume.id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}

resource "libvirt_domain" "nomad2" {
  name   = "nomad2"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.nomad2-volume.id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
