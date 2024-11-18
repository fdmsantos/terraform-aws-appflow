variable "name" {
  description = "Name of the flow."
  type        = string
}

variable "description" {
  description = "Description of the flow you want to create."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "ARN (Amazon Resource Name) of the Key Management Service (KMS) key you provide for encryption. This is required if you do not want to use the Amazon AppFlow-managed KMS key. If you don't provide anything here, Amazon AppFlow uses the Amazon AppFlow-managed KMS key."
  type        = string
  default     = null
}

variable "tasks" {
  description = "A map of objects with Flow Tasks."
  type = list(object({
    task_type          = string
    source_fields      = list(string)
    destination_field  = optional(string, null)
    task_properties    = optional(map(string), {})
    connector_operator = optional(string, null)
  }))
  default = []
}

### Glue ###
variable "enable_glue_catalog" {
  description = "Enables or disables the Glue catalog for the flow."
  type        = bool
  default     = false
}

variable "glue_database_name" {
  description = "The name of an existing Glue database to store the metadata tables that Amazon AppFlow creates."
  type        = string
  default     = null
}

variable "glue_table_name" {
  description = "A naming prefix for each Data Catalog table that Amazon AppFlow creates."
  type        = string
  default     = null
}

variable "glue_role_arn" {
  description = "The ARN of an IAM role that grants AppFlow the permissions it needs to create Data Catalog tables, databases, and partitions. Variable `create_glue_role` needs to be false."
  type        = string
  default     = null
}

##### Glue IAM Role #####
variable "create_glue_role" {
  description = "Specifies whether to create a new Glue role for the flow."
  type        = bool
  default     = true
}

variable "glue_role_name" {
  description = "Name of IAM role to use for Flow to access Glue."
  type        = string
  default     = null
}

variable "glue_role_description" {
  description = "Description of IAM role to use for Flow to access glue."
  type        = string
  default     = null
}

variable "glue_role_path" {
  description = "Path of IAM role to use for Flow to access glue."
  type        = string
  default     = null
}

variable "glue_role_force_detach_policies" {
  description = "Specifies to force detaching any policies the Glue IAM role has before destroying it."
  type        = bool
  default     = true
}

variable "glue_role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the Glue IAM role used by Flow to access glue."
  type        = string
  default     = null
}

variable "glue_role_tags" {
  description = "A map of tags to assign to Glue IAM role"
  type        = map(string)
  default     = {}
}

variable "glue_policy_path" {
  description = "Path of policies to that should be added to IAM role for Flow to access Glue IAM"
  type        = string
  default     = null
}

### Trigger ###
variable "trigger_type" {
  description = "Type of flow trigger. Valid values are Scheduled, Event, and OnDemand."
  type        = string
  default     = "OnDemand"
  validation {
    error_message = "Please use a valid type!"
    condition     = contains(["Scheduled", "Event", "OnDemand"], var.trigger_type)
  }
}

variable "trigger_schedule_expression" {
  description = "Scheduling expression that determines the rate at which the schedule will run."
  type        = string
  default     = null
}

variable "trigger_data_pull_mode" {
  description = "Whether a scheduled flow has an incremental data transfer or a complete data transfer for each flow run. Valid values are Incremental and Complete."
  type        = string
  default     = "Complete"
  validation {
    error_message = "Please use a valid pull mode!"
    condition     = contains(["Incremental", "Complete"], var.trigger_data_pull_mode)
  }
}

variable "trigger_first_execution_from" {
  description = "Date range for the records to import from the connector in the first flow run. Must be a valid RFC3339 timestamp."
  type        = string
  default     = null
}

variable "trigger_schedule_start_time" {
  description = "Scheduled start time for a schedule-triggered flow. Must be a valid RFC3339 timestamp."
  type        = string
  default     = null
}

variable "trigger_schedule_end_time" {
  description = "Scheduled end time for a schedule-triggered flow. Must be a valid RFC3339 timestamp."
  type        = string
  default     = null
}

variable "trigger_schedule_offset" {
  description = "Optional offset that is added to the time interval for a schedule-triggered flow. Maximum value of 36000."
  type        = number
  default     = null
}

variable "trigger_timezone" {
  description = "Time zone used when referring to the date and time of a scheduled-triggered flow, such as America/New_York."
  type        = string
  default     = null
}

### Source ###
variable "flow_source" {
  description = "Type of connector, such as Salesforce, Amplitude, and so on. Valid values are Salesforce, Singular, Slack, Redshift, S3, Marketo, Googleanalytics, Zendesk, Servicenow, Datadog, Trendmicro, Snowflake, Dynatrace, Infornexus, Amplitude, Veeva, EventBridge, Honeycode, SAPOData, and CustomConnector."
  type        = string
  validation {
    error_message = "Please use a valid source!"
    condition = contains([
      "Salesforce", "Singular", "Slack", "S3", "Marketo", "Googleanalytics", "Zendesk", "Servicenow",
      "Datadog", "CustomConnector", "SAPOData", "Trendmicro",
    "Infornexus", "Dynatrace", "Amplitude", "Veeva"], var.flow_source)
  }
}

variable "source_api_version" {
  description = "API version that the source connector uses."
  type        = string
  default     = null
}

variable "source_connector_profile_name" {
  description = "Name of the connector profile. This name must be unique for each connector profile in the AWS account."
  type        = string
  default     = null
}

variable "enable_incremental_pull" {
  description = "Set it to true to enable incremental pull."
  type        = bool
  default     = false
}

variable "datetime_type_field_name" {
  description = "Field that specifies the date time or timestamp field as the criteria to use when importing incremental records from the source."
  type        = string
  default     = null
}

variable "source_s3_properties" {
  description = "S3 Source Properties."
  type = object({
    bucket_name   = string
    bucket_prefix = optional(string, null)
    file_type     = optional(string, null)
  })
  default = null
}

variable "source_amplitude_properties" {
  description = "Amplitude Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_datadog_properties" {
  description = "Datadog Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_dynatrace_properties" {
  description = "Dynatrace Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_google_analytics_properties" {
  description = "Google Analytics Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_infor_nexus_properties" {
  description = "Infor Nexus Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_marketo_properties" {
  description = "Marketo Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_servicenow_properties" {
  description = "ServiceNow Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_singular_properties" {
  description = "Singular Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_trend_micro_properties" {
  description = "Trend Micro Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_zendesk_properties" {
  description = "ZendDesk Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_slack_properties" {
  description = "Slack Source Properties."
  type = object({
    object = string
  })
  default = null
}

variable "source_custom_connector_properties" {
  description = "Custom Connector Source Properties."
  type = object({
    entity_name       = string
    custom_properties = optional(map(string), {})
  })
  default = null
}

variable "source_salesforce_properties" {
  description = "SalesForce Source Properties."
  type = object({
    object                      = string
    enable_dynamic_field_update = optional(bool, null)
    include_deleted_records     = optional(bool, null)
  })
  default = null
}

variable "source_sapo_data_properties" {
  description = "Sapo Data Source Properties."
  type = object({
    object_path     = string
    max_page_size   = optional(number, null)
    max_parallelism = optional(number, null)
  })
  default = null
}

variable "source_veeva_properties" {
  description = "Veeva Source Properties."
  type = object({
    object               = string
    document_type        = optional(string, null)
    include_all_versions = optional(bool, null)
    include_renditions   = optional(bool, null)
    include_source_files = optional(bool, null)
  })
  default = null
}

### Destination ###
variable "destination" {
  description = "Type of connector, such as Salesforce, Amplitude, and so on. Valid values are Salesforce, Singular, Slack, Redshift, S3, Marketo, Googleanalytics, Zendesk, Servicenow, Datadog, Trendmicro, Snowflake, Dynatrace, Infornexus, Amplitude, Veeva, EventBridge, LookoutMetrics, Upsolver, Honeycode, CustomerProfiles, SAPOData, and CustomConnector."
  type        = string
  validation {
    error_message = "Please use a valid destination!"
    condition = contains([
      "Salesforce", "Redshift", "S3", "Marketo", "Zendesk", "Snowflake",
      "EventBridge", "Upsolver", "Honeycode", "CustomerProfiles", "SAPOData", "CustomConnector"
    ], var.destination)
  }
}

variable "destination_api_version" {
  description = "API version that the destination connector uses."
  type        = string
  default     = null
}

variable "destination_connector_profile_name" {
  description = "Name of the connector profile. This name must be unique for each connector profile in the AWS account."
  type        = string
  default     = null
}

variable "destination_s3_properties" {
  description = "S3 Destination Properties."
  type = object({
    bucket_name                 = string
    bucket_prefix               = optional(string, null)
    file_type                   = optional(string, null)
    preserve_source_data_typing = optional(bool, false)
    prefix_format               = optional(string, null)
    prefix_type                 = optional(string, null)
    prefix_hierarchy            = optional(list(string), [])
    aggregation_type            = optional(string, "None")
    target_file_size            = optional(number, null)
  })
  default = null
}

variable "destination_event_bridge_properties" {
  description = "Event Bridge Destination Properties."
  type = object({
    object              = string
    error_bucket_name   = optional(string, null)
    error_bucket_prefix = optional(string, null)
    fail_on_first_error = optional(bool, true)
  })
  default = null
}

variable "destination_honeycode_properties" {
  description = "Honey Code Destination Properties."
  type = object({
    object              = string
    error_bucket_name   = optional(string, null)
    error_bucket_prefix = optional(string, null)
    fail_on_first_error = optional(bool, true)
  })
  default = null
}

variable "destination_marketo_properties" {
  description = "Marketo Destination Properties."
  type = object({
    object              = string
    error_bucket_name   = optional(string, null)
    error_bucket_prefix = optional(string, null)
    fail_on_first_error = optional(bool, true)
  })
  default = null
}

variable "destination_redshift_properties" {
  description = "Redshift Destination Properties."
  type = object({
    object                     = string
    intermediate_bucket_name   = string
    intermediate_bucket_prefix = optional(string, null)
    error_bucket_name          = optional(string, null)
    error_bucket_prefix        = optional(string, null)
    fail_on_first_error        = optional(bool, true)
  })
  default = null
}

variable "destination_salesforce_properties" {
  description = "Salesforce Destination Properties."
  type = object({
    object               = string
    id_field_names       = optional(list(string), [])
    write_operation_type = optional(string, null)
    error_bucket_name    = optional(string, null)
    error_bucket_prefix  = optional(string, null)
    fail_on_first_error  = optional(bool, true)
  })
  default = null
}

variable "destination_sapo_data_properties" {
  description = "Sapo Data Destination Properties."
  type = object({
    object_path           = string
    id_field_names        = optional(list(string), [])
    write_operation_type  = optional(string, null)
    success_bucket_name   = optional(string, null)
    success_bucket_prefix = optional(string, null)
    error_bucket_name     = optional(string, null)
    error_bucket_prefix   = optional(string, null)
    fail_on_first_error   = optional(bool, true)
  })
  default = null
}

variable "destination_snowflake_properties" {
  description = "Snowflake Destination Properties."
  type = object({
    object                     = string
    intermediate_bucket_name   = string
    intermediate_bucket_prefix = optional(string, null)
    error_bucket_name          = optional(string, null)
    error_bucket_prefix        = optional(string, null)
    fail_on_first_error        = optional(bool, true)
  })
  default = null
}

variable "destination_upsolver_properties" {
  description = "Upsolver Destination Properties."
  type = object({
    bucket_name      = string
    bucket_prefix    = optional(string, null)
    file_type        = optional(string, null)
    prefix_format    = optional(string, null)
    prefix_type      = optional(string, null)
    prefix_hierarchy = optional(list(string), [])
    aggregation_type = optional(string, "None")
  })
  default = null
}

variable "destination_zendesk_properties" {
  description = "Zendesk Destination Properties."
  type = object({
    object               = string
    id_field_names       = optional(list(string), [])
    write_operation_type = optional(string, null)
    error_bucket_name    = optional(string, null)
    error_bucket_prefix  = optional(string, null)
    fail_on_first_error  = optional(bool, true)
  })
  default = null
}

variable "destination_custom_connector_properties" {
  description = "Custom Connector Destination Properties."
  type = object({
    entity_name          = string
    custom_properties    = optional(map(string), {})
    id_field_names       = optional(list(string), [])
    write_operation_type = optional(string, null)
    error_bucket_name    = optional(string, null)
    error_bucket_prefix  = optional(string, null)
    fail_on_first_error  = optional(bool, true)
  })
  default = null
}

variable "destination_custom_profile_properties" {
  description = "Custom Connector Destination Properties."
  type = object({
    domain_name      = string
    object_type_name = optional(string, null)
  })
  default = null
}