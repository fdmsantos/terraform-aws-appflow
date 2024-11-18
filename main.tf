resource "aws_appflow_flow" "this" {
  name        = var.name
  description = var.description
  kms_arn     = var.kms_key_arn

  source_flow_config {
    connector_type         = var.flow_source
    api_version            = var.source_api_version
    connector_profile_name = var.source_connector_profile_name
    dynamic "incremental_pull_config" {
      for_each = var.enable_incremental_pull ? [1] : []
      content {
        datetime_type_field_name = var.datetime_type_field_name
      }
    }
    source_connector_properties {
      dynamic "s3" {
        for_each = var.flow_source == "S3" ? [1] : []
        content {
          bucket_name   = var.source_s3_properties.bucket_name
          bucket_prefix = var.source_s3_properties.bucket_prefix
          dynamic "s3_input_format_config" {
            for_each = var.source_s3_properties.file_type != null ? [1] : []
            content {
              s3_input_file_type = var.source_s3_properties.file_type
            }
          }
        }
      }
      dynamic "amplitude" {
        for_each = var.flow_source == "Amplitude" ? [1] : []
        content {
          object = var.source_amplitude_properties.object
        }
      }
      dynamic "datadog" {
        for_each = var.flow_source == "Datadog" ? [1] : []
        content {
          object = var.source_datadog_properties.object
        }
      }
      dynamic "dynatrace" {
        for_each = var.flow_source == "Dynatrace" ? [1] : []
        content {
          object = var.source_dynatrace_properties.object
        }
      }
      dynamic "google_analytics" {
        for_each = var.flow_source == "Googleanalytics" ? [1] : []
        content {
          object = var.source_google_analytics_properties.object
        }
      }
      dynamic "infor_nexus" {
        for_each = var.flow_source == "Infornexus" ? [1] : []
        content {
          object = var.source_infor_nexus_properties.object
        }
      }
      dynamic "marketo" {
        for_each = var.flow_source == "Marketo" ? [1] : []
        content {
          object = var.source_marketo_properties.object
        }
      }
      dynamic "service_now" {
        for_each = var.flow_source == "Servicenow" ? [1] : []
        content {
          object = var.source_servicenow_properties.object
        }
      }
      dynamic "singular" {
        for_each = var.flow_source == "Singular" ? [1] : []
        content {
          object = var.source_singular_properties.object
        }
      }
      dynamic "trendmicro" {
        for_each = var.flow_source == "Trendmicro" ? [1] : []
        content {
          object = var.source_trend_micro_properties.object
        }
      }
      dynamic "zendesk" {
        for_each = var.flow_source == "Zendesk" ? [1] : []
        content {
          object = var.source_zendesk_properties.object
        }
      }
      dynamic "slack" {
        for_each = var.flow_source == "Slack" ? [1] : []
        content {
          object = var.source_slack_properties.object
        }
      }
      dynamic "custom_connector" {
        for_each = var.flow_source == "CustomConnector" ? [1] : []
        content {
          entity_name       = var.source_custom_connector_properties.entity_name
          custom_properties = var.source_custom_connector_properties.custom_properties
        }
      }
      dynamic "salesforce" {
        for_each = var.flow_source == "Salesforce" ? [1] : []
        content {
          object                      = var.source_salesforce_properties.object
          enable_dynamic_field_update = var.source_salesforce_properties.enable_dynamic_field_update
          include_deleted_records     = var.source_salesforce_properties.include_deleted_records
        }
      }
      dynamic "sapo_data" {
        for_each = var.flow_source == "SAPOData" ? [1] : []
        content {
          object_path = var.source_sapo_data_properties.object_path
          pagination_config {
            max_page_size = var.source_sapo_data_properties.max_page_size
          }
          parallelism_config {
            max_parallelism = var.source_sapo_data_properties.max_parallelism
          }
        }
      }
      dynamic "veeva" {
        for_each = var.flow_source == "Veeva" ? [1] : []
        content {
          object               = var.source_veeva_properties.object
          document_type        = var.source_veeva_properties.document_type
          include_all_versions = var.source_veeva_properties.include_all_versions
          include_renditions   = var.source_veeva_properties.include_renditions
          include_source_files = var.source_veeva_properties.include_source_files
        }
      }

    }
  }

  destination_flow_config {
    connector_type         = var.destination
    api_version            = var.destination_api_version
    connector_profile_name = var.destination_connector_profile_name
    destination_connector_properties {
      dynamic "s3" {
        for_each = var.destination == "S3" ? [1] : []
        content {
          bucket_name   = var.destination_s3_properties.bucket_name
          bucket_prefix = var.destination_s3_properties.bucket_prefix
          s3_output_format_config {
            file_type                   = var.destination_s3_properties.file_type
            preserve_source_data_typing = var.destination_s3_properties.preserve_source_data_typing
            aggregation_config {
              aggregation_type = var.destination_s3_properties.aggregation_type
              target_file_size = var.destination_s3_properties.target_file_size
            }
            prefix_config {
              prefix_type      = var.destination_s3_properties.prefix_type
              prefix_format    = var.destination_s3_properties.prefix_format
              prefix_hierarchy = var.destination_s3_properties.prefix_hierarchy
            }
          }
        }
      }
      dynamic "event_bridge" {
        for_each = var.destination == "EventBridge" ? [1] : []
        content {
          object = var.destination_event_bridge_properties.object
          error_handling_config {
            bucket_name                     = var.destination_event_bridge_properties.error_bucket_name
            bucket_prefix                   = var.destination_event_bridge_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_event_bridge_properties.fail_on_first_error
          }
        }
      }
      dynamic "honeycode" {
        for_each = var.destination == "Honeycode" ? [1] : []
        content {
          object = var.destination_honeycode_properties.object
          error_handling_config {
            bucket_name                     = var.destination_honeycode_properties.error_bucket_name
            bucket_prefix                   = var.destination_honeycode_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_honeycode_properties.fail_on_first_error
          }
        }
      }
      dynamic "marketo" {
        for_each = var.destination == "Marketo" ? [1] : []
        content {
          object = var.destination_marketo_properties.object
          error_handling_config {
            bucket_name                     = var.destination_marketo_properties.error_bucket_name
            bucket_prefix                   = var.destination_marketo_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_marketo_properties.fail_on_first_error
          }
        }
      }
      dynamic "redshift" {
        for_each = var.destination == "Redshift" ? [1] : []
        content {
          object                   = var.destination_redshift_properties.object
          intermediate_bucket_name = var.destination_redshift_properties.intermediate_bucket_name
          bucket_prefix            = var.destination_redshift_properties.intermediate_bucket_prefix
          error_handling_config {
            bucket_name                     = var.destination_redshift_properties.error_bucket_name
            bucket_prefix                   = var.destination_redshift_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_redshift_properties.fail_on_first_error
          }
        }

      }
      dynamic "salesforce" {
        for_each = var.destination == "Salesforce" ? [1] : []
        content {
          object               = var.destination_salesforce_properties.object
          id_field_names       = var.destination_salesforce_properties.id_field_names
          write_operation_type = var.destination_salesforce_properties.write_operation_type
          error_handling_config {
            bucket_name                     = var.destination_salesforce_properties.error_bucket_name
            bucket_prefix                   = var.destination_salesforce_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_salesforce_properties.fail_on_first_error
          }
        }
      }
      dynamic "sapo_data" {
        for_each = var.destination == "SAPOData" ? [1] : []
        content {
          object_path          = var.destination_sapo_data_properties.object
          id_field_names       = var.destination_sapo_data_properties.id_field_names
          write_operation_type = var.destination_sapo_data_properties.write_operation_type
          success_response_handling_config {
            bucket_name   = var.destination_sapo_data_properties.success_bucket_name
            bucket_prefix = var.destination_sapo_data_properties.success_bucket_prefix
          }
          error_handling_config {
            bucket_name                     = var.destination_sapo_data_properties.error_bucket_name
            bucket_prefix                   = var.destination_sapo_data_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_sapo_data_properties.fail_on_first_error
          }
        }

      }
      dynamic "snowflake" {
        for_each = var.destination == "Snowflake" ? [1] : []
        content {
          object                   = var.destination_snowflake_properties.object
          intermediate_bucket_name = var.destination_snowflake_properties.intermediate_bucket_name
          bucket_prefix            = var.destination_snowflake_properties.intermediate_bucket_prefix
          error_handling_config {
            bucket_name                     = var.destination_snowflake_properties.error_bucket_name
            bucket_prefix                   = var.destination_snowflake_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_snowflake_properties.fail_on_first_error
          }
        }

      }
      dynamic "upsolver" {
        for_each = var.destination == "Upsolver" ? [1] : []
        content {
          bucket_name   = var.destination_upsolver_properties.bucket_name
          bucket_prefix = var.destination_upsolver_properties.bucket_prefix
          s3_output_format_config {
            file_type = var.destination_upsolver_properties.file_type
            aggregation_config {
              aggregation_type = var.destination_upsolver_properties.aggregation_type
            }
            prefix_config {
              prefix_type      = var.destination_upsolver_properties.prefix_type
              prefix_format    = var.destination_upsolver_properties.prefix_format
              prefix_hierarchy = var.destination_upsolver_properties.prefix_hierarchy
            }
          }
        }
      }
      dynamic "zendesk" {
        for_each = var.destination == "Zendesk" ? [1] : []
        content {
          object               = var.destination_zendesk_properties.object
          id_field_names       = var.destination_zendesk_properties.id_field_names
          write_operation_type = var.destination_zendesk_properties.write_operation_type
          error_handling_config {
            bucket_name                     = var.destination_zendesk_properties.error_bucket_name
            bucket_prefix                   = var.destination_zendesk_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_zendesk_properties.fail_on_first_error
          }
        }

      }
      dynamic "custom_connector" {
        for_each = var.destination == "CustomConnector" ? [1] : []
        content {
          entity_name          = var.destination_custom_connector_properties.entity_name
          custom_properties    = var.destination_custom_connector_properties.custom_properties
          id_field_names       = var.destination_custom_connector_properties.id_field_names
          write_operation_type = var.destination_custom_connector_properties.write_operation_type
          error_handling_config {
            bucket_name                     = var.destination_custom_connector_properties.error_bucket_name
            bucket_prefix                   = var.destination_custom_connector_properties.error_bucket_prefix
            fail_on_first_destination_error = var.destination_custom_connector_properties.fail_on_first_error
          }
        }
      }
      dynamic "customer_profiles" {
        for_each = var.destination == "CustomerProfiles" ? [1] : []
        content {
          domain_name      = var.destination_custom_profile_properties.domain_name
          object_type_name = var.destination_custom_profile_properties.object_type_name
        }
      }
    }
  }

  dynamic "task" {
    for_each = var.tasks
    content {
      task_type         = task.value["task_type"]
      source_fields     = task.value["source_fields"]
      destination_field = lookup(task.value, "destination_field", null)
      task_properties   = lookup(task.value, "task_properties", {})
      connector_operator {
        s3               = var.flow_source == "S3" ? lookup(task.value, "connector_operator", null) : null
        amplitude        = var.flow_source == "Amplitude" ? lookup(task.value, "connector_operator", null) : null
        custom_connector = var.flow_source == "CustomConnector" ? lookup(task.value, "connector_operator", null) : null
        datadog          = var.flow_source == "Datadog" ? lookup(task.value, "connector_operator", null) : null
        dynatrace        = var.flow_source == "Dynatrace" ? lookup(task.value, "connector_operator", null) : null
        google_analytics = var.flow_source == "Googleanalytics" ? lookup(task.value, "connector_operator", null) : null
        infor_nexus      = var.flow_source == "Infornexus" ? lookup(task.value, "connector_operator", null) : null
        marketo          = var.flow_source == "Marketo" ? lookup(task.value, "connector_operator", null) : null
        salesforce       = var.flow_source == "Salesforce" ? lookup(task.value, "connector_operator", null) : null
        sapo_data        = var.flow_source == "SAPOData" ? lookup(task.value, "connector_operator", null) : null
        service_now      = var.flow_source == "Servicenow" ? lookup(task.value, "connector_operator", null) : null
        singular         = var.flow_source == "Singular" ? lookup(task.value, "connector_operator", null) : null
        trendmicro       = var.flow_source == "Trendmicro" ? lookup(task.value, "connector_operator", null) : null
        slack            = var.flow_source == "Slack" ? lookup(task.value, "connector_operator", null) : null
        veeva            = var.flow_source == "Veeva" ? lookup(task.value, "connector_operator", null) : null
        zendesk          = var.flow_source == "Zendesk" ? lookup(task.value, "connector_operator", null) : null
      }
    }
  }

  dynamic "metadata_catalog_config" {
    for_each = var.enable_glue_catalog ? [1] : []
    content {
      glue_data_catalog {
        database_name = var.glue_database_name
        role_arn      = var.create_glue_role ? aws_iam_role.glue[0].arn : var.glue_role_arn
        table_prefix  = var.glue_table_name
      }
    }
  }

  trigger_config {
    trigger_type = var.trigger_type
    dynamic "trigger_properties" {
      for_each = var.trigger_type == "Scheduled" ? [1] : []
      content {
        scheduled {
          schedule_expression  = var.trigger_schedule_expression
          data_pull_mode       = var.trigger_data_pull_mode
          first_execution_from = var.trigger_first_execution_from
          schedule_start_time  = var.trigger_schedule_start_time
          schedule_end_time    = var.trigger_schedule_end_time
          schedule_offset      = var.trigger_schedule_offset
          timezone             = var.trigger_timezone
        }
      }
    }
  }

  tags = var.tags
}