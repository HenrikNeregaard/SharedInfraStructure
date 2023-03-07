
variable "resource_group_name" {
  type = string
}

variable "storage_access_tier" {
  type = string
}

variable "readers" {
  type    = map(string)
  default = {}
}

variable "contributors" {
  type    = map(string)
  default = {}
}

variable "owners" {
  type    = map(string)
  default = {}
}

variable "containers" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ip_rules" {
  type = list(string)
}

variable "storage_account_name" {
  type = string
}