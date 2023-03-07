
variable "sql_server_url" {
  type = string
}
variable "sql_server_database_name" {
  type = string
}
variable "sql_username" {
  type = string
}
variable "sql_password_keyvault_name" {
  type = string
}
variable "integration_runtime_name" {
  type = string
}
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

variable "grouping" {

}