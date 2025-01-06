rg-map = {
  rg1 = {
    name     = "dev-rg1"
    location = "uksouth"
  }
}

vnet-map = {
  vnet1 = {
    name                = "dev-vnet1"
    resource_group_name = "dev-rg1"
    location            = "uksouth"
    address_space       = ["10.0.0.0/16"]
  }
}

subnet-map = {
  subnet1 = {
    name                 = "frontend-subnet"
    resource_group_name  = "dev-rg1"
    virtual_network_name = "dev-vnet1"
    address_prefixes     = ["10.0.1.0/24"]
  }
  subnet2 = {
    name                 = "backend-subnet"
    resource_group_name  = "dev-rg1"
    virtual_network_name = "dev-vnet1"
    address_prefixes     = ["10.0.2.0/24"]
  }
}

vm-map = {

  vm1 = {
    pip-name                      = "dev-pip1"
    resource_group_name           = "dev-rg1"
    location                      = "uksouth"
    allocation_method             = "Static"
    nic-name                      = "dev-nic1"
    ip-configuration-name         = "dev-ip-configuration1"
    private_ip_address_allocation = "Dynamic"
    nsg-name                      = "dev-nsg1"
    vm-name                       = "frontend"
    size                          = "Standard_B1s"
    admin_username                = "adminuser"
    admin_password                = "Password123"

  }
  vm2 = {
    pip-name                      = "dev-pip2"
    resource_group_name           = "dev-rg1"
    location                      = "uksouth"
    allocation_method             = "Static"
    nic-name                      = "dev-nic2"
    ip-configuration-name         = "dev-ip-configuration2"
    private_ip_address_allocation = "Dynamic"
    nsg-name                      = "dev-nsg2"
    vm-name                       = "backend"
    size                          = "Standard_B1s"
    admin_username                = "adminuser"
    admin_password                = "Password123"

  }
}