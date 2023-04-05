resource "azurerm_public_ip" "bastionpublicip" {
  name                = "bastionIP"
  location            = azurerm_resource_group.kubectlrg.location
  resource_group_name = azurerm_resource_group.kubectlrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_subnet" "bastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.kubectlrg.name
  virtual_network_name = azurerm_virtual_network.kubectlvnet.name
  address_prefixes     = ["10.240.1.0/28"]
}

resource "azurerm_bastion_host" "bastion" {
  name                = "kubebastion"
  location            = azurerm_resource_group.kubectlrg.location
  resource_group_name = azurerm_resource_group.kubectlrg.name

  ip_configuration {
    name                 = "publicIP"
    subnet_id            = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastionpublicip.id
  }
}
