Terraform Repository for VM Creation in Subnets

This repository demonstrates how to create Azure Virtual Machines (VMs) in specific subnets using Terraform. The configuration leverages map variables, outputs, and values assigned from .tfvars files to dynamically assign resources.

Repository Structure

.
├── main.tf                  # Main Terraform configuration file
├── variables.tf             # Input variable definitions
├── outputs.tf               # Output definitions
├── terraform.tfvars         # Variable values (user-provided)
├── modules/
│   ├── network-module/      # Module for creating VNETs and subnets
│   └── vm-module/           # Module for creating VMs and associated resources

Features

Dynamic Subnet Assignment:

Subnets are created in the network-module.

Subnet IDs are passed as outputs to the vm-module for NIC association.

Modular Design:

Separate modules for networking and VM creation.

Reusable and scalable structure.

Map Variables:

Map variables in terraform.tfvars define VM configurations dynamically.

Output Utilization:

Outputs from the network-module are used to reference subnet IDs in the vm-module.

How It Works

1. Define Variables

In variables.tf:

variable "vm-map" {
  type = map(object({
    vm-name                     = string
    nic-name                    = string
    pip-name                    = string
    resource_group_name         = string
    location                    = string
    private_ip_address_allocation = string
  }))
}

variable "subnet-output" {
  description = "Subnet outputs from the network module"
  type        = map(string)
}

2. Provide Values in terraform.tfvars

vm-map = {
  vm1 = {
    vm-name                     = "vm1"
    nic-name                    = "vm1-nic"
    pip-name                    = "vm1-pip"
    resource_group_name         = "my-resource-group"
    location                    = "uksouth"
    private_ip_address_allocation = "Dynamic"
  }
  vm2 = {
    vm-name                     = "vm2"
    nic-name                    = "vm2-nic"
    pip-name                    = "vm2-pip"
    resource_group_name         = "my-resource-group"
    location                    = "uksouth"
    private_ip_address_allocation = "Dynamic"
  }
}

3. Network Module

In modules/network-module/outputs.tf:

output "subnet-output" {
  value = {
    subnet1 = azurerm_subnet.subnet1.id
    subnet2 = azurerm_subnet.subnet2.id
  }
}

4. VM Module

In modules/vm-module/main.tf:

resource "azurerm_network_interface" "nic" {
  for_each            = var.vm-map
  name                = each.value.nic-name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet-output[each.key]
    private_ip_address_allocation = each.value.private_ip_address_allocation
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = var.vm-map
  name                  = each.value.vm-name
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  size                  = "Standard_B2s"

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

5. Main Configuration

In main.tf:

module "network-module" {
  source = "./modules/network-module"
}

module "vm-module" {
  source      = "./modules/vm-module"
  vm-map      = var.vm-map
  subnet-output = module.network-module.subnet-output
}

Usage

Initialize Terraform:

terraform init

Plan Changes:

terraform plan

Apply Configuration:

terraform apply

Outputs

The repository outputs the created VM details and subnet IDs:

output "vm-details" {
  value = {
    for vm in azurerm_linux_virtual_machine.vm : vm.name => {
      id = vm.id
      ip = vm.public_ip_address
    }
  }
}

Notes

Ensure proper Azure credentials are configured.

The subnet-output map keys must match the VM map keys.

Modify the .tfvars file to add or update VM configurations.
