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

resource "azurerm_network_security_group" "allow_internal" {
  name                = "kubernetes-the-hard-way-allow-internal"
  location            = local.location
  resource_group_name = azurerm_resource_group.kubectlrg.name
  security_rule = [ ]
}

resource "azurerm_network_security_rule" "inbound_tcp_rule" {
    name                         = "icp_rule"
    resource_group_name = azurerm_resource_group.kubectlrg.name
    network_security_group_name = azurerm_network_security_group.allow_internal.name
    description                  = "TCP is a protocol used in HTTP to make sure packets are delivered."
    direction                    = "Inbound"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = [22, 6443]
    source_address_prefixes      = ["10.240.0.0/24", "10.200.0.0/16"]
    destination_address_prefixes = ["10.240.0.0/24", "10.200.0.0/16"]
    access                       = "Allow"
    priority                     = 100
}
