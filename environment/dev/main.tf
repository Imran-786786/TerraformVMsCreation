module "rg-module" {
  source = "../../terraform-modules/azurerm-rg"
  rg-map = var.rg-map
}

module "network-module" {
  source     = "../../terraform-modules/azurerm-network"
  depends_on = [ module.rg-module ]
  vnet-map   = var.vnet-map
  subnet-map = var.subnet-map
}

module "vm-module" {
  source    = "../../terraform-modules/azurerm-vms"
  depends_on = [ module.rg-module, module.network-module ]
  vm-map    = var.vm-map
  subnet-id = module.network-module.subnet-output["subnet1"]
  }