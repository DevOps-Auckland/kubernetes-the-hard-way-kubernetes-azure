resource "azurerm_network_interface" "kubecluster_network_interface" {
  name = var.network_interface_name
  location = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name = "internal"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Static"
    primary = true
    private_ip_address = var.private_ip
  }
  enable_ip_forwarding = true
}

resource "azurerm_linux_virtual_machine" "kubecluster" {
  name = var.vm_name
  resource_group_name = var.resource_group_name
  location = var.location
  size = "Standard_A1_v2"
  admin_username = "willem"
  admin_ssh_key {
    username = "willem"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
  os_disk {
    caching = "ReadOnly"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 200
  }
  network_interface_ids = [ azurerm_network_interface.kubecluster_network_interface.id ]
}
