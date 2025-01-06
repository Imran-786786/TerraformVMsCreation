variable "vnet-map" {
  type = map(object({
    name = string
    resource_group_name = string
    location = string
    address_space = list(string)
  }))
}

variable "subnet-map" {
    type=map(object({
        name=string
        resource_group_name=string
        virtual_network_name=string
        address_prefixes=list(string)
    }))
  
}