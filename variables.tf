variable "rgname" {
    type = string
    description = "resource group name"
}

variable "location" {
    type = string
    default = "EastUS"
}

variable "service_principal_name" {
    type = string
}

variable "keyvault_name" {
    type = string
}


