resource "azurerm_public_ip" "pip" {
  for_each            = var.vm-map
  name                = each.value.pip-name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vm-map
  name                = each.value.nic-name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  ip_configuration {
    name                          = each.value.ip-configuration-name
    subnet_id                     = var.subnet-id
    private_ip_address_allocation = each.value.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.vm-map
  name                = each.value.nsg-name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  security_rule {
    name                       = "nsgrule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each = var.vm-map
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each              = var.vm-map
  name                  = each.value.vm-name
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  size                  = each.value.size
  admin_username        = each.value.admin_username
  admin_password        = each.value.admin_password
  disable_password_authentication = "false"
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

