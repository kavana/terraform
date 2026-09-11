provider "vsphere" {
  user                 = "tango.automation@vsphere.local"
  password             = "3kk7*08xEtmu"
  allow_unverified_ssl = true
  api_timeout          = 10
}

data "vsphere_datacenter" "datacenter" {
  name = "vcfcons-mgmt-vc03-DC"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1 (5)"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "vcfcons-vc03-cl01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 1
  memory           = 1024
  guest_id         = "otherLinux64Guest"
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = 20
  }
}
