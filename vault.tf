resource "azurerm_key_vault" "kv" {
  name = "kube-keyvault"
  location = azurerm_resource_group.kubectlrg.location
  resource_group_name = azurerm_resource_group.kubectlrg.name
  sku_name = "standard"
  tenant_id = var.tenant_id
  public_network_access_enabled = false
}
