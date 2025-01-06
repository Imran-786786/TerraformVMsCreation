resource "azurerm_virtual_network" "vnet" {
    for_each = var.vnet-map
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  location = each.value.location
  address_space = each.value.address_space
}

resource "azurerm_subnet" "subnet" {
  depends_on = [ azurerm_virtual_network.vnet ]
    for_each = var.subnet-map
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes = each.value.address_prefixes
}