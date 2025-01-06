variable "vm-map" {
  type = map(object({
    pip-name = string
    resource_group_name = string
    location = string
    allocation_method = string
    nic-name = string
    ip-configuration-name = string
    private_ip_address_allocation = string
    nsg-name = string
    vm-name = string
    size = string
    admin_username = string
    admin_password = string
    
  }))
}
variable "subnet-id" {}