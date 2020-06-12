resource "libvirt_pool" "nomad-pool" {
  name = "nomad-pool"
  type = "dir"
  path = "/home/jarwallace/disk-images"
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
