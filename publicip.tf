resource "azurerm_public_ip" "kube_loadbalancer" {
  name                = "KubeLB_PublicIP"
  resource_group_name = azurerm_resource_group.kubectlrg.name
  location            = azurerm_resource_group.kubectlrg.location
  allocation_method   = "Dynamic"

  provisioner "local-exec" {
    command     = "./create_certificates.sh ${azurerm_resource_group.kubectlrg.name}"
    working_dir = "./files/scripts/"
    when        = create
  }
}
