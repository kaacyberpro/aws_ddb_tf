################################|################################|################################|################################
terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
      #configuration_aliases = [ aws.src, aws.dest ]
      configuration_aliases = [aws.prov]
    }
  }
}



################################|################################|################################|################################
resource "aws_dynamodb_table" "ddb_table" {
    provider       = aws.prov                 
    name           = var.ddb_name                           #"GameScores"
    billing_mode   = var.ddb_billing_mode                   #"PROVISIONED"
    read_capacity  = var.ddb_read_capacity                  #"20"
    write_capacity = var.ddb_write_capacity                 #"20"
    hash_key       = var.ddb_hash_key                       #"UserId"
    range_key      = var.ddb_range_key                      #"GameTitle"

    attribute {
        name = var.ddb_atribute_name_hash_key               #"UserId"
        type = var.ddb_atribute_type_hash_key               #"S"
    }

    attribute {
        name = var.ddb_atribute_name_range_key              #"GameTitle"
        type = var.ddb_atribute_type_range_key              #"S"
    }

    attribute {
        name = var.ddb_atribute_name_gsi_range_key          #"TopScore"
        type = var.ddb_atribute_type_gsi_range_key          #"N"
    }

    ttl {
        attribute_name = var.ddb_ttl_name                   #"TimeToExist"
        enabled        = var.ddb_ttl_enabled                #false
    }

    global_secondary_index {
        name               = var.ddb_gsi_name               #"GameTitleIndex"
        hash_key           = var.ddb_gsi_hash_key      #var.ddb_range_key          #"GameTitle"
        range_key          = var.ddb_gsi_range_key          #"TopScore"
        read_capacity      = var.ddb_gsi_read_capacity      #10
        write_capacity     = var.ddb_gsi_write_capacity     #10
        projection_type    = var.ddb_gsi_projection_type    #"INCLUDE"
        non_key_attributes = [var.ddb_gsi_non_key_attributes]    #[var.ddb_hash_key]
    }

    point_in_time_recovery{
        enabled = var.ddb_pit_recovery
    }

    stream_enabled = var.ddb_stream_enabled
    stream_view_type = var.ddb_stream_view_type

    server_side_encryption{
        enabled = var.ddb_sse_enabled
        kms_key_arn = var.ddb_sse_kms_key_arn
    }


    tags = {
        Name        = var.ddb_tags_name                 #"dynamodb-table-1"
        Environment = var.ddb_tags_env                  #"production"
        terraform   = true
    }
}
/*
The following arguments are supported:

    name - (Required) The name of the table, this needs to be unique within a region.
    billing_mode - (Optional) Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED.
    hash_key - (Required, Forces new resource) The attribute to use as the hash (partition) key. Must also be defined as an attribute, see below.
    range_key - (Optional, Forces new resource) The attribute to use as the range (sort) key. Must also be defined as an attribute, see below.
    write_capacity - (Optional) The number of write units for this table. If the billing_mode is PROVISIONED, this field is required.
    read_capacity - (Optional) The number of read units for this table. If the billing_mode is PROVISIONED, this field is required.
    attribute - (Required) List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties:
        name - (Required) The name of the attribute
        type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data
    ttl - (Optional) Defines ttl, has two properties, and can only be specified once:
        enabled - (Required) Indicates whether ttl is enabled (true) or disabled (false).
        attribute_name - (Required) The name of the table attribute to store the TTL timestamp in.
-    local_secondary_index - (Optional, Forces new resource) Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource.
    global_secondary_index - (Optional) Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc.
    point_in_time_recovery - (Optional) Enable point-in-time recovery options.
-    replica - (Optional) Configuration block(s) with DynamoDB Global Tables V2 (version 2019.11.21) replication configurations. Detailed below.
-    restore_source_name - (Optional) The name of the table to restore. Must match the name of an existing table.
-    restore_to_latest_time - (Optional) If set, restores table to the most recent point-in-time recovery point.
-    restore_date_time - (Optional) The time of the point-in-time recovery point to restore.
    stream_enabled - (Optional) Indicates whether Streams are to be enabled (true) or disabled (false).
    stream_view_type - (Optional) When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES.
    server_side_encryption - (Optional) Encryption at rest options. AWS DynamoDB tables are automatically encrypted at rest with an AWS owned Customer Master Key if this argument isn't specified.
-    table_class - (Optional) The storage class of the table. Valid values are STANDARD and STANDARD_INFREQUENT_ACCESS.
    tags - (Optional) A map of tags to populate on the created table. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.

Timeouts

The timeouts block allows you to specify timeouts for certain actions:

    create - (Defaults to 10 mins) Used when creating the table
    update - (Defaults to 60 mins) Used when updating the table configuration and reset for each individual Global Secondary Index and Replica update
    delete - (Defaults to 10 mins) Used when deleting the table

Nested fields
local_secondary_index

    name - (Required) The name of the index
    range_key - (Required) The name of the range key; must be defined
    projection_type - (Required) One of ALL, INCLUDE or KEYS_ONLY where ALL projects every attribute into the index, KEYS_ONLY projects just the hash and range key into the index, and INCLUDE projects only the keys specified in the non_key_attributes parameter.
    non_key_attributes - (Optional) Only required with INCLUDE as a projection type; a list of attributes to project into the index. These do not need to be defined as attributes on the table.

global_secondary_index

    name - (Required) The name of the index
    write_capacity - (Optional) The number of write units for this index. Must be set if billing_mode is set to PROVISIONED.
    read_capacity - (Optional) The number of read units for this index. Must be set if billing_mode is set to PROVISIONED.
    hash_key - (Required) The name of the hash key in the index; must be defined as an attribute in the resource.
    range_key - (Optional) The name of the range key; must be defined
    projection_type - (Required) One of ALL, INCLUDE or KEYS_ONLY where ALL projects every attribute into the index, KEYS_ONLY projects just the hash and range key into the index, and INCLUDE projects only the keys specified in the non_key_attributes parameter.
    non_key_attributes - (Optional) Only required with INCLUDE as a projection type; a list of attributes to project into the index. These do not need to be defined as attributes on the table.

replica

The replica configuration block supports the following arguments:

    region_name - (Required) Region name of the replica.
    kms_key_arn - (Optional) The ARN of the CMK that should be used for the AWS KMS encryption.

server_side_encryption

    enabled - (Required) Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK).
    kms_key_arn - (Optional) The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb.

If enabled is false then server-side encryption is set to AWS owned CMK (shown as DEFAULT in the AWS console). If enabled is true and no kms_key_arn is specified then server-side encryption is set to AWS managed CMK (shown as KMS in the AWS console). The AWS KMS documentation explains the difference between AWS owned and AWS managed CMKs.

point_in_time_recovery

    enabled - (Required) Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables. If the point_in_time_recovery block is not provided then this defaults to false.
*/