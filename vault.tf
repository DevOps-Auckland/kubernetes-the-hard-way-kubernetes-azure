resource "azurerm_key_vault" "kv" {
  name                          = "kube-keyvault"
  location                      = azurerm_resource_group.kubectlrg.location
  resource_group_name           = azurerm_resource_group.kubectlrg.name
  sku_name                      = "standard"
  tenant_id                     = var.tenant_id
  public_network_access_enabled = false

  provisioner "local-exec" {
    working_dir = "./files/scripts/"
    command = "./merge_certs.sh"
  }
}

resource "azurerm_key_vault_certificate" "kube_certs" {
  for_each = fileset(path.module,"/files/certs/kv-*.pem")
  name = each.key
  key_vault_id = azurerm_key_vault.kv.id
  certificate {
    contents = filebase64("${path.module}/files/certs/${each.key}")
    password = ""
  }
}
