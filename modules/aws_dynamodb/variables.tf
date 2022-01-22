################################|################################|################################|################################
variable "instance_region" {
  type    = string
  default = "us-east-1"
}

variable "ddb_name" {
    type    = string
    default = "default_example"
}
variable "ddb_billing_mode" {
    type    = string
    default = "PROVISIONED"
}
variable "ddb_read_capacity" {
    type    = number
    default = 20
}
variable "ddb_write_capacity" {
    type    = number
    default = 20
}
variable "ddb_hash_key" {
  type    = string
  default = "DataID"
}
variable "ddb_atribute_name_hash_key" {
  type    = string
  default = "DataID"
}
variable "ddb_range_key" {
  type    = string
  default = "DataTitle"
}
variable "ddb_atribute_name_range_key" {
  type    = string
  default = "DataTitle"
}
variable "ddb_gsi_hash_key" {
  type    = string
  default = "GSITitle"
}
variable "ddb_gsi_range_key" {
  type    = string
  default = "GSITitle"
}
variable "ddb_atribute_name_gsi_range_key" {
  type    = string
  default = "GSITitle"
}
variable "ddb_atribute_type_hash_key" {
  type    = string
  default = "S"
}
variable "ddb_atribute_type_range_key" {
  type    = string
  default = "S"
}
variable "ddb_atribute_type_gsi_range_key" {
  type    = string
  default = "S"
}
variable "ddb_ttl_name" {
  type    = string
  default = "ttl_timestamp"
}
variable "ddb_ttl_enabled" {
  type    = bool
  default = false
}
variable "ddb_gsi_name" {
  type    = string
  default = "DataTitleIndex"
}
variable "ddb_gsi_read_capacity" {
  type    = number
  default = 20
}
variable "ddb_gsi_write_capacity" {
  type    = number
  default = 20
}
variable "ddb_gsi_projection_type" {
  type    = string
  default = "INCLUDE"
}
variable "ddb_gsi_non_key_attributes" {
  type    = string
  default = "DataID"
}

variable "ddb_pit_recovery" {
  type    = bool
  default = false
}
variable "ddb_stream_enabled"{
  type    = bool
  default = false
}
variable "ddb_stream_view_type"{
  type    = string
  default = "KEYS_ONLY"
}
variable "ddb_sse_enabled"{
  type    = bool
  default = false
}
variable "ddb_sse_kms_key_arn"{
  type    = string
  default = null
}

variable "ddb_table_class"{
  type    = string
  default = "STANDARD"
}

variable "ddb_tags_name" {
  type    = string
  default = "default_example"
}
variable "ddb_tags_env" {
  type    = string
  default = "example"
}

