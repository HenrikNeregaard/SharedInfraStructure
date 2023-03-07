variable "domain" {
  type = string
}
variable "environment" {
  type = string
}
variable "subdomains_index_to_name" {
  type = map(string)
}

variable "name" {
  type = string
}

variable "catalog" {
  type = string
  #@TODO Add restrictions
}

variable "reader_group_member_object_ids" {
  type = list(string)
}