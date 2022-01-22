################################|################################|################################|################################
output "ddb_table_arn" {
    description = "arn - The arn of the table"
    value = aws_dynamodb_table.ddb_table.arn
}
output "ddb_table_id" {
    description = "id - The name of the table"
    value = aws_dynamodb_table.ddb_table.id
}
output "ddb_table_stream_arn" {
    description = "stream_arn - The ARN of the Table Stream. Only available when stream_enabled = true"
    value = aws_dynamodb_table.ddb_table.stream_arn
}
output "ddb_table_stream_label" {
    description = "stream_label - A timestamp, in ISO 8601 format, for this stream. Note that this timestamp is not a unique identifier for the stream on its own. However, the combination of AWS customer ID, table name and this field is guaranteed to be unique. It can be used for creating CloudWatch Alarms. Only available when stream_enabled = true"
    value = aws_dynamodb_table.ddb_table.stream_label
}