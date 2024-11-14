variable "location" {
}

variable "resource_group_name" {
}

variable "client_id" {
}

variable "client_secret" {
    type = string
    sensitive = true
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}