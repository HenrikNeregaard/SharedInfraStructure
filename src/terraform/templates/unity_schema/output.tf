

# output "schema" {
#   value = databricks_schema.base
# }
# output "schema_name" {
#   value = databricks_schema.base.name
# }

output "reader_group" {
  value = local.ad_group_reader
}
output "writer_group" {
  value = local.ad_group_writer
}