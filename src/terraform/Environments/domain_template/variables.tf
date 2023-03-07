
variable "environment" {
  type = string
}

variable "domain" {
  type = string
}

variable "subdomain_index_to_name" {
  type = map(string)
}

variable "domain_subscription_id" {
  type = string
}

variable "admin_plane_subscription_id" {
  type = string
}

