variable "rg-map" {
  type = map(object({
    name     = string
    location = string
  }))
}