################################|################################|################################|################################
variable "profile" {
  type    = string
  default = "default"
}
variable "instance_region" {
  type    = string
  default = "us-east-1"
}

################################|################################|################################|################################
terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
      #configuration_aliases = [ aws.src, aws.dest ]
      #configuration_aliases = [aws.prov]
    }
  }
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "tfstatefile_cicd"
    bucket  = "kaatfstate"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.instance_region
  alias   = "instance_region"
}

################################|################################|################################|################################
module "aws_dynamodb"{
  providers         = { aws.prov = aws.instance_region }
  
  source            = "./modules/aws_dynamodb"

  ddb_name           = "example-1"                      # name - (Required) The name of the table, this needs to be unique within a region.
  ddb_billing_mode   = "PROVISIONED"                    # billing_mode - (Optional) Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED.
  ddb_read_capacity  = "20"                             # read_capacity - (Optional) The number of read units for this table. If the billing_mode is PROVISIONED, this field is required.
  ddb_write_capacity = "20"                             # write_capacity - (Optional) The number of write units for this table. If the billing_mode is PROVISIONED, this field is required.
  ddb_hash_key       = "data-id"                        # hash_key - (Required, Forces new resource) The attribute to use as the hash (partition) key. Must also be defined as an attribute, see below.
  ddb_range_key      = "data-name"                      # range_key - (Optional, Forces new resource) The attribute to use as the range (sort) key. Must also be defined as an attribute, see below.

#  attribute {                                           # attribute - (Required) List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties:
      ddb_atribute_name_hash_key = "data-id"            # name - (Required) The name of the attribute
      ddb_atribute_type_hash_key = "S"                  # type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data
#  }

#  attribute {
      ddb_atribute_name_range_key = "data-name"         #"GameTitle"
      ddb_atribute_type_range_key = "S"                  #
#  }

#  attribute {
      ddb_atribute_name_gsi_range_key = "data-second-name"                     #
      ddb_atribute_type_gsi_range_key = "N"                                    #
#  }

#  ttl {                                                 # ttl - (Optional) Defines ttl, has two properties, and can only be specified once:
      ddb_ttl_name = "ttl_stamp"                        # attribute_name - (Required) The name of the table attribute to store the TTL timestamp in.
      ddb_ttl_enabled  = false                          # enabled - (Required) Indicates whether ttl is enabled (true) or disabled (false).
#  }

#  global_secondary_index {                          # global_secondary_index - (Optional) Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc.
      ddb_gsi_name               = "data-gs-index"          # name - (Required) The name of the index
      ddb_gsi_hash_key           = "data-name"      # hash_key - (Required) The name of the hash key in the index; must be defined as an attribute in the resource.
      ddb_gsi_range_key          = "data-second-name" # range_key - (Optional) The name of the range key; must be defined
      ddb_gsi_read_capacity      = "20"             # read_capacity - (Optional) The number of read units for this index. Must be set if billing_mode is set to PROVISIONED.
      ddb_gsi_write_capacity     = "20"             # write_capacity - (Optional) The number of write units for this index. Must be set if billing_mode is set to PROVISIONED.
      ddb_gsi_projection_type    = "INCLUDE"        # projection_type - (Required) One of ALL, INCLUDE or KEYS_ONLY where ALL projects every attribute into the index, KEYS_ONLY projects just the hash and range key into the index, and INCLUDE projects only the keys specified in the non_key_attributes parameter.
      ddb_gsi_non_key_attributes = "data-id"      # non_key_attributes - (Optional) Only required with INCLUDE as a projection type; a list of attributes to project into the index. These do not need to be defined as attributes on the table.
#  }

#  point_in_time_recovery{                           # point_in_time_recovery - (Optional) Enable point-in-time recovery options.
      ddb_pit_recovery = false                               # enabled - (Required) Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables. If the point_in_time_recovery block is not provided then this defaults to false.
#  }

  ddb_stream_enabled = false                        # stream_enabled - (Optional) Indicates whether Streams are to be enabled (true) or disabled (false).
  ddb_stream_view_type = "KEYS_ONLY"                # stream_view_type - (Optional) When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES.

#  server_side_encryption{                           # server_side_encryption - (Optional) Encryption at rest options. AWS DynamoDB tables are automatically encrypted at rest with an AWS owned Customer Master Key if this argument isn't specified.
      ddb_sse_enabled = false                       # enabled - (Required) Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK).
      ddb_sse_kms_key_arn = null                    # kms_key_arn - (Optional) The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb.
      # If enabled is false then server-side encryption is set to AWS owned CMK (shown as DEFAULT in the AWS console). If enabled is true and no kms_key_arn is specified then server-side encryption is set to AWS managed CMK (shown as KMS in the AWS console). The AWS KMS documentation explains the difference between AWS owned and AWS managed CMKs.
#  }


#  tags = {
      ddb_tags_name        = "ddb_name"                      #
      ddb_tags_env         = "test_env"                      #
#  }
}

################################|################################|################################|################################
output "ddb_table_arn" {
    description = "arn - The arn of the table"
    value = module.aws_dynamodb.ddb_table_arn
}
output "ddb_table_id" {
    description = "id - The name of the table"
    value = module.aws_dynamodb.ddb_table_id
}
output "ddb_table_stream_arn" {
    description = "stream_arn - The ARN of the Table Stream. Only available when stream_enabled = true"
    value = module.aws_dynamodb.ddb_table_stream_arn
}
output "ddb_table_stream_label" {
    description = "stream_label - A timestamp, in ISO 8601 format, for this stream. Note that this timestamp is not a unique identifier for the stream on its own. However, the combination of AWS customer ID, table name and this field is guaranteed to be unique. It can be used for creating CloudWatch Alarms. Only available when stream_enabled = true"
    value = module.aws_dynamodb.ddb_table_stream_label
}
