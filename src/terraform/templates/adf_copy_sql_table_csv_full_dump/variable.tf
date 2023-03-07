variable "domain" {
  type = string
}
variable "environment" {
  type = string
}
variable "subdomains_index_to_name" {
  type = map(string)
}

variable "grouping" {
  type = string
}

variable "name" {
  type = string
}

variable "system_name" {
  type = string
}

variable "copy_pipeline" {
  type = object({
    name = string
  })
}

variable "tables" {
  type = list(string)
}

variable "trigger" {
  type = object({
    daily_hour_of_day     = list(number)
    daily_minutes_of_hour = list(number)
  })
}
