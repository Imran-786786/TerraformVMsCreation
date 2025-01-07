output "vm-ip" {
    value={for key, v in azurerm_linux_virtual_machine.vms: key => v.public_ip_address}
}