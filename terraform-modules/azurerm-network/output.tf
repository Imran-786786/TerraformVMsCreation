output "vnet-output" {
  value =  {for key, v in azurerm_virtual_network.vnet : key => v.id}
}
    
output "subnet-output" {
  value = {for key, v in azurerm_subnet.subnet : key => v.id}
  
}


