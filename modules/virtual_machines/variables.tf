variable "vm_name" {
  type = string
  description = "The Name of the VM you want to create."
  nullable = false
}

variable "network_interface_name" {
  type = string
  description = "The name of the network interface that needs to be attached to the VM."
  nullable = false
}

variable "location" {
  type = string
  nullable = false
}

variable "resource_group_name" {
  type = string
  nullable = false
}

variable "subnet_id" {
  type = string
  nullable = false
}

variable "private_ip" {
  type = string
  nullable = false
}
