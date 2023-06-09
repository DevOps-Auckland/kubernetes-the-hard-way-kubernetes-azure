terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.49.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  location = "australiaeast"
}

resource "azurerm_resource_group" "kubectlrg" {
  name     = "kubernetesrg"
  location = local.location
}

resource "azurerm_virtual_network" "kubectlvnet" {
  name                = "kubernetesvnet"
  location            = local.location
  resource_group_name = azurerm_resource_group.kubectlrg.name
  address_space       = ["10.240.0.0/20"]
}

resource "azurerm_subnet" "kubesubnet" {
  name                 = "kubernetes"
  resource_group_name  = azurerm_resource_group.kubectlrg.name
  virtual_network_name = azurerm_virtual_network.kubectlvnet.name
  address_prefixes     = ["10.240.0.0/24"]
}

resource "azurerm_network_security_group" "kubernetes_subnet_security" {
  name                = "kubernetes-the-hard-way-allow-internal"
  location            = local.location
  resource_group_name = azurerm_resource_group.kubectlrg.name
  security_rule = [
    {
      access                     = "Allow"
      description                = ""
      destination_address_prefix = ""
      destination_address_prefixes = [
        "10.200.0.0/16",
        "10.240.0.0/24",
      ]
      destination_application_security_group_ids = []
      destination_port_range                     = ""
      destination_port_ranges = [
        "22",
        "6443",
      ]
      direction                             = "Inbound"
      name                                  = "external_tcp"
      priority                              = 300
      protocol                              = "Tcp"
      source_address_prefix                 = ""
      source_address_prefixes               = ["10.240.1.0/28", "122.60.7.3/32"]
      source_application_security_group_ids = []
      source_port_range                     = "*"
      source_port_ranges                    = []
    },
    {
      access                     = "Allow"
      description                = ""
      destination_address_prefix = ""
      destination_address_prefixes = [
        "10.200.0.0/16",
        "10.240.0.0/24",
      ]
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "Icmp_rule"
      priority                                   = 102
      protocol                                   = "Icmp"
      source_address_prefix                      = ""
      source_address_prefixes = [
        "10.200.0.0/16",
        "10.240.0.0/24",
      ]
      source_application_security_group_ids = []
      source_port_range                     = "*"
      source_port_ranges                    = []
    },
    {
      access                     = "Allow"
      description                = ""
      destination_address_prefix = ""
      destination_address_prefixes = [
        "10.200.0.0/16",
        "10.240.0.0/24",
      ]
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "Tcp_rule"
      priority                                   = 100
      protocol                                   = "Tcp"
      source_address_prefix                      = ""
      source_address_prefixes = [
        "10.200.0.0/16",
        "10.240.0.0/24",
      ]
      source_application_security_group_ids = []
      source_port_range                     = "*"
      source_port_ranges                    = []
    },
    {
      access                     = "Allow"
      description                = ""
      destination_address_prefix = ""
      destination_address_prefixes = [
        "10.200.0.0/16",
        "10.240.0.0/24",
      ]
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "Udp_rule"
      priority                                   = 101
      protocol                                   = "Udp"
      source_address_prefix                      = ""
      source_address_prefixes = [
        "10.200.0.0/16",
        "10.240.0.0/24",
      ]
      source_application_security_group_ids = []
      source_port_range                     = "*"
      source_port_ranges                    = []
    },
    {
      access                     = "Allow"
      description                = ""
      destination_address_prefix = ""
      destination_address_prefixes = [
        "10.200.0.0/16",
        "10.240.0.0/24",
      ]
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "external_icmp"
      priority                                   = 301
      protocol                                   = "Icmp"
      source_address_prefix                      = "122.60.7.3/32"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
  }, ]
}

resource "azurerm_subnet_network_security_group_association" "sg_association" {
  subnet_id                 = azurerm_subnet.kubesubnet.id
  network_security_group_id = azurerm_network_security_group.kubernetes_subnet_security.id
}

module "kubecluster" {
  for_each               = toset(["1", "2", "3"])
  source                 = "./modules/virtual_machines"
  vm_name                = join("", ["controller-", each.key])
  network_interface_name = join("", ["kubernetes-cluster-nic-", each.key])
  location               = azurerm_resource_group.kubectlrg.location
  resource_group_name    = azurerm_resource_group.kubectlrg.name
  subnet_id              = azurerm_subnet.kubesubnet.id
  private_ip             = format("10.240.0.1%s", each.key)
}

module "kubeworkers" {
  for_each               = toset(["1", "2", "3"])
  source                 = "./modules/virtual_machines"
  vm_name                = join("", ["worker-", each.key])
  network_interface_name = join("", ["worker-nic-", each.key])
  location               = azurerm_resource_group.kubectlrg.location
  resource_group_name    = azurerm_resource_group.kubectlrg.name
  subnet_id              = azurerm_subnet.kubesubnet.id
  private_ip             = format("10.240.0.2%s", each.key)
}
