terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features { }
}

locals {
  location = "australiaeast"
}

resource "azurerm_resource_group" "kubectlrg" {
  name = "kubernetesrg"
  location = local.location
}

resource "azurerm_virtual_network" "kubectlvnet" {
  name = "kubernetesvnet"
  location = local.location
  resource_group_name = azurerm_resource_group.kubectlrg.name
  address_space = [ "10.240.0.0/24" ]
}
